import 'package:flutter/material.dart';
import 'package:persian_kitchen/providers/auth.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/home_screen.dart';
import '../screens/inventory_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  final bool isAdmin;
  AppDrawer(this.isAdmin);
  @override
  Widget build(BuildContext context) {
    FirebaseUser details = Provider.of<FirebaseUser>(context, listen: false);
    String firstName = details.displayName.trim().split(' ')[0];
    return Drawer(
      child: Container(
        color: Colors.redAccent,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15),
              margin: EdgeInsets.symmetric(horizontal: 30),
              height: (MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top) *
                  0.19,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage: details.photoUrl == null
                          ? AssetImage('assets/images/Logo.png')
                          : NetworkImage(details.photoUrl),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      firstName,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: firstName.length >= 12 ? 18 : 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    FlatButton.icon(
                      padding: EdgeInsets.all(20),
                      icon: Icon(
                        Icons.restaurant_menu,
                        color: Colors.red[600],
                        size: 25,
                      ),
                      label: Text(
                        'Menu',
                        style: TextStyle(color: Colors.red[600], fontSize: 25),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushReplacementNamed(HomeScreen.routeName);
                      },
                    ),
                    FlatButton.icon(
                      padding: EdgeInsets.all(20),
                      icon: Icon(
                        Icons.list,
                        color: Colors.red[600],
                        size: 30,
                      ),
                      label: Text(
                        'Orders',
                        style: TextStyle(color: Colors.red[600], fontSize: 25),
                      ),
                      onPressed: () {},
                    ),
                    FlatButton.icon(
                        padding: EdgeInsets.all(20),
                        icon: Icon(
                          isAdmin ? Icons.store : Icons.pages,
                          color: Colors.red[600],
                          size: 25,
                        ),
                        label: isAdmin
                            ? Text(
                                'Inventory',
                                style: TextStyle(
                                    color: Colors.red[600], fontSize: 25),
                              )
                            : Text(
                                'Feedback',
                                style: TextStyle(
                                    color: Colors.red[600], fontSize: 25),
                              ),
                        onPressed: isAdmin
                            ? () {
                                Navigator.of(context)
                                    .popAndPushNamed(InventoryScreen.routeName);
                              }
                            : () {}),
                    FlatButton.icon(
                      padding: EdgeInsets.all(20),
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.red[600],
                        size: 25,
                      ),
                      label: Text(
                        'About',
                        style: TextStyle(color: Colors.red[600], fontSize: 25),
                      ),
                      onPressed: () {},
                    ),
                    FlatButton.icon(
                      padding: EdgeInsets.all(20),
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.red[600],
                        size: 25,
                      ),
                      label: Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.red[600], fontSize: 25),
                      ),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Text(
                              'Are you sure?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            titlePadding: EdgeInsets.only(top: 20),
                            contentPadding:
                                EdgeInsets.only(top: 30, bottom: 20),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).errorColor),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pushReplacementNamed('/');
                                    await AuthService().signOut();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
