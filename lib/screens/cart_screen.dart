import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart';
import '../widgets/cart_options.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String location;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<List<Cart>>(context);
    List<CartItem> cartItems = [];
    double totalPrice = 0;
    double deliveryCharge = 0;
    if (cartData != null) {
      cartData.forEach((item) {
        cartItems.add(
          CartItem(
            id: item.id,
            category: item.category,
            price: item.price,
            quantity: item.quantity,
            title: item.title,
          ),
        );
      });
      cartItems.forEach((item) {
        totalPrice = (item.price * item.quantity) + totalPrice;
      });
      if (totalPrice < 500) {
        deliveryCharge = 10;
      }
    }
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text('Cart is empty'),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ...cartItems,
                  Divider(
                    indent: 25,
                    endIndent: 25,
                    color: Theme.of(context).accentColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Amount',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '₹ $totalPrice',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: (totalPrice) < 1000 ? 15 : 13,
                              fontWeight: (totalPrice) < 1000
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                              letterSpacing: (totalPrice) < 100 ? 1.9 : null),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Delivery Charge',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '₹ $deliveryCharge',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: (totalPrice) < 1000 ? 15 : 13,
                              fontWeight: (totalPrice) < 1000
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                              letterSpacing: (totalPrice) < 100 ? 1.9 : null),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 25,
                    endIndent: 25,
                    color: Theme.of(context).accentColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '₹ ${totalPrice + deliveryCharge}',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: (totalPrice) < 1000 ? 20 : 17,
                              fontWeight: (totalPrice) < 1000
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                              letterSpacing: (totalPrice) < 100 ? 1.9 : null),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CartOptions(),
                ],
              ),
            ),
    );
  }
}
