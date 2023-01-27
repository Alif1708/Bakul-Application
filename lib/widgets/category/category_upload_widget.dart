import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bakul_app_admin/services/firebase_services.dart';
import 'package:firebase/firebase.dart' as fb;

class CategoryCreateWidget extends StatefulWidget {
  const CategoryCreateWidget({Key? key}) : super(key: key);

  @override
  _CategoryCreateWidgetState createState() => _CategoryCreateWidgetState();
}

class _CategoryCreateWidgetState extends State<CategoryCreateWidget> {
  bool _visible = false;
  final _fileNameTextController = TextEditingController();
  final _categoryNameTextController = TextEditingController();
  bool _imageSelected = true;
  String? _url;
  String text1 = 'Add New Category';
  final FirebaseServices _services = FirebaseServices();

  void uploadImage({required Function(File file) onSelected}) {
    InputElement uploadInput =
        (FileUploadInputElement()..accept = 'image/*') as InputElement;
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  Future<void> uploadImageFile() async {
    final dateTime = DateTime.now();
    final path = 'categoryImage/$dateTime';
    uploadImage(onSelected: (file) async {
      if (file != null) {
        EasyLoading.show(status: 'Uploading Image');
        _fileNameTextController.text = file.name;
        fb.StorageReference storageRef = fb
            .storage()
            .refFromURL('gs://bakul-app-3551f.appspot.com/')
            .child(path);
        final uploadTask = storageRef.put(file);
        try {
          final snapshot = await uploadTask.future;
          final filePath = await snapshot.ref.getDownloadURL();
          setState(() {
            _url = filePath.toString();
            _imageSelected = false;
            EasyLoading.showSuccess('Upload Complete');
          });
        } catch (e) {
          print(e);
          EasyLoading.showError(e.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF143D59),
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: [
            Visibility(
              visible: _visible,
              child: Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 30,
                      child: TextField(
                        controller: _categoryNameTextController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "No Category Name Given",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 20),
                        ),
                      ),
                    ),
                    AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(
                        width: 200,
                        height: 30,
                        child: TextField(
                          controller: _fileNameTextController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "No Image Selected",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 20),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        uploadImageFile().then((value) {
                          setState(() {
                            _imageSelected = false;
                            _fileNameTextController.clear();
                          });
                        });
                      },
                      child: Text(
                        'Upload Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AbsorbPointer(
                      absorbing: _imageSelected,
                      child: TextButton(
                        onPressed: () {
                          if (_categoryNameTextController.text.isEmpty) {
                            return _services.showMyDialog(
                                message: 'New Category Name not given',
                                tittle: 'Add New Category',
                                context: context);
                          }
                          _services
                              .uploadCategoryImageToDb(
                                  _url!, _categoryNameTextController.text)
                              .then((downloadUrl) {
                            _services.showMyDialog(
                                message: 'New Category',
                                tittle: 'Saved New Category Successfuly',
                                context: context);
                          });
                          _categoryNameTextController.clear();
                          _fileNameTextController.clear();
                        },
                        child: Text(
                          'Save New Category',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                  text1 = _visible ? 'Cancel' : 'Add New Category';
                });
              },
              child: Text(
                text1,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
