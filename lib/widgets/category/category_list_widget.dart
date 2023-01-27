import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bakul_app_admin/services/firebase_services.dart';
import 'package:bakul_app_admin/widgets/category/category_card_widget.dart';

class CategoryListWidget extends StatefulWidget {
  const CategoryListWidget({Key? key}) : super(key: key);

  @override
  _CategoryListWidgetState createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF143D59),
      child: StreamBuilder(
        stream: _services.category.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong..."),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return Wrap(
              direction: Axis.horizontal,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return CategoryCardWidget(
                  document: document,
                );
              }).toList(),
            );
          }

          return (const Text('What?'));
        },
      ),
    );
  }
}
