import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String category;
  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity,
      @required this.category});

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  bool _isAdding = false;
  bool _isRemoving = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '${widget.quantity.toString()} x',
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: widget.quantity < 10 ? 20 : 14,
                fontWeight:
                    widget.quantity < 10 ? FontWeight.normal : FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 17),
            ),
          ),
          RawMaterialButton(
            shape: CircleBorder(),
            fillColor: Colors.white,
            constraints: BoxConstraints(
                minWidth: 25, minHeight: 25, maxHeight: 25, maxWidth: 25),
            disabledElevation: 3,
            focusElevation: 3,
            highlightElevation: 3,
            hoverElevation: 3,
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            padding: _isAdding ? EdgeInsets.all(0) : EdgeInsets.all(0),
            child: _isAdding
                ? SpinKitFadingGrid(
                    size: 14,
                    duration: Duration(milliseconds: mounted ? 1200 : 0),
                    itemBuilder: (ctx, index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index.isOdd
                              ? Theme.of(context).accentColor
                              : Colors.transparent,
                        ),
                      );
                    },
                  )
                : Icon(
                    Icons.add,
                    color: Colors.redAccent,
                  ),
            onPressed: () async {
              if (mounted) {
                setState(() {
                  _isAdding = true;
                });
              }
              await CartFunctions().addData(widget.id);
              if (mounted) {
                setState(() {
                  _isAdding = false;
                });
              }
            },
          ),
          RawMaterialButton(
            shape: CircleBorder(),
            fillColor: Colors.white,
            constraints: BoxConstraints(
                minWidth: 25, minHeight: 25, maxHeight: 25, maxWidth: 25),
            padding: _isRemoving ? EdgeInsets.all(0) : EdgeInsets.all(0),
            disabledElevation: 3,
            focusElevation: 3,
            highlightElevation: 3,
            hoverElevation: 3,
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            child: _isRemoving
                ? SpinKitThreeBounce(
                    size: 9,
                    duration: Duration(milliseconds: mounted ? 1200 : 0),
                    itemBuilder: (ctx, index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index.isOdd
                              ? Theme.of(context).accentColor
                              : Theme.of(context).accentColor,
                        ),
                      );
                    },
                  )
                : Icon(
                    Icons.remove,
                    color: Colors.redAccent,
                  ),
            onPressed: () async {
              if (mounted) {
                setState(() {
                  _isRemoving = true;
                });
              }
              await CartFunctions().removeData(widget.id);
              if (mounted) {
                setState(() {
                  _isRemoving = false;
                });
              }
            },
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '₹ ${(widget.price * widget.quantity).toString()}',
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: (widget.price * widget.quantity) < 1000 ? 20 : 17,
                fontWeight: (widget.price * widget.quantity) < 1000
                    ? FontWeight.normal
                    : FontWeight.w600,
                letterSpacing:
                    (widget.price * widget.quantity) < 100 ? 1.9 : null),
          )
        ],
      ),
    );
  }
}
