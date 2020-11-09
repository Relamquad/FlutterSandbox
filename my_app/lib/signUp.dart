import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:http/http.dart' as http;

import 'gradientButton.dart';

class SignUpView extends StatefulWidget {
  @override
  SignUpViewState createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
  }

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  Future _futureSignUp;
  
  Future sendSignUp(String email, String password) async {
    final http.Response response = await http.post(
      'http://ec2-18-132-190-13.eu-west-2.compute.amazonaws.com/api/v1/users?client_id=1aYYfcQUx859EWZ1jUg7Yd8CslK7z2XmqMn8IUIf6lU&client_secret=IbHTB7a5VgshrXwZYhe9WOLkCZV05scoj2Dx1IUO3Tc',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password
      }),
    );

    if (response.statusCode == 201) {
      _isLoading = false;
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Success'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(response.body),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return response.body;
    } else {
      _isLoading = false;
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(response.body),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      throw Exception('Failed to create album.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: Form(
          key: _formKey,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/logo.png"),
                  Spacer(),

                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Input your email',
                      labelText: 'Email',
                    ),
                    onSaved: (String value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                      print('I am saved');
                    },
                    controller: emailController,
                    validator: (String value) {
                      print(value);
                      return !value.contains('@') ? 'Email not valid' : null;
                      // return value.length > 2 ? 'asd' : null;
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Input your email',
                        labelText: 'Password',
                      ),
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                        print('I am saved');
                      },
                      controller: passwordController,
                      obscureText: true,
                      validator: (String value) {
                        print(value);
                        return value.length < 6 ? 'Password is too short' : null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: RaisedGradientButton(
                        child: Text(
                          'Button',
                          style: TextStyle(color: Colors.white),
                        ),
                        gradient: LinearGradient(
                          colors: <Color>[Colors.red, Colors.orange],
                        ),
                        onPressed: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_formKey.currentState.validate()) {
                            _isLoading = true;
                            _futureSignUp = sendSignUp(emailController.text, passwordController.text);
                          }
                        }
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
        Container(
          child: !_isLoading ? null : Stack(alignment: AlignmentDirectional.center,
            children:[ BackdropFilter(filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0),
                )),
              AwesomeLoader()]
          ),
        ),

          ]),
        ),
      ),
    );
  }
}