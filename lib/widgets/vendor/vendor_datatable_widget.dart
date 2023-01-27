import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bakul_app_admin/services/firebase_services.dart';
import 'package:bakul_app_admin/widgets/vendor/vendor_detail_box.dart';

class VendorDataTable extends StatefulWidget {
  const VendorDataTable({Key? key}) : super(key: key);

  @override
  State<VendorDataTable> createState() => _VendorDataTableState();
}

class _VendorDataTableState extends State<VendorDataTable> {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  int tag = 1;
  List<String> options = [
    'All Vendors',
    'Active Vendors',
    'Inactive Vendors',
    'Top Picked',
    'Top Rated',
  ];
  bool? topPicked = true;
  bool? active = true;

  filter(val) {
    if (val == 0) {
      setState(() {
        topPicked = null;
        active = null;
      });
    }
    if (val == 1) {
      setState(() {
        active = true;
        topPicked = null;
      });
    }
    if (val == 2) {
      setState(() {
        active = false;
        topPicked = null;
      });
    }
    if (val == 3) {
      setState(() {
        topPicked = true;
        active = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipsChoice<int>.single(
          value: tag,
          onChanged: (val) {
            setState(() {
              tag = val;
              filter(val);
            });
          },
          choiceItems: C2Choice.listFrom<int, String>(
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
          choiceStyle: const C2ChoiceStyle(
            brightness: Brightness.dark,
            color: Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        const Divider(
          thickness: 5,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _services.vendors
              .where('isTopPicked', isEqualTo: topPicked)
              .where('accVerified', isEqualTo: active)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something Went Wront');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(Color(0xFF143D59)),
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('Active / Inactive',
                        style: TextStyle(color: Color(0xFFF4B41A))),
                  ),
                  DataColumn(
                    label: Text('Top Picked Store',
                        style: TextStyle(color: Color(0xFFF4B41A))),
                  ),
                  DataColumn(
                    label: Text('Shop Name',
                        style: TextStyle(color: Color(0xFFF4B41A))),
                  ),
                  DataColumn(
                    label: Text('Mobile',
                        style: TextStyle(color: Color(0xFFF4B41A))),
                  ),
                  DataColumn(
                    label: Text('Email',
                        style: TextStyle(color: Color(0xFFF4B41A))),
                  ),
                  DataColumn(
                    label: Text('View Details',
                        style: TextStyle(color: Color(0xFFF4B41A))),
                  ),
                ],
                rows: _vendorDetailsRows(snapshot.data, _services),
              ),
            );
          },
        ),
      ],
    );
  }

  List<DataRow> _vendorDetailsRows(
      QuerySnapshot? snapshot, FirebaseServices services) {
    List<DataRow> newList = snapshot!.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(
          IconButton(
            onPressed: () {
              services.updateVendorStatus(
                  id: document['uid'], status: document['accVerified']);
            },
            icon: document['accVerified']
                ? const Icon(
                    Icons.check_circle,
                    color: Color(0xFF143D59),
                  )
                : const Icon(
                    Icons.remove_circle,
                    color: Color(0xFF143D59),
                  ),
          ),
        ),
        DataCell(
          IconButton(
            onPressed: () {
              services.updateVendorTopPicked(
                  id: document['uid'], topPicked: document['isTopPicked']);
            },
            icon: document['isTopPicked']
                ? const Icon(
                    Icons.check_circle,
                    color: Color(0xFF143D59),
                  )
                : const Icon(
                    Icons.remove_circle,
                    color: Color(0xFF143D59),
                  ),
          ),
        ),
        DataCell(
          Text(
            document['shopName'],
            style: TextStyle(
              color: Color(0xFF143D59),
            ),
          ),
        ),
        DataCell(Text(document['mobile'],
            style: TextStyle(
              color: Color(0xFF143D59),
            ))),
        DataCell(Text(document['email'],
            style: TextStyle(
              color: Color(0xFF143D59),
            ))),
        DataCell(
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Color(0xFF143D59),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return VendorDetailBox(uid: document['uid']);
                },
              );
            },
          ),
        ),
      ]);
    }).toList();
    return newList;
  }
}
