import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal.dart';
import '../widgets/meal_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class FavoritesTab extends StatefulWidget {
  @override
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  List<String> _favs;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null && mounted) {
        Firestore.instance
            .collection('users')
            .document('${user.uid}')
            .collection('favorite')
            .getDocuments()
            .then((snap) {
          List<String> favs = [];
          snap
            ..documents.forEach((meal) {
              if (meal.data['isFavorite'] == true) {
                favs.add(meal.documentID.toString());
              }
            });
          if (mounted) {
            setState(() {
              _favs = favs;
            });
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Meal> favList = [];
    var meals = Provider.of<List<Meal>>(context);
    if (_favs != null && meals != null) {
      meals.forEach((meal) {
        var isFav = _favs.where((fav) {
          return fav == meal.id;
        }).toList();
        if (isFav.isNotEmpty) {
          if (meal.id == isFav[0]) {
            favList.add(meal);
          }
        }
      });
    } else {
      return Center(
          child: Container(
              width: 50,
              height: 50,
              child: Image.asset('assets/images/heart.gif')));
    }

    return favList.length != 0
        ? ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 65),
              itemCount: favList.length,
              itemBuilder: (ctx, i) {
                return ChangeNotifierProvider.value(
                  value: favList[i],
                  child: MealItem(),
                );
              },
            ))
        : Center(
            child: Text('No Favorites'),
          );
  }
}
