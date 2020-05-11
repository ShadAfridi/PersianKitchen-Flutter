import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Meal with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String imgUrl;
  bool isFavorite;

  Meal(
      {@required this.id,
      @required this.description,
      @required this.category,
      @required this.title,
      @required this.price,
      this.isFavorite = false,
      @required this.imgUrl});

  factory Meal.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Meal(
        id: doc.documentID,
        title: data['title'],
        category: data['category'],
        description: data['description'],
        price: data['price'],
        imgUrl: data['url']);
  }

  void toggleIsFavorite(id) async {
    isFavorite = !isFavorite;
    var user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('users')
        .document('${user.uid}')
        .collection('favorite')
        .document('$id')
        .setData({
      'isFavorite': isFavorite,
    });
    Firestore.instance
        .collection('users')
        .document('${user.uid}')
        .setData({'dummy': 'dummy'});
  }
}
