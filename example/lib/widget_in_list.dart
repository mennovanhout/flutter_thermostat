import 'package:flutter/material.dart';
import 'package:thermostat/thermostat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(
                  child: Thermostat(
                    maxVal: 100,
                    minVal: 0,
                    curVal: 26,
                    setPoint: 22,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: Container(
              color: Colors.redAccent,
              child: Center(child: Text('Block 1')),
            ),
          ),
          SizedBox(
            height: 300,
            child: Container(
              color: Colors.lightGreen,
              child: Center(child: Text('Block 2')),
            ),
          ),
        ],
      ),
    );
  }
}
