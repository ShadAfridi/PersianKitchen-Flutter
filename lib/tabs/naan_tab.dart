import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal.dart';
import '../widgets/meal_item.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class NaanTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mealData = Provider.of<List<Meal>>(context);
    List<Meal> meals;
    if (mealData != null) {
      meals = mealData.where((meal) {
        return meal.category == 'Naan';
      }).toList();
    } else {
      meals = null;
    }

    return meals == null
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
                  'An unexpected error occurred',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).errorColor),
                )
              ],
            ),
          )
        : meals.length == 0
            ? Center(
                child: Text('Naans not available at this moment'),
              )
            : ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 65),
                  itemCount: meals.length,
                  itemBuilder: (ctx, i) {
                    return ChangeNotifierProvider.value(
                      value: meals[i],
                      child: MealItem(),
                    );
                  },
                ));
  }
}
