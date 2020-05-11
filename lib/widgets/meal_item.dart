import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../providers/meal.dart';
import '../providers/cart.dart';
import '../screens/meal_detail_screen.dart';

class MealItem extends StatefulWidget {
  @override
  _MealItemState createState() => _MealItemState();
}

class _MealItemState extends State<MealItem> {
  bool _isLoading = false;
  bool _isAdded = false;
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    String uid = user.uid;
    final meal = Provider.of<Meal>(context);
    final price = double.parse(meal.price.toStringAsFixed(2));
    final titleList = meal.title.trim().split(' ');

    String title;
    double size = 22;
    if (titleList.length == 2) {
      if (titleList[0].length > 10) {
        title = '${titleList[0]}\n'
            '${titleList[1]}';
      } else {
        title = meal.title.trim();
      }
    } else if (titleList.length == 3) {
      title = '${titleList[0]} ${titleList[1]}\n'
          '${titleList[2]}';
    } else if (titleList.length > 3) {
      size = 16;
      title = meal.title.trim();
    } else {
      title = meal.title.trim();
    }
    return StreamBuilder<bool>(
      stream: Firestore.instance
          .collection('users')
          .document('$uid')
          .collection('favorite')
          .document('${meal.id}')
          .snapshots()
          .map((meal) {
        return meal['isFavorite'];
      }),
      initialData: false,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(MealDetailScreen.routeName);
          },
          child: Card(
            elevation: 2,
            margin: EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.22,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: meal.imgUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, str) => Align(
                            alignment: Alignment.bottomCenter,
                            child: LinearProgressIndicator(),
                          ),
                          errorWidget: (context, str, error) => Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.error_outline,
                                  color: Theme.of(context).errorColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'An Error Occurred',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).errorColor),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        splashColor: Colors.transparent,
                        icon: snapshot.hasData
                            ? Icon(
                                snapshot.data
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red[600],
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Colors.red[600],
                              ),
                        onPressed: () {
                          meal.toggleIsFavorite(meal.id);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 0),
                        child: Text(
                          '₹$price',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: size,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: _isAdded
                            ? Container(
                                height: 48,
                                width: 48,
                                padding: EdgeInsets.all(8),
                                child: FlareActor(
                                  'assets/animations/Cart.flr',
                                  animation: 'Success Outline',
                                  color: Theme.of(context).accentColor,
                                ),
                              )
                            : _isLoading
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(11),
                                        child: SpinKitRing(
                                          duration: Duration(milliseconds: 800),
                                          size: 26,
                                          lineWidth: 1.5,
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: Theme.of(context).accentColor,
                                        size: 18,
                                      )
                                    ],
                                  )
                                : IconButton(
                                    icon: Icon(Icons.add_shopping_cart),
                                    onPressed: () async {
                                      Map<String, dynamic> data = {
                                        'title': meal.title,
                                        'quantity': 1,
                                        'price': meal.price,
                                        'category': meal.category
                                      };
                                      if (mounted) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                      }
                                      await CartFunctions()
                                          .addData(meal.id, data: data);
                                      if (mounted) {
                                        setState(() {
                                          _isLoading = false;
                                          _isAdded = true;
                                        });
                                        await Future.delayed(
                                            Duration(milliseconds: 1700));
                                        setState(() {
                                          _isAdded = false;
                                        });
                                      }
                                    },
                                  ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
