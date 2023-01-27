import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:bakul_app_admin/services/firebase_services.dart';

class NewBoys extends StatefulWidget {
  const NewBoys({Key? key}) : super(key: key);

  @override
  _NewBoysState createState() => _NewBoysState();
}

class _NewBoysState extends State<NewBoys> {
  FirebaseServices _firebaseServices = FirebaseServices();
  bool _switchValue = false;

  List<DataRow> _boysList(QuerySnapshot? snapshot, context) {
    List<DataRow> newList = snapshot!.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(Container(
          height: 60,
          width: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: document['imageUrl'] == ''
                ? Icon(
                    Icons.person,
                    size: 30,
                    color: Color(0xFF143D59),
                  )
                : Image.network(
                    document['imageUrl'],
                    fit: BoxFit.contain,
                  ),
          ),
        )),
        DataCell(
            Text(document['name'], style: TextStyle(color: Color(0xFF143D59)))),
        DataCell(Text(document['email'],
            style: TextStyle(color: Color(0xFF143D59)))),
        DataCell(Text(document['mobile'],
            style: TextStyle(color: Color(0xFF143D59)))),
        DataCell(
          document['mobile'] == ''
              ? Text('No Registered',
                  style: TextStyle(color: Color(0xFF143D59)))
              : FlutterSwitch(
                  onToggle: (val) {
                    _firebaseServices.boys
                        .doc(document['email'])
                        .update({'accVerified': val});
                    setState(() {});
                  },
                  activeText: 'Approved',
                  inactiveText: 'Not Approved',
                  value: document['accVerified'],
                  valueFontSize: 10.0,
                  width: 110,
                  borderRadius: 30.0,
                  showOnOff: true,
                ),
        ),
      ]);
    }).toList();
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _firebaseServices.boys
            .where('accVerified', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Something went wrong...',
              style: TextStyle(color: Color(0xFF143D59)),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if ((snapshot.data as QuerySnapshot).size == 0) {
            return Center(
              child: Text(
                'No Delivery Boy to display',
                style: TextStyle(
                  color: Color(0xFF143D59),
                ),
              ),
            );
          }
          return SingleChildScrollView(
            child: FittedBox(
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(Color(0xFF143D59)),
                columns: <DataColumn>[
                  DataColumn(
                      label: Expanded(
                          child: Text('Profile Pic',
                              style: TextStyle(
                                color: Color(0xFFF4B41A),
                              )))),
                  DataColumn(
                      label: Text('Name',
                          style: TextStyle(
                            color: Color(0xFFF4B41A),
                          ))),
                  DataColumn(
                      label: Text('Email',
                          style: TextStyle(
                            color: Color(0xFFF4B41A),
                          ))),
                  DataColumn(
                      label: Text('Mobile',
                          style: TextStyle(
                            color: Color(0xFFF4B41A),
                          ))),
                  DataColumn(
                      label: Text('Actions',
                          style: TextStyle(
                            color: Color(0xFFF4B41A),
                          ))),
                ],
                rows: _boysList(snapshot.data as QuerySnapshot, context),
              ),
            ),
          );
        },
      ),
    );
  }
}
