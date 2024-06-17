import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store/mstodaat.dart';
import 'package:store/register.dart';

import 'api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String token = "";
  static String email = "";
  static String name = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF101010),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'تسجيل الدخول',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFF9900),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              width: screenSize.width * 0.8,
              child: Card(
                elevation: 5,
                color: Color(0xFF151515),
                shadowColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.network(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZIvq-jyj-XEqUriuyVwU_gFH6Fp9jt7C08w&usqp=CAU",
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            }
                          },
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'البريد الإلكتروني أو رقم الهاتف',
                            prefixIcon:
                                Icon(Icons.email, color: Color(0xFFFF9900)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            alignLabelWithHint: true,
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true, // تمكين التلوين
                            fillColor: Colors.white, // تعيين لون التلوين
                            floatingLabelBehavior: FloatingLabelBehavior
                                .never, // منع رفع النص عند التركيز
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon:
                                Icon(Icons.lock, color: Color(0xFFFF9900)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            alignLabelWithHint: true,
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 14),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true, // تمكين التلوين
                            fillColor: Colors.white, // تعيين لون التلوين
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('يرجى ملء جميع الحقول',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(fontSize: 20.0)),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            _login(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB800),
                          shadowColor: Colors.yellow,
                        ),
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()),
                              );
                            },
                            icon: Icon(Icons.arrow_forward),
                            color: const Color(0xFFFF9900),
                            iconSize: 30.0,
                          ),
                          Text("ليس لدي حساب من قبل؟",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login(context) async {
    var email = emailController.text;
    var password = passwordController.text;

    var data = {'email': email, 'password': password};

    var res = await Network().auth(data, '/login/');
    if (res.statusCode == 200) {
      // good connection
      var response = jsonDecode(res.body);
      if (response['error'] == true) {
        _showMessage(context, response['message']);
      } else {
        MyApp.token = response['access_token'];
        MyApp.email = email;
        MyApp.name = response['user']['name'];
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PharmacyWarehousePage()));
      }
    } else {
      if (res.statusCode == 422) {
        _showMessage(context, jsonDecode(res.body)['message']);
      } else {
        _showMessage(context, "Invalid Connection");
      }
    }
  }

  _showMessage(context, msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
