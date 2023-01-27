import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bakul_app_admin/services/firebase_services.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  bool userNameExist = true;
  bool passwordExist = true;

  @override
  Widget build(BuildContext context) {
    _login() async {
      _services
          .getAdminCredentials(_userNameController.text)
          .then((value) async {
        if (value.exists) {
          if (value['userName'] == _userNameController.text) {
            if (value['password'] == _passwordController.text) {
              try {
                UserCredential? userCredential =
                    await FirebaseAuth.instance.signInAnonymously();
                if (userCredential != null) {
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }
              } catch (e) {
                _showMyDialog(message: '${e.toString()}', tittle: 'Login');
              }
              return;
            }
            _showMyDialog(
                message: 'Invalid Password',
                tittle: 'Password you have entered is incorrect');
            return;
          }

          _showMyDialog(
              message: 'Invalid Username',
              tittle: 'UserName you have entered is incorrect');
        }
        _showMyDialog(
            message: 'Invalid Username',
            tittle: 'UserName you have entered is incorrect');
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFFF4B41A),
      appBar: AppBar(
        backgroundColor: Color(0xFF143D59),
        title: const Text(
          'Bakul App Administration',
          style: TextStyle(color: Color(0xFFF4B41A)),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Connection Failed'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: const BoxDecoration(),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/logo.png',
                        width: 300,
                        height: 300,
                      ),
                      Container(
                        width: 300,
                        height: 300,
                        child: Card(
                          elevation: 4.4,
                          shape: Border.all(color: Color(0xFF143D59), width: 2),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _userNameController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter User Name';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                  Icons.account_circle),
                                              labelText: 'User Name',
                                              hintText: 'User Name',
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 20, right: 20),
                                              border:
                                                  const OutlineInputBorder(),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 2))),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: _passwordController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter Password';
                                            }
                                            return null;
                                          },
                                          obscureText: true,
                                          decoration: InputDecoration(
                                              labelText: 'Password',
                                              prefixIcon: Icon(Icons.password),
                                              hintText: 'Password',
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 20, right: 20),
                                              border:
                                                  const OutlineInputBorder(),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 2))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFF143D59)),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _login();
                                                }
                                              },
                                              child: const Text(
                                                'Log In',
                                                style: TextStyle(
                                                    color: Color(0xFFF4B41A)),
                                              ))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            );
          } else {
            return const Text('id');
          }
        },
      ),
    );
  }

  void showResultDialog(BuildContext context, String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(result),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> _showMyDialog(
      {required String message, required String tittle}) async {
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
}
