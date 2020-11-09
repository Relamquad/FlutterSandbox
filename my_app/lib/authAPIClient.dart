import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    return response.body;
  } else {
    throw Exception('Failed to create album.');
  }
}