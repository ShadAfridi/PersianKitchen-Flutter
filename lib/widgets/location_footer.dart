import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../helpers/location_helpers.dart';

class LocationFooter extends StatefulWidget {
  @override
  _LocationFooterState createState() => _LocationFooterState();
}

class _LocationFooterState extends State<LocationFooter> {
  String location = '';
  bool _isLoading;
  bool _showError;
  bool _locError;
  @override
  void initState() {
    _setLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: (_showError != null && _showError == true)
          ? MediaQuery.of(context).size.height * 0.26
          : 50,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
      ),
      child: (_showError != null && _showError == true)
          ? AnimatedOpacity(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 300),
              opacity: (_showError != null && _showError == true) ? 1 : 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        _locError
                            ? 'Error Finding Location'
                            : 'Out of Service Area',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        _locError
                            ? 'We could not find your location or a valid route to your location. Please check your location settings.'
                            : 'We currently do not provide our delivery services in your area! You can still place an order and pick it up from our nearest kitchen or try placing an order through Zomato.',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontSize: _locError ? 19 : 16,
                            color: Colors.white70),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Align(
                      alignment: Alignment.center,
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        fillColor: Colors.white,
                        constraints: BoxConstraints(
                          minWidth: 88,
                          minHeight: 36,
                        ),
                        disabledElevation: 3,
                        focusElevation: 3,
                        highlightElevation: 3,
                        hoverElevation: 3,
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        child: Text(_locError ? 'Retry' : 'Okay'),
                        onPressed: () {
                          _locError
                              ? _setLocation()
                              : setState(() {
                                  _showError = false;
                                });
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                ),
                _isLoading
                    ? Expanded(
                        child: SpinKitThreeBounce(
                        size: 20,
                        itemBuilder: (ctx, index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index.isOdd ? Colors.white : Colors.white,
                            ),
                          );
                        },
                      ))
                    : Expanded(
                        child: Text(location,
                            style: TextStyle(
                                color: Colors.white, fontSize: 19.5))),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      splashColor: Colors.transparent,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      icon: Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _setLocation();
                      }),
                ),
              ],
            ),
    );
  }

  void _setLocation() {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _locError = false;
        _showError = false;
      });
    }
    LocationHelpers().getLocation().then((loc) {
      if (loc['permission'] != false) {
        LocationHelpers().isNear(loc['position']).then((isNear) {
          if (mounted) {
            setState(() {
              _showError = !isNear;
              location = loc['location'];
              _isLoading = false;
              _locError = false;
            });
          }
        }).catchError((err) {
          if (mounted) {
            setState(() {
              _showError = true;
              _locError = true;
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            _showError = true;
            _locError = true;
          });
        }
      }
    }).catchError((err) {
      if (mounted) {
        setState(() {
          _showError = true;
          _locError = true;
        });
      }
    });
  }
}
