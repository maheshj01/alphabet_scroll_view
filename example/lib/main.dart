import 'package:flutter/material.dart';

import 'package:alphabet_scroll/alphabet_scroll.dart';

void main() {
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> list =
        'Hello world how 123 43 67 67 78 are you this is alphabet scroll 3ASDS widget built with flutter I love building tools for productivity this also helps me to gain more experience and also to shwocase my work in the community it is kind of inspiring and Theres zero Risk Tolerance'
            .split(' ')
            .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: AlphabetScroll(
              list: list.map((e) => AlphaModel(e)).toList(),
              // isAlphabetsFiltered: false,
              itemExtent: 50,
              itemBuilder: (_, k, id) {
                return Container(
                  color: Colors.grey.withOpacity(0.4),
                  margin: EdgeInsets.symmetric(vertical: 2),
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Text(
                    '${id}',
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.7)),
                  ),
                );
              },
              onChange: (x) {
                print('Current Alphabet $x');
              },
            ),
          ),
          // Container(
          //   height: 400,
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
