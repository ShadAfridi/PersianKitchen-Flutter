import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import '../helpers/database_helpers.dart';
import '../tabs/curry_tab.dart';
import '../tabs/combo_tab.dart';
import '../tabs/favorites_tab.dart';
import '../tabs/naan_tab.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../widgets/cart_counter.dart';
import '../widgets/location_footer.dart';
import '../providers/meal.dart';
import '../providers/cart.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  final admin = DataBaseHelpers().isAdmin();
  @override
  Widget build(BuildContext context) {
    ConnectivityResult connect = Provider.of<ConnectivityResult>(context);

    return MultiProvider(
      providers: [
        StreamProvider<List<Meal>>.value(
          value: DataBaseHelpers().streamMeals(),
          catchError: (ctx, err) {
            return null;
          },
        ),
        FutureProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.currentUser(),
        ),
      ],
      child: FutureBuilder(
        future: admin,
        builder: (ctx, snapshot) {
          bool isAdmin;
          if (snapshot.hasData) {
            isAdmin = true;
          } else {
            isAdmin = false;
          }
          return DefaultTabController(
              length: 4,
              child: Scaffold(
                drawer: connect == ConnectivityResult.none
                    ? null
                    : AppDrawer(isAdmin),
                appBar: AppBar(
                  iconTheme: IconThemeData(size: 28, color: Colors.white),
                  elevation: 5,
                  brightness: Brightness.dark,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(80),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.transparent,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, letterSpacing: 1),
                        labelColor: Theme.of(context).accentColor,
                        unselectedLabelColor: Colors.black,
                        tabs: <Widget>[
                          Tab(
                            icon: Icon(
                              Icons.favorite,
                            ),
                            text: 'Fave',
                          ),
                          Tab(
                            icon: Icon(
                              Icons.restaurant,
                            ),
                            text: 'Meals',
                          ),
                          Tab(
                            icon: Icon(Icons.local_pizza),
                            text: 'Naan',
                          ),
                          Tab(
                            icon: Icon(Icons.cake),
                            text: 'Curry',
                          ),
                        ],
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).accentColor,
                  title: Text(
                    'Persian Kitchen',
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 26,
                    ),
                  ),
                  actions: connect == ConnectivityResult.none
                      ? null
                      : <Widget>[
                          Stack(
                              alignment: AlignmentDirectional.lerp(
                                  AlignmentDirectional.topCenter,
                                  AlignmentDirectional.center,
                                  0.8),
                              children: <Widget>[
                                IconButton(
                                  splashColor: Colors.black12,
                                  icon: Icon(Icons.shopping_cart),
                                  iconSize: 28,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(CartScreen.routeName);
                                  },
                                ),
                                Consumer<List<Cart>>(
                                  builder: (_, cartData, ch) {
                                    int length = 0;
                                    if (cartData == null) {
                                      length = 0;
                                    } else {
                                      length = cartData.length;
                                    }
                                    return CartCounter(length);
                                  },
                                )
                              ])
                        ],
                ),
                body: connect == ConnectivityResult.none
                    ? Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.error,
                              color: Theme.of(context).errorColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Seems like you\'re offline',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).errorColor),
                            )
                          ],
                        ),
                      )
                    : Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                            TabBarView(
                              physics: PageScrollPhysics(),
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: FavoritesTab(),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: ComboTab(),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: NaanTab(),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: CurryTab(),
                                ),
                              ],
                            ),
                            LocationFooter(),
                          ]),
              ));
        },
      ),
    );
  }
}
