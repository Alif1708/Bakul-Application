import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bakul_app_admin/widgets/category/sub_category_widget.dart';

class CategoryCardWidget extends StatelessWidget {
  final DocumentSnapshot? document;
  const CategoryCardWidget({this.document, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return SubCategoryWidget(categoryName: document!['categoryName']);
            });
      },
      child: SizedBox(
        height: 120,
        width: 120,
        child: Card(
          color: Color(0xFFF4B41A),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: Image.network(document!['image']),
                  ),
                  FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        document!['categoryName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
