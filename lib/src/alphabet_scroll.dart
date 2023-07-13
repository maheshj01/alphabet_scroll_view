import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


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
    return Column(
      children: [
        Container(
          height: 600,
          child: AlphabetScrollView()),
      ],
    );
  }
}


enum LetterAlignment { left, right }
class AlphabetScrollView extends StatefulWidget {

  // final List<AlphaModel> list;

  // final double itemExtent;

  // final LetterAlignment alignment;

  // final bool isAlphabetsFiltered;

  // final Widget Function(String)? overlayWidget;

  // final TextStyle selectedTextStyle;

  // final TextStyle unselectedTextStyle;

  // /// The itemBuilder must return a non-null widget and the third paramter id specifies
  // /// the string mapped to this widget from the ```[list]``` passed.

  // Widget Function(BuildContext, int, String) itemBuilder;

   AlphabetScrollView(
      {Key? key,
      // required this.list,
      // this.alignment = LetterAlignment.right,
      // this.isAlphabetsFiltered = true,
      // this.overlayWidget,
      // required this.selectedTextStyle,
      // required this.unselectedTextStyle,
      // this.itemExtent = 40,
      // required this.itemBuilder
      })
      : super(key: key);

  @override
  State<AlphabetScrollView> createState() => _AlphabetScrollViewState();
}

class _AlphabetScrollViewState extends State<AlphabetScrollView> {
  @override
  Widget build(BuildContext context) {
    return _AlphabetScrollRenderObject(
        alphabets,
      onLetterSelected: (x){
        print(x);
      },
    );
  }
}


class _AlphabetScrollRenderObject extends LeafRenderObjectWidget{
  final List<String> letters;
  final Function(String)? onLetterSelected;

  const _AlphabetScrollRenderObject(
    this.letters,
    {this.onLetterSelected
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomAlphabetListViewRenderBox(
      letters: letters,
      onLetterSelected: onLetterSelected,
    );
  }

}

class CustomAlphabetListViewRenderBox extends RenderBox{
    final List<String> letters;
  final Function(String)? onLetterSelected;
  /// location for the listItem to be rendered
  List<Offset>? _itemOffsets;
  String? selectedLetter;
  CustomAlphabetListViewRenderBox(
    {
      required this.letters,
      this.onLetterSelected
    }
  );

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void performLayout() {
    size = constraints.biggest;
    /// Will spread the available height equally across letters
    final itemHeight = size.height / letters.length;
    _itemOffsets = List.generate(
      letters.length,
      (index) => Offset(0, itemHeight * index),
    );
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent || event is PointerMoveEvent) {
      final position = event.localPosition;
      final selectedIndex = _itemOffsets?.indexWhere(
        (offset) => offset.dy <= position.dy && offset.dy + size.height / letters.length > position.dy,
      );
      if (selectedIndex != -1) {
        selectedLetter = letters[selectedIndex!];
        onLetterSelected!(selectedLetter!);
      }
    }
  }

   @override
  void paint(PaintingContext context, Offset offset) {
    final textStyle = TextStyle(fontSize: 16, color: Colors.black);
    final itemHeight = size.height / letters.length;

    for (var i = 0; i < letters.length; i++) {
      final itemOffset = _itemOffsets![i] + offset;
      final itemRect = Rect.fromLTWH(
        itemOffset.dx,
        itemOffset.dy,
        size.width,
        itemHeight,
      );
      final textSpan = TextSpan(text: letters[i], style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(context.canvas, itemOffset);
    }
  }

}


class AlphaModel {
  final String key;
  final String? secondaryKey;

  AlphaModel(this.key, {this.secondaryKey});
}

const List<String> alphabets = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
];
