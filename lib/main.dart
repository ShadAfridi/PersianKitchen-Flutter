import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './helpers/database_helpers.dart';
import './screens/meal_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/inventory_screen.dart';
import './screens/home_screen.dart';
import './screens/edit_meal_screen.dart';
import './screens/auth_screen.dart';
import './providers/meal.dart';
import './providers/meals.dart';
import './providers/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.redAccent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Meals(),
          child: InventoryScreen(),
        ),
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
        StreamProvider<ConnectivityResult>.value(
          value: Connectivity().onConnectivityChanged,
        ),
        StreamProvider<List<Meal>>.value(
          value: DataBaseHelpers().streamMeals(),
          catchError: (ctx, err) {
            return null;
          },
          child: InventoryScreen(),
        ),
        StreamProvider<List<Cart>>.value(
          value: CartFunctions().streamCart(),
          catchError: (ctx, e) {
            return null;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Persian Kitchen',
        theme: ThemeData(
          splashColor: Color.fromRGBO(255, 0, 0, 0.2),
          highlightColor: Colors.transparent,
          canvasColor: Colors.white,
          primarySwatch: Colors.red,
          accentColor: Colors.redAccent,
          fontFamily: 'Nunito',
        ),
        home: StreamBuilder<FirebaseUser>(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomeScreen();
              } else {
                return AuthScreen();
              }
            }),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          EditMealScreen.routeName: (ctx) => EditMealScreen(),
          InventoryScreen.routeName: (ctx) => InventoryScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          MealDetailScreen.routeName: (ctx) => MealDetailScreen()
        },
      ),
    );
  }
}
