import 'package:flutter/material.dart';

class CartCounter extends StatelessWidget {
  final int counter;
  CartCounter(this.counter);
  @override
  Widget build(BuildContext context) {
    return Text(
      counter.toString(),
      style: TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: counter > 9 ? 8 : 10,
          fontWeight: FontWeight.bold),
    );
  }
}
