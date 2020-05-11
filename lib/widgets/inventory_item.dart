import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meals.dart';

class InventoryItem extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String id;

  InventoryItem(this.id, this.title, this.imgUrl);
  @override
  Widget build(BuildContext context) {
    bool _hasError = false;
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Delete',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).errorColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              titlePadding: EdgeInsets.only(top: 20),
              contentPadding: EdgeInsets.only(top: 30, bottom: 20),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).errorColor),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      scaffold.removeCurrentSnackBar();
                      scaffold.showSnackBar(SnackBar(
                        elevation: 4,
                        backgroundColor: Colors.red[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.delete_sweep),
                            SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'Deleting...',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ));
                      try {
                        await Provider.of<Meals>(context,listen: false).delete(id);
                      } catch (err) {
                        scaffold.removeCurrentSnackBar();
                        scaffold.showSnackBar(SnackBar(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          behavior: SnackBarBehavior.floating,
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.error_outline),
                              SizedBox(
                                width: 5,
                              ),
                              const Text(
                                'An Error Occurred',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ));
                        _hasError = true;
                      }
                      if (_hasError == false) {
                        scaffold.removeCurrentSnackBar();
                        scaffold.showSnackBar(SnackBar(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          behavior: SnackBarBehavior.floating,
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.delete_forever),
                              SizedBox(
                                width: 5,
                              ),
                              const Text(
                                'Deleted',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ));
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
        color: Theme.of(context).errorColor,
      ),
    );
  }
}
