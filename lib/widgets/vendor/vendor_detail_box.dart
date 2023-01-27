import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bakul_app_admin/services/firebase_services.dart';

class VendorDetailBox extends StatefulWidget {
  String uid;
  VendorDetailBox({Key? key, required this.uid}) : super(key: key);

  @override
  _VendorDetailBoxState createState() => _VendorDetailBoxState();
}

class _VendorDetailBoxState extends State<VendorDetailBox> {
  FirebaseServices _services = FirebaseServices();
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference ratings =
      FirebaseFirestore.instance.collection('ratings');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  var totalOrders = 0;
  var activeOrders = 0;
  num total = 0;
  num totalProduct = 0;
  num rating = 0;

  @override
  void initState() {
    ratings.where('sellerId', isEqualTo: widget.uid).get().then((value) {
      num totalRating = 0;
      value.docs.forEach((element) {
        totalRating += element['rating'];
      });
      rating = totalRating / value.size;
    });
    products
        .where('seller.sellerUid', isEqualTo: widget.uid)
        .get()
        .then((value) {
      totalProduct = value.size;
    });
    orders.where('seller.sellerId', isEqualTo: widget.uid).get().then((value) {
      totalOrders = value.size;
      value.docs.forEach((element) {
        if (element['currentOrderStatus'] != 'Delivered') {
          activeOrders++;
        }
        total += element['total'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _services.vendors.doc(widget.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Dialog(
          backgroundColor: Color(0xFFF4B41A),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * .3,
                  child: ListView(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                snapshot.data!['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!['shopName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Divider(
                        thickness: 4,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: const Text(
                                      'Contact Number',
                                    ),
                                  ),
                                ),
                                Container(
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Text(':'),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  child: Text(snapshot.data!['mobile']),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: const Text(
                                      'Email',
                                    ),
                                  ),
                                ),
                                Container(
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Text(':'),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(snapshot.data!['email']),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: const Text(
                                      'Top Pick Status',
                                    ),
                                  ),
                                ),
                                Container(
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Text(':'),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: snapshot.data!['isTopPicked']
                                        ? Chip(
                                            backgroundColor: Color(0xFF143D59),
                                            label: Row(
                                              children: const [
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  'Top Picked',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                          Wrap(
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(0.9),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            CupertinoIcons.money_dollar_circle,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Total Revenue'),
                                          Text('RM${total.toString()}')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(0.9),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Active Orders'),
                                          Text(activeOrders.toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(0.9),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.shopping_bag,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Orders'),
                                          Text(totalOrders.toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(0.9),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.grain_outlined,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Products'),
                                          Text(
                                              '${totalProduct.toString()} Products')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: Card(
                                  color: Colors.orangeAccent.withOpacity(0.9),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star_rate,
                                            size: 50,
                                            color: Colors.black54,
                                          ),
                                          Text('Rating'),
                                          Text('${rating.toStringAsFixed(1)}')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: snapshot.data!['accVerified']
                      ? Chip(
                          backgroundColor: Color(0xFF143D59),
                          label: Row(
                            children: const [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                'Active',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )
                      : Chip(
                          backgroundColor: Color(0xFF143D59),
                          label: Row(
                            children: const [
                              Icon(
                                Icons.remove_circle,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                'Inactive',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
