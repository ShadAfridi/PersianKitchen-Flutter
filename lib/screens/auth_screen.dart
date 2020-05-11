import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/auth.dart';
import '../screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ConnectivityResult connect = Provider.of<ConnectivityResult>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 20,
            ),
          ),
          Text('Persian Kitchen',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 45,
                color: Colors.red,
              )),
          SizedBox(
            child: connect == ConnectivityResult.none
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
                : null,
            height: 250,
          ),
          Container(
            width: 300,
            height: 50,
            child: RaisedButton(
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Text(
                              'Logging In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ])
                    : Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              'Sign in with Google',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                onPressed: connect != ConnectivityResult.none
                    ? () {
                        if (mounted) {
                          setState(() {
                            _isLoading = true;
                          });
                        }
                        AuthService().signIn().then((user) {
                          if (user == null) {
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          } else {
                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.routeName);
                          }
                        }).catchError((err) {
                          if (mounted) {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                behavior: SnackBarBehavior.floating,
                                content: Text('An error occurred'),
                                action: SnackBarAction(
                                  label: 'Okay',
                                  onPressed: () {
                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            );
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        });
                      }
                    : null),
          ),
        ],
      ),
    );
  }
}
