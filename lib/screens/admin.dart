import 'package:eaterisadmin/screens/manage_table.dart';
import 'package:eaterisadmin/screens/table_order.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/category.dart';

import 'add_product.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Eateries Admin Panel',
            style: TextStyle(color: Colors.deepOrangeAccent),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    return ListView(
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.table_chart_outlined, color: Colors.blue),
            title: Text("Manage Tables"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ManageTable()));
            }),
        Divider(),
        ListTile(
          leading: Icon(Icons.add, color: Colors.pinkAccent),
          title: Text("Add product"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddProduct()));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.add_circle, color: Colors.blueGrey),
          title: Text("Add category"),
          onTap: () {
            _categoryAlert();
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.reorder_sharp, color: Colors.green),
          title: Text("View Orders"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => new Orders()));
          },
        ),
        Divider(),
      ],
    );
  }

  void _categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value) {
            if (value.isEmpty) {
              return 'category cannot be empty';
            }
          },
          decoration: InputDecoration(hintText: "add category"),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (categoryController.text != null) {
                _categoryService.createCategory(categoryController.text);
              }
              Fluttertoast.showToast(msg: 'category created');
              Navigator.pop(context);
            },
            child: Text('ADD')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}
