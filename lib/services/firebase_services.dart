import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');
  CollectionReference banners = FirebaseFirestore.instance.collection('slider');
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  CollectionReference boys = FirebaseFirestore.instance.collection('boys');
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<DocumentSnapshot> getAdminCredentials(id) {
    var result = FirebaseFirestore.instance.collection('admin').doc(id).get();
    return result;
  }

// Banner
  Future<void> uploadBannerImageToDb(url) async {
    banners.add({'image': url}).then((value) => value);
  }

  Future<void> deleteBannerFromDb(id) async {
    banners.doc(id).delete();
  }

// Vendor
  Future<void> updateVendorStatus({required id, required status}) async {
    vendors.doc(id).update({'accVerified': status ? false : true});
  }

  Future<void> updateVendorTopPicked({required id, required topPicked}) async {
    vendors.doc(id).update({'isTopPicked': topPicked ? false : true});
  }

//Category

  Future<void> uploadCategoryImageToDb(url, categoryName) async {
    category.doc(categoryName).set(
        {'image': url, 'categoryName': categoryName}).then((value) => value);
  }

  Future<void> confirmDeleteDialog(
      {required String message,
      required String tittle,
      required context,
      required String id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tittle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteBannerFromDb(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showMyDialog(
      {required String message, required String tittle, context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tittle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveDeliveryBoys(email, password) async {
    boys.doc(email).set({
      'accVerified' : false,
      'email': email,
      'imageUrl':'',
      'mobile':'',
      'name': '',
      'password': password,
      'uid':'',

    });
  }

  updateBoyStatus(String documentID, bool value) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('boys').doc(documentID);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (snapshot.exists) {
        throw Exception('User does not exist!');
      }

      transaction.update(documentReference, {'accVerified': !value});
    });
  }
}
