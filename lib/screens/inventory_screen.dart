import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import '../screens/edit_meal_screen.dart';
import '../providers/meal.dart';
import '../widgets/inventory_item.dart';

class InventoryScreen extends StatelessWidget {
  static const routeName = '/inventory-screen';
  @override
  Widget build(BuildContext context) {
    ConnectivityResult connect = Provider.of<ConnectivityResult>(context);
    var mealData = Provider.of<List<Meal>>(context);
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
            'Inventory',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          actions: connect == ConnectivityResult.none
              ? null
              : <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).pushNamed(EditMealScreen.routeName);
                    },
                  ),
                ]),
      body: mealData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : connect == ConnectivityResult.none
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
              : mealData.isEmpty
                  ? Center(
                      child: Text('Inventory is empty'),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount: mealData.length,
                      itemBuilder: (_, i) {
                        return Column(
                          children: <Widget>[
                            InventoryItem(
                              mealData[i].id,
                              mealData[i].title,
                              mealData[i].imgUrl,
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
    );
  }
}
