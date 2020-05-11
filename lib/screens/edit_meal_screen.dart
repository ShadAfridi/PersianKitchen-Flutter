import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import '../providers/meal.dart';
import '../providers/meals.dart';

class EditMealScreen extends StatefulWidget {
  static const routeName = '/add-meal';

  @override
  _EditMealScreenState createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  File _image;
  var _editedMeal = Meal(
      category: '',
      description: '',
      id: null,
      price: 0.0,
      title: '',
      imgUrl: '');
  var _dropValue;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imgUrl': '',
  };
  bool isLoading = false;

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityResult connect = Provider.of<ConnectivityResult>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red[600]),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        title: Text(
          'Add to menu',
          style: TextStyle(
            color: Colors.red[600],
            fontSize: 26,
          ),
        ),
        actions: connect == ConnectivityResult.none
            ? null
            : <Widget>[
                IconButton(
                  icon: Icon(Icons.save),
                  tooltip: 'Save',
                  onPressed: saveForm,
                )
              ],
      ),
      body: connect == ConnectivityResult.none
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
          : Padding(
              padding: EdgeInsets.all(16),
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Uploading to server',
                            style:
                                TextStyle(color: Colors.red[600], fontSize: 18),
                          )
                        ],
                      ),
                    )
                  : Form(
                      autovalidate: true,
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          TextFormField(
                            initialValue: _initValues['title'],
                            decoration: InputDecoration(labelText: 'Title'),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a title';
                              }
                              if (value.contains(RegExp(r'[0-9]'))) {
                                return 'Enter a valid title';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedMeal = Meal(
                                  category: _editedMeal.category,
                                  description: _editedMeal.description,
                                  id: _editedMeal.id,
                                  price: _editedMeal.price,
                                  title: value,
                                  imgUrl: _editedMeal.imgUrl);
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['description'],
                            decoration:
                                InputDecoration(labelText: 'Description'),
                            focusNode: _descriptionFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_priceFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a description';
                              }
                              if (value.length <= 10) {
                                return 'Description too short';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedMeal = Meal(
                                  category: _editedMeal.category,
                                  description: value,
                                  id: _editedMeal.id,
                                  price: _editedMeal.price,
                                  title: _editedMeal.title,
                                  imgUrl: _editedMeal.imgUrl);
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['Price'],
                            decoration: InputDecoration(labelText: 'Price'),
                            focusNode: _priceFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a price';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Price should contain only numbers';
                              }
                              if (double.parse(value) <= 0) {
                                return 'Price should be greater than 0';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedMeal = Meal(
                                  category: _editedMeal.category,
                                  description: _editedMeal.description,
                                  id: _editedMeal.id,
                                  price: double.parse(value),
                                  title: _editedMeal.title,
                                  imgUrl: _editedMeal.imgUrl);
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: DropdownButton(
                              underline: Container(
                                height: 1.5,
                                color: Colors.black26,
                              ),
                              isExpanded: true,
                              style: TextStyle(
                                  color: Colors.red[600], fontSize: 17),
                              hint: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text('Select Category'),
                              ),
                              items: [
                                DropdownMenuItem(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text('Combo'),
                                  ),
                                  value: '1',
                                ),
                                DropdownMenuItem(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text('Naan'),
                                  ),
                                  value: '2',
                                ),
                                DropdownMenuItem(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text('Curry'),
                                  ),
                                  value: '3',
                                ),
                              ],
                              onChanged: (value) {
                                _setCategory(value);
                              },
                              value: _dropValue,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.red[600],
                                )),
                                height: 113,
                                width: 200,
                                child: _image == null
                                    ? Text(
                                        'No image selected',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    : Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      ),
                                alignment: Alignment.center,
                              ),
                              FlatButton.icon(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                label: Text(
                                  'Add Image',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.red[600],
                                ),
                                onPressed: getImage,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
            ),
    );
  }

  void _setCategory(value) {
    setState(() {
      _dropValue = value;
    });

    String categoryValue;
    switch (_dropValue) {
      case '1':
        {
          categoryValue = 'Combo';
        }
        break;
      case '2':
        {
          categoryValue = 'Naan';
        }
        break;
      case '3':
        {
          categoryValue = 'Curry';
        }
        break;
      default:
        {
          categoryValue = null;
        }
        break;
    }

    _editedMeal = Meal(
        category: categoryValue,
        description: _editedMeal.description,
        id: _editedMeal.id,
        price: _editedMeal.price,
        title: _editedMeal.title,
        imgUrl: _editedMeal.imgUrl);
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> saveForm() async {
    final isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }
    if (_dropValue == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'An error occurred!',
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
          content: Text(
            'Select a category',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Okay',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).errorColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
      return;
    }
    if (_image == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'An error occurred!',
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
          content: Text(
            'Upload an Image',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Okay',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).errorColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
      return;
    }

    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    await Provider.of<Meals>(context,listen: false).createMeal(_editedMeal, _image);

    Navigator.of(context).pop();
  }
}
