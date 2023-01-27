import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bakul_app_admin/services/firebase_services.dart';

class SubCategoryWidget extends StatefulWidget {
  final String? categoryName;
  const SubCategoryWidget({this.categoryName, Key? key}) : super(key: key);

  @override
  _SubCategoryWidgetState createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  FirebaseServices _services = FirebaseServices();
  var _subCategoryNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Color(0xFF143D59),
        height: MediaQuery.of(context).size.height,
        width: 300,
        padding: EdgeInsets.all(10.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: _services.category.doc(widget.categoryName).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('No Subcategories Added'),
                );
              }
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Main Category: ',
                              style: (TextStyle(color: Color(0xFFF4B41A))),
                            ),
                            Text(widget.categoryName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF4B41A)))
                          ],
                        ),
                        Divider(
                          thickness: 3,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(
                              data['subCat'][index]['name'],
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                        itemCount:
                            data['subCat'] == null ? 0 : data['subCat'].length,
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Divider(
                          thickness: 4,
                        ),
                        Container(
                          color: Color(0xFFF4B41A),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Add New SubCategory',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: TextField(
                                        controller: _subCategoryNameController,
                                        decoration: const InputDecoration(
                                            hintText: 'Sub Category Name',
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.only(left: 10)),
                                      ),
                                      height: 30,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (_subCategoryNameController
                                          .text.isEmpty) {
                                        return _services.showMyDialog(
                                            message:
                                                'Need to Give Subcategory Name',
                                            tittle: 'Add New SubCategory');
                                      }
                                      DocumentReference doc = _services.category
                                          .doc(widget.categoryName);
                                      doc.update({
                                        'subCat': FieldValue.arrayUnion([
                                          {
                                            'name':
                                                _subCategoryNameController.text
                                          }
                                        ])
                                      });
                                      setState(() {});
                                      _subCategoryNameController.clear();
                                    },
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
