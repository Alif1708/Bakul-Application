import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:bakul_app_admin/screens/admin_users_screen.dart';
import 'package:bakul_app_admin/screens/banner_manager_screen.dart';
import 'package:bakul_app_admin/screens/category_screen.dart';
import 'package:bakul_app_admin/screens/delivery_boy_screen.dart';
import 'package:bakul_app_admin/screens/loading_screen.dart';
import 'package:bakul_app_admin/screens/login_screen.dart';
import 'package:bakul_app_admin/screens/notification_screen.dart';
import 'package:bakul_app_admin/screens/order_screen.dart';
import 'package:bakul_app_admin/screens/settings_screen.dart';
import 'package:bakul_app_admin/screens/splash_screen.dart';
import 'package:bakul_app_admin/screens/vendor_screen.dart';
import 'package:bakul_app_admin/services/firebase_services.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: StartFirebase(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        LoadingScreen.id: (context) => LoadingScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        BannerScreen.id: (context) => BannerScreen(),
        CategoryScreen.id: (context) => CategoryScreen(),
        OrderScreen.id: (context) => OrderScreen(),
        AdminUsersScreen.id: (context) => AdminUsersScreen(),
        NotificationScreen.id: (context) => NotificationScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        VendorScreen.id: (context) => VendorScreen(),
        DeliveryBoyScreen.id: (context) => DeliveryBoyScreen(),
      },
    );
  }
}

class StartFirebase extends StatefulWidget {
  const StartFirebase({Key? key}) : super(key: key);

  @override
  _StartFirebaseState createState() => _StartFirebaseState();
}

class _StartFirebaseState extends State<StartFirebase> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(child: Text('Something is wrong'));
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return SplashScreen();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
