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
  final Function(String, int)? onLetterChanged;
  // /// The itemBuilder must return a non-null widget and the third paramter id specifies
  // /// the string mapped to this widget from the ```[list]``` passed.
  final ScrollPhysics physics;

  final ScrollController? controller;

  /// context, index, letter
  final Widget Function(BuildContext, int) itemBuilder;

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
  State<AlphabetScrollView> createState() => _AlphabetScrollViewState<T>();
}

class _AlphabetScrollViewState<T> extends State<AlphabetScrollView> {
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
    calculateIndexOfLetter<T>();
  }

  /// Stores the index of the first letter of each alphabet.
  Map<String, int> indexOf = {};

  List<String> alphabets = [];

  /// Calculates the index of the first letter of each alphabet.
  void calculateIndexOfLetter<T>() {
    for (int i = 0; i < widget.list.length; i++) {
      final item = (widget.list as List<T>)[i];
      final letter = item.toString().substring(0, 1).toLowerCase();
      if (!indexOf.containsKey(letter)) {
        alphabets.add(letter);
        indexOf[letter] = i;
      }
    }
    alphabets.sort();
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
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          child: ListView.builder(
            physics: widget.physics,
            cacheExtent: 999999,
            controller: _scrollController,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return widget.itemBuilder(context, index);
            },
          ),
        ),
        _AlphabetScrollRenderObject(
          alphabets,
          screenSize: size,
          onLetterChanged: (letter) =>
              widget.onLetterChanged!(letter, indexOf[letter]!),
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
  final ScrollController? controller;
  final Size screenSize;

  const _AlphabetScrollRenderObject(this.letters,
      {this.controller,
      this.onLetterChanged,
      required this.screenSize,
      this.overlayWidget});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomAlphabetListViewRenderBox(
        letters: letters,
        onLetterChanged: onLetterChanged,
        overlayWidget: overlayWidget,
        screenSize: screenSize,
        alignment: LetterAlignment.left);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
  }
}

class MyExampleParentData extends ContainerBoxParentData<RenderBox> {}

class CustomAlphabetListViewRenderBox extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, MyExampleParentData> {
  final List<String> letters;
  final Size screenSize;
  final Function(String)? onLetterChanged;
  LetterAlignment alignment;
  final Widget Function(String)? overlayWidget;

  List<Offset>? _letterOffset;
  String? selectedLetter;
  bool isPointerDown = false;
  int selectedIndex = -1;
  // padding from top
  final startOffset = 100.0;

  CustomAlphabetListViewRenderBox(
      {required this.letters,
      this.alignment = LetterAlignment.left,
      this.overlayWidget,
      required this.screenSize,
      this.onLetterChanged});

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void performLayout() {
    final biggest = constraints.biggest;
    size = Size(20, biggest.height);

    // padding from right
    final dx = size.width - 20.0;

    /// Will spread the available height equally across letters
    final itemHeight = (size.height - (2 * startOffset)) / letters.length;
    _letterOffset = List.generate(
      letters.length,
      (index) => Offset(dx, itemHeight * index + startOffset),
    );
  }

  void printOffsets() {
    for (var i = 0; i < _letterOffset!.length; i++) {
      print('offset $i ${_letterOffset![i]}');
    }
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event is PointerDownEvent || event is PointerMoveEvent) {
      isPointerDown = true;
      final position = event.localPosition;
      final itemHeight = (size.height - (2 * startOffset)) / letters.length;
      int newIndex = -1;

      for (var i = 0; i < _letterOffset!.length; i++) {
        final start = _letterOffset![i];
        final Offset end = Offset(start.dx, start.dy + itemHeight);
        if (position.dy >= start.dy && position.dy <= end.dy) {
          newIndex = i;
          break;
        }
      }

      if (newIndex != -1) {
        selectedLetter = letters[newIndex];
        if (newIndex != selectedIndex) {
          onLetterChanged!(selectedLetter!);
        }
        selectedIndex = newIndex;
        markNeedsPaint();
      }
    }
    if (event is PointerUpEvent) {
      isPointerDown = false;
      markNeedsPaint();
    }
  }

  void paintOverlay(PaintingContext context, Offset offset, String letter) {
    final circlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    final width = screenSize.width;
    final radius = 30.0;
    final circleOffset =
        Offset(width - 60, _letterOffset![selectedIndex].dy + radius / 2);
    context.canvas.drawCircle(circleOffset, radius, circlePaint);

    final textStyle = TextStyle(fontSize: 20, color: Colors.white);
    final textSpan =
        TextSpan(text: selectedLetter!.toUpperCase(), style: textStyle);
    final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout();
    final textOffset = Offset(circleOffset.dx - textPainter.width / 2,
        circleOffset.dy - textPainter.height / 2);
    textPainter.paint(context.canvas, textOffset);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (isPointerDown) {
      //  paint a circle with the selected letter
      paintOverlay(context, offset, selectedLetter!);
    }
    for (var i = 0; i < letters.length; i++) {
      final isSelected = selectedIndex == i;
      final textStyle = isSelected
          ? TextStyle(fontSize: 20, color: Colors.green)
          : TextStyle(fontSize: 16, color: Colors.black);
      final itemHeight = size.height / letters.length;
      final itemOffset = _letterOffset![i] + offset;

      final itemRect = Rect.fromLTWH(
        itemOffset.dx + itemHeight / 2,
        itemOffset.dy,
        itemHeight,
        itemHeight,
      );
      if (isSelected) {
        final squareRect = itemRect.deflate(0.0);
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
