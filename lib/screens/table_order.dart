import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  var tableValue = '1';
  QuerySnapshot querySnapshot;

  @override
  void initState() {
    searchTableOrders('1').then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("Table Orders", style: TextStyle(color: Colors.black))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'View Orders of Table No. : ',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  DropdownButton<String>(
                    value: tableValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    underline: Container(
                      height: 1,
                      color: Colors.red,
                    ),
                    items: <String>[
                      '1',
                      '2',
                      '3',
                      '4',
                      '5',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (text) {
                      searchTableOrders(text).then((results) {
                        setState(() {
                          tableValue = text;
                          querySnapshot = results;
                        });
                      });
                    },
                  )
                ],
              ),
              Divider(
                height: 2,
              ),
              _showProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showProducts() {
    List order_list = [];
    //check if querysnapshot is null
    if (querySnapshot != null) {
      order_list = querySnapshot.documents;
      return Flexible(
        child: ListView.builder(
            itemCount: order_list.length,
            itemBuilder: (BuildContext context, int i) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListCard(
                  tableNum: order_list[i]['tableNum'],
                  name: order_list[i]['name'],
                  spice: order_list[i]['spice'],
                  quantity: order_list[i]['quantity'],
                  price: order_list[i]['price'],
                  customDesc: order_list[i]['customDesc'],
                ),
              );
            }),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  //get firestore instance

  searchTableOrders(searchtext) async {
    return await Firestore.instance
        .collection('orders')
        .where("tableNum", isEqualTo: int.parse(searchtext))
        .getDocuments();
  }
}

class ListCard extends StatelessWidget {
  final spice;
  final name;
  final price;
  final category;
  final tableNum;
  final customDesc;
  final quantity;

  ListCard(
      {this.name,
      this.spice,
      this.price,
      this.category,
      this.customDesc,
      this.tableNum,
      this.quantity});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Completed',
          color: Colors.blueGrey,
          icon: Icons.thumb_up_alt_outlined,
          onTap: () {},
        ),
        new IconSlideAction(
          caption: 'Reject',
          color: Colors.red,
          icon: Icons.thumb_down_alt_outlined,
          onTap: (){},
        ),
      ],
      child: Container(
        child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Column(children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Food Name: ",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6))),
                      Text(name, style: TextStyle(fontSize: 20)),
                      Spacer(),
                      Text("Qty  ",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6))),
                      Text(quantity.toString(), style: TextStyle(fontSize: 20)),
                      // Text("Price",
                      //     style: TextStyle(
                      //         color: Colors.black.withOpacity(0.6))),
                      // Text('\₹ ' + price.toString(),
                      //     style: TextStyle(fontSize: 16)),
                      Spacer(),
                      Container(
                        child: Icon(Icons.circle,
                            color: spice == true ? Colors.red : Colors.white),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text("Custom: ",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6))),
                      ),
                      customDesc != null
                          ? Flexible(
                              child: Container(
                                child: new Text(
                                  customDesc,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            )
                          : Text("")
                    ],
                  ),
                ]),
              ),
            )),
      ),
    );
  }
}
