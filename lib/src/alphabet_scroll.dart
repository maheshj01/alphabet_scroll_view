import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
              title: 'Alphabet ScrollView Demo',
              themeMode:
                ThemeMode.light,
              darkTheme: ThemeData.dark(
                useMaterial3: true,),
              home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


enum LetterAlignment { left, right }
class AlphabetScrollView extends StatefulWidget {

  final List<AlphaModel> list;

  final double itemExtent;

  final LetterAlignment alignment;.

  final bool isAlphabetsFiltered;

  final Widget Function(String)? overlayWidget;

  final TextStyle selectedTextStyle;

  final TextStyle unselectedTextStyle;

  /// The itemBuilder must return a non-null widget and the third paramter id specifies
  /// the string mapped to this widget from the ```[list]``` passed.

  Widget Function(BuildContext, int, String) itemBuilder;

   AlphabetScrollView(
      {Key? key,
      required this.list,
      this.alignment = LetterAlignment.right,
      this.isAlphabetsFiltered = true,
      this.overlayWidget,
      required this.selectedTextStyle,
      required this.unselectedTextStyle,
      this.itemExtent = 40,
      required this.itemBuilder})
      : super(key: key);

  @override
  State<AlphabetScrollView> createState() => _AlphabetScrollViewState();
}

class _AlphabetScrollViewState extends State<AlphabetScrollView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class AlphabetScrollRenderObject extends MultiChildRenderObjectWidget{
  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    throw UnimplementedError();
  }

}

class AlphaModel {
  final String key;
  final String? secondaryKey;
  AlphaModel(this.key, {this.secondaryKey});
}
