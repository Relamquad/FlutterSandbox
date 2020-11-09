import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_app/signUp.dart';
import 'package:epub_viewer/epub_viewer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/logo.png"),
            Spacer(),
            FlatButton(
              onPressed: () {
                _settingModalBottomSheet(context);
              },
              child: Text(
                "SignUp",
              ),
            ),
            Spacer(),
            FlatButton(
              onPressed: () async {
                EpubViewer.setConfig(
                  themeColor: Theme.of(context).primaryColor,
                  identifier: "iosBook",
                  scrollDirection: EpubScrollDirection.VERTICAL,
                  allowSharing: true,
                  enableTts: true,
                );

                await EpubViewer.openAsset(
                  'assets/epub1.epub',
                  lastLocation: EpubLocator.fromJson({
                    "bookId": "2239",
                    "href": "/OEBPS/ch06.xhtml",
                    "created": 1539934158390,
                    "locations": {
                      "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                    }
                  }), // first page will open up if the value is null
                );

                // Get locator which you can save in your database
                EpubViewer.locatorStream.listen((locator) {
                  print('LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
                  // convert locator from string to json and save to your database to be retrieved later
                });
              },
              child: Text(
                "Reader",
              ),
            ),
            Spacer()
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

void _settingModalBottomSheet(context){
  showBarModalBottomSheet(
    expand: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context, scrollController) =>
        SignUpView(),
  );
}