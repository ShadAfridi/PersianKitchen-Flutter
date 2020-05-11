import 'package:flutter/material.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'Meal Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}
