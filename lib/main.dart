import 'package:flutter/material.dart';
import 'package:superapp/miniapp/view_layer/renderer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperApp PoC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SuperApp PoC', test: 'XXX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.test}) : super(key: key);

  final String title;
  final String test;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(builder: (BuildContext context) {
            return Renderer(url: 'anything');
          }
      ));
  }
}
