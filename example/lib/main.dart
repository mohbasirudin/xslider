import 'package:flutter/material.dart';
import 'package:xslider/xslider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageMain(),
    );
  }
}

class PageMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: XSlider.builder(
          initialPage: 0,
          maxLength: 5,
          height: 240,
          showButton: true,
          rounded: 24,
          autoSlide: true,
          infinityScrolling: true,
          itemBuilder: (context, index) => Center(
            child: Text(
              "$index",
              style: TextStyle(
                fontSize: 42,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
