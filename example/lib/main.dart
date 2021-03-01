import 'package:example/json_parse_demo.dart';
import 'package:example/watcher_demo.dart';
import 'package:flutter/material.dart';

import 'eson_widget_demo.dart';

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
      home: MyHomePage(title: 'eson example'),
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),

            /// Basic pure JSON parsing operation without Model
            JsonParseDemo(),
            SizedBox(height: 20,),


            /// The watcher monitors the changes of the data, the granularity is to a single variable
            WatcherDemo(),
            SizedBox(height: 20,),


            /// Use Eson for partial refresh in Widget
            EsonWidgetDemo(),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }
}
