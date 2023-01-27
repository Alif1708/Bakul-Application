import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:bakul_app_admin/screens/admin_users_screen.dart';
import 'package:bakul_app_admin/screens/banner_manager_screen.dart';
import 'package:bakul_app_admin/screens/category_screen.dart';
import 'package:bakul_app_admin/screens/delivery_boy_screen.dart';
import 'package:bakul_app_admin/screens/home_screen.dart';
import 'package:bakul_app_admin/screens/login_screen.dart';
import 'package:bakul_app_admin/screens/notification_screen.dart';
import 'package:bakul_app_admin/screens/order_screen.dart';
import 'package:bakul_app_admin/screens/settings_screen.dart';
import 'package:bakul_app_admin/screens/splash_screen.dart';
import 'package:bakul_app_admin/screens/vendor_screen.dart';

class SideBarWidget {
  SideBarMenus(context, selectedRoute) {
    return SideBar(
      textStyle: TextStyle(color: Colors.white),
      backgroundColor: Color(0xFF143D59),
      activeBackgroundColor: Color(0xFF212332),
      activeIconColor: Color(0xFFF4B41A),
      activeTextStyle: TextStyle(color: Color(0xFFF4B41A)),
      items: const [
        AdminMenuItem(
          title: 'Dashboard',
          route: HomeScreen.id,
          icon: Icons.dashboard,
        ),
        AdminMenuItem(
          title: 'Banners',
          route: BannerScreen.id,
          icon: CupertinoIcons.photo,
        ),
        AdminMenuItem(
          title: 'Vendor',
          route: VendorScreen.id,
          icon: CupertinoIcons.group_solid,
        ),
        AdminMenuItem(
          title: 'Deliverer',
          route: DeliveryBoyScreen.id,
          icon: Icons.delivery_dining,
        ),
        AdminMenuItem(
          title: 'Categories',
          route: CategoryScreen.id,
          icon: Icons.category,
        ),
        AdminMenuItem(
          title: 'Exit',
          route: LoginScreen.id,
          icon: Icons.exit_to_app,
        ),
      ],
      selectedRoute: selectedRoute,
      onSelected: (item) {
        if (item.route == LoginScreen.id) {
          User? user = FirebaseAuth.instance.currentUser;
          user!.delete();
          Navigator.of(context).pushNamed(item.route!);
        } else if (item.route != null) {
          Navigator.of(context).pushNamed(item.route!);
        }
      },
      header: Container(),
      footer: Container(),
    );
  }
}
