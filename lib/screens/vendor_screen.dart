import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:bakul_app_admin/services/sidebar.dart';
import 'package:bakul_app_admin/widgets/vendor/vendor_datatable_widget.dart';

class VendorScreen extends StatefulWidget {
  static const String id = "vendor-screen";
  const VendorScreen({Key? key}) : super(key: key);

  @override
  _VendorScreenState createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
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
          'Vendor',
          style: TextStyle(
            color: Color(0xFFF4B41A),
          ),
        ),
      ),
      sideBar: _sideBar.SideBarMenus(context, VendorScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Manage Vendor',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF143D59),
                  fontSize: 36,
                ),
              ),
              Text(
                'Manage All Vendors Activities',
                style: TextStyle(
                  color: Color(0xFF143D59),
                ),
              ),
              Divider(thickness: 5),
              VendorDataTable(),
              Divider(thickness: 5),
            ],
          ),
        ),
      ),
    );
  }
}
