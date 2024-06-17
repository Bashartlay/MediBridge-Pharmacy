import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store/api.dart';
import 'package:store/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'انشاء حساب جديد',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFF9900),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400.0),
            padding: EdgeInsets.all(16.0),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'الاسم',
                        prefixIcon:
                            Icon(Icons.person, color: Color(0xFFFF9900)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey),
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
                    SizedBox(height: 20),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'رقم الجوال',
                        prefixIcon: Icon(Icons.phone, color: Color(0xFFFF9900)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey),
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
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: Icon(Icons.email, color: Color(0xFFFF9900)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey),
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
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFFF9900)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey),
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
                    SizedBox(height: 20),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        prefixIcon: Icon(Icons.lock, color: Color(0xFFFF9900)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey),
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
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('كلمتي المرور غير متطابقتين',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 20.0)),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (nameController.text.isEmpty ||
                            phoneController.text.isEmpty ||
                            emailController.text.isEmpty ||
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
                          _register(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFB800),
                        shadowColor: Colors.yellow,
                        minimumSize: Size(30, 40),
                      ),
                      child: Text("إنشاء حساب",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _register(context) async {
    var name = nameController.text;
    var email = emailController.text;
    var password = passwordController.text;
    var phone = phoneController.text;

    var data = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    };

    var res = await Network().auth(data, '/pharmacy/register/');
    if (res.statusCode == 200 || res.statusCode == 201) {
      // good connection
      var response = jsonDecode(res.body);
      if (response['error'] == true) {
        _showMessage(context, response['message']);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else {
      if (res.statusCode == 422) {
        _showMessage(context, jsonDecode(res.body)['message']);
      } else {
        print(res.statusCode);
        _showMessage(context, "Invalid Connection");
      }
    }
  }

  _showMessage(context, msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
