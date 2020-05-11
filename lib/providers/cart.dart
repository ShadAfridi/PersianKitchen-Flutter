import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class Cart {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String category;
  Cart(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity,
      @required this.category});

  factory Cart.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Cart(
      id: doc.documentID,
      title: data['title'],
      category: data['category'],
      quantity: data['quantity'],
      price: data['price'],
    );
  }
}

class CartFunctions {
  Future<void> addData(String id, {Map<String, dynamic> data}) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    String docId = id;

    DocumentSnapshot initialData = await Firestore.instance
        .collection('users')
        .document('$uid')
        .collection('cart')
        .document('$docId')
        .get();

    if (initialData.data == null) {
      await Firestore.instance
          .collection('users')
          .document('$uid')
          .collection('cart')
          .document('$docId')
          .setData(data);
      await Firestore.instance
          .collection('users')
          .document('${user.uid}')
          .setData({'dummy': 'dummy'});
    } else {
      int quantity = initialData.data['quantity'];
      int newQuantity = quantity + 1;
      await Firestore.instance
          .collection('users')
          .document('$uid')
          .collection('cart')
          .document('$docId')
          .updateData({'quantity': newQuantity});
    }
  }

  Future<void> removeData(String id) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    String docId = id;

    DocumentSnapshot initialData = await Firestore.instance
        .collection('users')
        .document('$uid')
        .collection('cart')
        .document('$docId')
        .get();

    if (initialData.data['quantity'] == 1) {
      await Firestore.instance
          .collection('users')
          .document('$uid')
          .collection('cart')
          .document('$docId')
          .delete();
    } else {
      int quantity = initialData.data['quantity'];
      int newQuantity = quantity - 1;
      await Firestore.instance
          .collection('users')
          .document('$uid')
          .collection('cart')
          .document('$docId')
          .updateData({'quantity': newQuantity});
    }
  }

  Stream<List<Cart>> streamCart() {
    Stream<FirebaseUser> user;

    user = FirebaseAuth.instance.onAuthStateChanged;
    if (user != null) {
      return user.switchMap((u) {
        String uid = u.uid;
        var ref = Firestore.instance
            .collection('users')
            .document('$uid')
            .collection('cart');
        return ref.snapshots().map((snap) =>
            snap.documents.map((doc) => Cart.fromFirestore(doc)).toList());
      });
    } else {
      return null;
    }
  }
}
