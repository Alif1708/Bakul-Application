import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:bakul_app_admin/services/sidebar.dart';
import 'package:bakul_app_admin/widgets/category/category_list_widget.dart';
import 'package:bakul_app_admin/widgets/category/category_upload_widget.dart';

class CategoryScreen extends StatelessWidget {
  static const String id = "category-screen";
  CategoryScreen({Key? key}) : super(key: key);
  final SideBarWidget _sideBar = SideBarWidget();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Color(0xFFF4B41A),
      appBar: AppBar(
        backgroundColor: Color(0xFF143D59),
        iconTheme: const IconThemeData(
          color: Color(0xFFF4B41A),
        ),
        title: const Text('Categories',
            style: TextStyle(color: Color(0xFFF4B41A))),
      ),
      sideBar: _sideBar.SideBarMenus(context, id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Category',
                style: TextStyle(
                  color: Color(0xFF143D59),
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Add New Categories and Sub Categories',
                  style: TextStyle(color: Color(0xFF143D59))),
              Divider(thickness: 5),
              CategoryCreateWidget(),
              Divider(thickness: 5),
              CategoryListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
