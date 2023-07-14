import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum LetterAlignment { left, right }

class AlphabetScrollView<T> extends StatefulWidget {
  final List<T> list;

  // final double itemExtent;

  // final LetterAlignment alignment;

  // final bool isAlphabetsFiltered;

  final Widget Function(String)? overlayWidget;

  // final TextStyle selectedTextStyle;

  // final TextStyle unselectedTextStyle;
  final Function(String)? onLetterChanged;
  // /// The itemBuilder must return a non-null widget and the third paramter id specifies
  // /// the string mapped to this widget from the ```[list]``` passed.
  final ScrollPhysics physics;

  final ScrollController? controller;

  /// context, index, letter
  Widget Function(BuildContext, int, String) itemBuilder;

  AlphabetScrollView(
      {Key? key,
      required this.list,
      // this.alignment = LetterAlignment.right,
      // this.isAlphabetsFiltered = true,
      this.overlayWidget,
      this.controller,
      // required this.selectedTextStyle,
      // required this.unselectedTextStyle,
      // this.itemExtent = 40,
      this.physics = const AlwaysScrollableScrollPhysics(),
      this.onLetterChanged,
      required this.itemBuilder})
      : super(key: key);

  @override
  State<AlphabetScrollView> createState() => _AlphabetScrollViewState();
}

class _AlphabetScrollViewState extends State<AlphabetScrollView> {
  ScrollController? _scrollController;
  int itemCount = 0;
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _scrollController = ScrollController();
    } else {
      _scrollController = widget.controller!;
    }
    itemCount = widget.list.length;
  }

  Map<String, double> letterToOffset = {};

  /// Maps the letter to the offset of the item in the list
  void calculateOffset<T>() {
    for (int i = 0; i < widget.list.length; i++) {
      final item = (widget.list as List<T>)[i];
      final letter = item.toString().substring(0, 1).toLowerCase();
      if (!letterToOffset.containsKey(letter)) {
        letterToOffset[letter] = i.toDouble();
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListView.builder(
            physics: widget.physics,
            controller: _scrollController,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return widget.itemBuilder(
                  context, index, alphabets[index].toUpperCase());
            },
          ),
        ),
        _AlphabetScrollRenderObject(
          alphabets,
          onLetterChanged: (letter) {
            final index = alphabets.indexOf(letter);
            // if (index != -1) {
            //   final randomOffset = Random().nextDouble() * itemCount;
            //   _scrollController.animateTo(randomOffset,
            //       duration: Duration(milliseconds: 300),
            //       curve: Curves.bounceIn);
            // }
          },
          overlayWidget: widget.overlayWidget,
        ),
      ],
    );
  }
}

class _AlphabetScrollRenderObject extends SingleChildRenderObjectWidget {
  final List<String> letters;
  final Function(String)? onLetterChanged;
  final Widget Function(String)? overlayWidget;

  const _AlphabetScrollRenderObject(this.letters,
      {this.onLetterChanged, this.overlayWidget});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomAlphabetListViewRenderBox(
        letters: letters,
        onLetterChanged: onLetterChanged,
        overlayWidget: overlayWidget,
        alignment: LetterAlignment.left);
  }
}

class CustomAlphabetListViewRenderBox extends RenderBox {
  final List<String> letters;
  final Function(String)? onLetterChanged;
  LetterAlignment alignment;
  final Widget Function(String)? overlayWidget;

  /// location for the listItem to be rendered
  List<Offset>? _itemOffsets;
  String? selectedLetter;
  int selectedIndex = -1;
  CustomAlphabetListViewRenderBox(
      {required this.letters,
      this.alignment = LetterAlignment.left,
      this.overlayWidget,
      this.onLetterChanged});

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void performLayout() {
    final biggest = constraints.biggest;
    size = Size(20, biggest.height);

    final dx = size.width - 20.0;
    final startOffset = 100.0;

    /// Will spread the available height equally across letters
    final itemHeight = (size.height - (2 * startOffset)) / letters.length;
    print(itemHeight);
    _itemOffsets = List.generate(
      letters.length,
      (index) => Offset(dx, itemHeight * index + startOffset),
    );
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent || event is PointerMoveEvent) {
      final position = event.localPosition;
      final newIndex = _itemOffsets!.indexWhere(
        (offset) =>
            offset.dy <= position.dy &&
            offset.dy + size.height / letters.length > position.dy,
      );
      if (newIndex != -1) {
        selectedLetter = letters[newIndex];
        if (newIndex != selectedIndex) {
          onLetterChanged!(selectedLetter!);
        }
        selectedIndex = newIndex;
        markNeedsPaint();
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (var i = 0; i < letters.length; i++) {
      bool isSelected = selectedIndex == i;
      final textStyle = isSelected
          ? TextStyle(fontSize: 20, color: Colors.green)
          : TextStyle(fontSize: 16, color: Colors.black);
      final itemHeight = size.height / letters.length;
      final itemOffset = _itemOffsets![i] + offset;

      final itemRect = Rect.fromLTWH(
        itemOffset.dx + itemHeight / 2,
        itemOffset.dy,
        itemHeight,
        itemHeight,
      );
      if (isSelected) {
        final squareRect = itemRect.deflate(4.0);
        context.canvas.drawRect(
            squareRect,
            Paint()
              ..color = Colors.blue
              ..style = PaintingStyle.fill);
      }
      final textSpan =
          TextSpan(text: letters[i].toUpperCase(), style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: 16);
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
