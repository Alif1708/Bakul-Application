import 'dart:html';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:bakul_app_admin/services/firebase_services.dart';

class BannerUploadWidget extends StatefulWidget {
  const BannerUploadWidget({Key? key}) : super(key: key);

  @override
  _BannerUploadWidgetState createState() => _BannerUploadWidgetState();
}

class _BannerUploadWidgetState extends State<BannerUploadWidget> {
  final _fileNameTextController = TextEditingController();
  bool _visible = false;
  bool _imageSelected = true;
  String? _url;
  String text1 = 'Add New Banner';
  PickedFile? pickedFile;
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
    final path = 'bannerImage/$dateTime';
    uploadImage(onSelected: (file) async {
      if (file != null) {
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
          });
        } catch (e) {
          print(e);
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
              child: Row(
                children: [
                  AbsorbPointer(
                    absorbing: true,
                    child: SizedBox(
                      width: 300,
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
                        _imageSelected = false;
                        _fileNameTextController.clear();
                      });
                    },
                    child: Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AbsorbPointer(
                    absorbing: _imageSelected,
                    child: TextButton(
                      onPressed: () {
                        _services
                            .uploadBannerImageToDb(_url!)
                            .then((downloadUrl) {
                          _services.showMyDialog(
                              message: 'New Banner Image',
                              tittle: 'Saved Banner Image Successfuly',
                              context: context);
                        });
                      },
                      child: Text(
                        'Save Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                  text1 = _visible ? 'Cancel' : 'Add New Banner';
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
