import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bakul_app_admin/services/firebase_services.dart';

class BannerWidget extends StatelessWidget {
  FirebaseServices _services = FirebaseServices();
  BannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return StreamBuilder<QuerySnapshot>(
      stream: _services.banners.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          height: 300,
          child: ListView(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Card(
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: FadeInImage.assetNetwork(
                            placeholder: document['image'],
                            image: document['image'],
                            width: 500,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {
                              _services.confirmDeleteDialog(
                                message: 'Are you sure you want to delete? ',
                                tittle: 'Delete Banner',
                                id: document.id,
                                context: context,
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ))
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
