import 'package:eaterisadmin/db/tableApi.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageTable extends StatefulWidget {
  @override
  _ManageTableState createState() => _ManageTableState();
}

class _ManageTableState extends State<ManageTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.1,
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
          title: Text("Manage Tables", style: TextStyle(color: Colors.black))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          // future: TableApi().getTables(),
          stream: Firestore.instance.collection('tables').snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var value = snapshot.data.documents;
              print(snapshot.data.documents[1]['vacant']);
              return GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0),
                children: [
                  TableCard(tableName: 'Table 1', vacant: value[0]['vacant']),
                  TableCard(tableName: 'Table 2', vacant: value[1]['vacant']),
                  TableCard(tableName: 'Table 3', vacant: value[2]['vacant']),
                  TableCard(tableName: 'Table 4', vacant: value[3]['vacant']),
                  TableCard(tableName: 'Table 5', vacant: value[4]['vacant']),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class TableCard extends StatelessWidget {
  final String tableName;
  final bool vacant;

  TableCard({this.tableName, this.vacant});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Card(
          elevation: 8.0,
          child: Container(
              color: vacant
                  ? Colors.green.withOpacity(0.8)
                  : Colors.red.withOpacity(0.8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/chair.png', height: 60),
                  SizedBox(height: 16.0),
                  Text(
                    tableName,
                    style: TextStyle(
                        fontSize: 34,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  )
                ],
              )),
        ),
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 130,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          TableApi().updateTable(tableName, true);
                        },
                        leading: Icon(Icons.table_chart_outlined),
                        title: Text('Mark as Vacant', textScaleFactor: 1.1),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          TableApi().updateTable(tableName, false);
                        },
                        leading: Icon(Icons.table_chart),
                        title: Text('Mark as Reserved', textScaleFactor: 1.1),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
