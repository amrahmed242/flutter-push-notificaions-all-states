import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutternotificationdemo/notification_service.dart';
import 'package:flutternotificationdemo/preference.dart';

void main() async {
  //Ensure all Platform Plugins Initialized
  WidgetsFlutterBinding.ensureInitialized();

  //init Preference service
  await Preference.init();
  NotificationService();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 2), (c) {
      setState(() {});
    });
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    String ss1 = Preference.getString('key1') ?? 'empty';
    String ss2 = Preference.getString('key2') ?? 'empty';
    String ss3 = Preference.getString('key3') ?? 'empty';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              DateTime.now().toIso8601String(),
              textAlign: TextAlign.center,
            ),
            Text(ss1, textAlign: TextAlign.center),
            Text(ss2, textAlign: TextAlign.center),
            Text(ss3, textAlign: TextAlign.center),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
