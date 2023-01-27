import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:bakul_app_admin/screens/samples/bar_chart_sample1.dart';

import 'package:bakul_app_admin/services/sidebar.dart';

enum ScreenSize { Small, Normal, Large, ExtraLarge }

ScreenSize getSize(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.longestSide;
  if (deviceWidth > 900) return ScreenSize.ExtraLarge;
  if (deviceWidth > 600) return ScreenSize.Large;
  if (deviceWidth > 300) return ScreenSize.Normal;
  return ScreenSize.Small;
}

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SideBarWidget _sideBar = SideBarWidget();
  int totalUser = 0;
  int totalVendor = 0;
  int totalDeliveryBoy = 0;

  @override
  void initState() {
    FirebaseFirestore.instance.collection('users').get().then((value) {
      totalUser = value.size;
    });
    FirebaseFirestore.instance.collection('vendors').get().then((value) {
      totalVendor = value.size;
    });
    FirebaseFirestore.instance
        .collection('boys')
        .where('accVerified', isEqualTo: true)
        .get()
        .then((value) {
      totalDeliveryBoy = value.size;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Color(0xFFF4B41A),
      appBar: AppBar(
        backgroundColor: Color(0xFF143D59),
        iconTheme: const IconThemeData(
          color: Color(0xFFF4B41A),
        ),
        title: const Text(
          'Administrator Dashboard',
          style: TextStyle(
            color: Color(0xFFF4B41A),
          ),
        ),
      ),
      sideBar: _sideBar.SideBarMenus(context, HomeScreen.id),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(color: Color(0xFF143D59), fontSize: 40),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Total User',
                    style: TextStyle(color: Color(0xFF143D59), fontSize: 20),
                  ),
                  SizedBox(
                    width: 600,
                  ),
                  Text(
                    'Last 11 Orders',
                    style: TextStyle(color: Color(0xFF143D59), fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color: Color(0xFF2A2D3E),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  color: Colors.blue,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        Icon(Icons.people_alt),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text('User',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                '$totalUser registered users',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color: Color(0xFF2A2D3E),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  color: Colors.blue,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(Icons.store),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text('Shop',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                '$totalVendor registered Vendors',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        color: Color(0xFF2A2D3E),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  color: Colors.blue,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                        Icons.delivery_dining),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text('Delivery Boy',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                '$totalDeliveryBoy registered Delivery Boy',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: BarChartSample1(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        getSize(context) == ScreenSize.ExtraLarge
                            ? Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: Color(0xFF2A2D3E),
                                    height: 720,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('orders')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('Something Went Wront');
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return DataTable(
                                          showBottomBorder: true,
                                          dataRowHeight: 60,
                                          headingRowColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFF2A2D3E)),
                                          columns: <DataColumn>[
                                            DataColumn(
                                              label: Text(
                                                'Order Id',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Receiver',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Location',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Delivery Boy',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Total',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Order Status',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                          rows:
                                              _vendorDetailsRows(snapshot.data),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<DataRow> _vendorDetailsRows(QuerySnapshot? snapshot) {
  List<DataRow> newList = snapshot!.docs.map((DocumentSnapshot document) {
    return DataRow(cells: [
      DataCell(
        Text(
          document.id,
          style: TextStyle(color: Colors.white),
        ),
      ),
      DataCell(
        Text(
          document['receiverName'],
          style: TextStyle(color: Colors.white),
        ),
      ),
      DataCell(
        Text(
          document['location'],
          style: TextStyle(color: Colors.white),
        ),
      ),
      DataCell(Text(
        document['deliveryBoy']['name'],
        style: TextStyle(color: Colors.white),
      )),
      DataCell(Text(
        'RM${document['total']}',
        style: TextStyle(color: Colors.white),
      )),
      DataCell(
        Text(
          document['currentOrderStatus'],
          style: TextStyle(color: Colors.white),
        ),
      ),
    ]);
  }).toList();
  return newList;
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = Colors.white,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
