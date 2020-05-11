import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../providers/meal.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class DataBaseHelpers {
  var uuid = new Uuid(options: {'grng': UuidUtil.cryptoRNG});

  Future<void> addData(Map<String, dynamic> data, File img) async {
    String name = uuid.v4();
    String url = await postImage(name, img);
    Map<String, dynamic> uploadData = data;
    uploadData['url'] = url;
    uploadData['imgId'] = name;
    await Firestore.instance.collection('meal').add(uploadData).catchError((e) {
      throw e;
    });
  }

  Future<String> postImage(String name, File img) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('$name');
    StorageUploadTask uploadTask = storageReference.putFile(img);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url.toString();
  }

  Stream<List<Meal>> streamMeals() {
    var ref = Firestore.instance.collection('meal');
    return ref.snapshots().map((snap) =>
        snap.documents.map((doc) => Meal.fromFirestore(doc)).toList());
  }

  Future<DocumentSnapshot> isAdmin() async {
    Future<DocumentSnapshot> admin =
        Firestore.instance.collection('admin').document('admin').get();

    return admin;
  }

  Future<void> delete(String id) async {
    try {
      var doc =
          await Firestore.instance.collection('meal').document('$id').get();
      String name = doc.data['imgId'];
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('$name');
      await storageReference.delete();
      await Firestore.instance.collection('meal').document('$id').delete();
      await Firestore.instance
          .collectionGroup('users')
          .getDocuments()
          .then((snap) {
        snap.documents.forEach((doc) {
          Firestore.instance
              .collection('users')
              .document('${doc.documentID}')
              .collection('favorite')
              .document(id)
              .delete();
          Firestore.instance
              .collection('users')
              .document('${doc.documentID}')
              .collection('cart')
              .document(id)
              .delete();
        });
      });
    } catch (err) {
      throw err;
    }
  }
}
