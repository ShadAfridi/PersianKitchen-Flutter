import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:persian_kitchen/helpers/database_helpers.dart';
import './meal.dart';

class Meals with ChangeNotifier {
  List<Meal> _items = [];

  List<Meal> get items {
    return [..._items];
  }

  Future<void> createMeal(Meal meal, File img) async {
    Map<String, dynamic> data = {
      'title': meal.title,
      'price': meal.price,
      'category': meal.category,
      'description': meal.description,
      'imgId': '',
      'url': '',
    };
    await DataBaseHelpers().addData(data, img);
    notifyListeners();
  }

  Future<void> delete(String id) async {
    try {
      await DataBaseHelpers().delete(id);
    } catch (err) {
      throw err;
    }
    notifyListeners();
  }
}
