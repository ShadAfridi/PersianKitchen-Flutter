import 'package:flutter/material.dart';
import '../helpers/location_helpers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class CartOptions extends StatefulWidget {
  @override
  _CartOptionsState createState() => _CartOptionsState();
}

class _CartOptionsState extends State<CartOptions> {
  List<bool> _isSelected = [true, false];
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _showError;
  String location = '';
  bool _locError;
  @override
  void initState() {
    _setLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _locError
        ? Container(
            margin: EdgeInsets.only(
                top: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) *
                    0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'We could not find your location or a valid route to your location! Please check your location settings our your internet connection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 19, color: Theme.of(context).accentColor),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    fillColor: Theme.of(context).accentColor,
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
                    child: Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _setLocation();
                    },
                  ),
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ToggleButtons(
                renderBorder: false,
                color: Colors.black,
                splashColor: Colors.transparent,
                selectedColor: Theme.of(context).accentColor,
                fillColor: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_bike),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Delivery')
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.store),
                        SizedBox(
                          width: 10,
                        ),
                        Text('PickUp')
                      ],
                    ),
                  ),
                ],
                onPressed: (_showError == true || _showError == null)
                    ? null
                    : (int index) {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < _isSelected.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              _isSelected[buttonIndex] = true;
                              _selectedIndex = index;
                            } else {
                              _isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                isSelected: _isSelected,
              ),
              AnimatedContainer(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(0),
                duration: Duration(milliseconds: mounted ? 300 : 0),
                margin: _selectedIndex == 0
                    ? EdgeInsets.only(left: 0)
                    : EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.5,
                        right: 0),
                child: Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  color: Colors.redAccent,
                  height: 2,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              (_isLoading && mounted)
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: (MediaQuery.of(context).size.height -
                                    MediaQuery.of(context).padding.top) *
                                0.2),
                        height: 100,
                        width: 100,
                        child: FlareActor(
                          'assets/animations/Location.flr',
                          animation: 'searching',
                        ),
                      ))
                  : Align(
                      alignment: Alignment.topLeft,
                      child: AnimatedContainer(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          duration: Duration(milliseconds: 300),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      labelText: 'Enter Phone Number'),
                                ),
                                FlatButton(
                                  child: Text('Time'),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            content: TimePickerSpinner(
                                              is24HourMode: false,
                                            ),
                                          );
                                        });
                                  },
                                )
                              ],
                            ),
                          ))),
            ],
          );
  }

  void _setLocation() {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _locError = false;
      });
    }
    LocationHelpers().getLocation().then((loc) {
      if (loc['permission'] != false) {
        LocationHelpers().isNear(loc['position']).then((isNear) {
          if (mounted) {
            setState(() {
              _showError = !isNear;
              if (isNear == false) {
                _selectedIndex = 1;
              }
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
