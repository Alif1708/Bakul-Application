import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:bakul_app_admin/services/sidebar.dart';
import 'package:bakul_app_admin/widgets/banner/banner_upload_widget.dart';
import 'package:bakul_app_admin/widgets/banner/banner_widget.dart';

class BannerScreen extends StatefulWidget {
  static const String id = "banner-screen";
  BannerScreen({Key? key}) : super(key: key);

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  SideBarWidget _sideBar = SideBarWidget();

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
          'Banners',
          style: TextStyle(
            color: Color(0xFFF4B41A),
          ),
        ),
      ),
      sideBar: _sideBar.SideBarMenus(context, BannerScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Banner Manager',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF143D59),
                  fontSize: 36,
                ),
              ),
              const Text(
                'Add / Delete Home Screen Banner Images',
                style: TextStyle(
                  color: Color(0xFF143D59),
                ),
              ),
              const Divider(thickness: 5),
              BannerWidget(),
              const Divider(thickness: 5),
              const BannerUploadWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
