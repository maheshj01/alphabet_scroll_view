import 'package:alphabet_scroll_view/src/meta.dart';
import 'package:flutter/material.dart';

enum LetterAlignment { left, right }

class AlphabetScrollView extends StatefulWidget {
  /// List of Items should be non Empty
  /// and you must map your
  /// ```
  ///  List<T> to List<AlphaModel>
  ///  e.g
  ///  List<UserModel> _list;
  ///  _list.map((user)=>AlphaModel(user.name)).toList();
  /// ```
  /// where each item of this ```list``` will be mapped to
  /// each widget returned by ItemBuilder to uniquely identify
  /// that widget.
  final List<AlphaModel> list;

  /// ```itemExtent``` specifies the max height of the widget returned by
  /// itemBuilder if not specified defaults to 40
  final double itemExtent;

  /// Alignment for the Alphabet List
  /// can be aligned on either left/right side
  /// of the screen
  final LetterAlignment alignment;

  AlphabetScrollView(
      {Key key,
      @required this.list,
      this.alignment = LetterAlignment.right,
      this.isAlphabetsFiltered = true,
      this.waterMark,
      this.itemExtent = 40,
      @required this.itemBuilder})
      : super(key: key);

  /// defaults to ```true```
  /// if specified as ```false```
  /// all alphabets will be shown regardless of
  /// whether the item in the [list] exists starting with
  /// that alphabet.

  final bool isAlphabetsFiltered;

  /// Widget to show beside the selected alphabet
  /// if not specified it will be hidden.
  /// ```
  /// waterMark:(value)=>
  ///    Container(
  ///       height: 50,
  ///       width: 50,
  ///       alignment: Alignment.center,
  ///       color: Theme.of(context).primaryColor,
  ///       child: Text(
  ///                 '$value'.toUpperCase(),
  ///                  style: TextStyle(fontSize: 20, color: Colors.white),
  ///              ),
  ///      )
  /// ```

  final Widget Function(String) waterMark;

  /// The itemBuilder must return a non-null widget and the third paramter id specifies
  /// the string mapped to this widget form the ```[list]``` passed.
  Widget Function(BuildContext, int, String) itemBuilder;

  @override
  _AlphabetScrollViewState createState() => _AlphabetScrollViewState();
}

class _AlphabetScrollViewState extends State<AlphabetScrollView> {
  void init() {
    widget.list
        .sort((x, y) => x.key.toLowerCase().compareTo(y.key.toLowerCase()));
    _list = widget.list;
    setState(() {});

    /// filter Out AlphabetList
    if (widget.isAlphabetsFiltered) {
      List<String> temp = [];
      alphabets.forEach((letter) {
        AlphaModel firstAlphabetElement = _list.firstWhere(
            (item) => item.key.toLowerCase().startsWith(letter.toLowerCase()),
            orElse: () => null);
        if (firstAlphabetElement != null) {
          temp.add(letter);
        }
      });
      _filteredAlphabets = temp;
    } else {
      _filteredAlphabets = alphabets;
    }
    calculateFirstIndex();
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  ScrollController listController = ScrollController();
  int selected = 0;
  List<AlphaModel> _list = [];
  List<String> _filteredAlphabets = [];
  bool isLoading = false;
  @override
  void didUpdateWidget(covariant AlphabetScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.list != widget.list ||
        oldWidget.isAlphabetsFiltered != widget.isAlphabetsFiltered) {
      _list.clear();
      firstIndexPosition.clear();
      init();
    }
  }

  int getCurrentIndex(double vPosition) {
    double kAlphabetHeight = letterKey.currentContext.size.height;
    return (vPosition ~/ kAlphabetHeight);
  }

  /// calculates and Maintains a map of
  /// [letter:index] of the position the first Item in list
  /// starting with that letter.
  /// This helps to avoid recomputing the position to scroll to
  /// on each Scroll.
  void calculateFirstIndex() {
    _filteredAlphabets.forEach((letter) {
      AlphaModel firstElement = _list.firstWhere(
          (item) => item.key.toLowerCase().startsWith(letter),
          orElse: () => null);
      if (firstElement != null) {
        int index = _list.indexOf(firstElement);
        firstIndexPosition[letter] = index;
      }
    });
  }

  void scrolltoIndex(int x) {
    final maxScroll = listController.position.maxScrollExtent;
    int index = firstIndexPosition[_filteredAlphabets[x].toLowerCase()];
    final scrollToPostion = widget.itemExtent * index;
    if (index != null && !(scrollToPostion > maxScroll)) {
      listController.animateTo((widget.itemExtent * index),
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      // widget.onChange(_filteredAlphabets.elementAt(x));
    }
    getSelectedLetterPosition();
  }

  void onVerticalDrag(Offset offset) {
    int index = getCurrentIndex(offset.dy);
    if (index < 0 || index >= _filteredAlphabets.length) return;
    setState(() {
      selected = index;
      isFocused = true;
    });
    scrolltoIndex(index);
  }

  getSelectedLetterPosition() {
    final RenderBox renderBoxRed = letterKey.currentContext.findRenderObject();
    final letterPosition = renderBoxRed.localToGlobal(Offset.zero);
    positionNotifer.value = letterPosition;
  }

  final Map<String, int> firstIndexPosition = {};
  final key = GlobalKey();
  final letterKey = GlobalKey();
  bool isFocused = false;
  final positionNotifer = ValueNotifier<Offset>(Offset(0, 0));
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
            controller: listController,
            scrollDirection: Axis.vertical,
            itemCount: _list.length,
            itemBuilder: (_, x) {
              return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: widget.itemExtent),
                  child: widget.itemBuilder(_, x, _list[x].key));
            }),
        Align(
          alignment: widget.alignment == LetterAlignment.left
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
            key: key,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: SingleChildScrollView(
              child: GestureDetector(
                onVerticalDragStart: (z) => onVerticalDrag(z.localPosition),
                onVerticalDragUpdate: (z) => onVerticalDrag(z.localPosition),
                onVerticalDragEnd: (z) {
                  setState(() {
                    isFocused = false;
                  });
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _filteredAlphabets.length,
                      (x) => GestureDetector(
                        key: x == selected ? letterKey : null,
                        onTap: () {
                          setState(() {
                            selected = x;
                          });
                          scrolltoIndex(x);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          child: Text(
                            _filteredAlphabets[x].toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: selected == x
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ),
        !isFocused
            ? Container()
            : ValueListenableBuilder<Offset>(
                valueListenable: positionNotifer,
                builder: (BuildContext context, Offset position, Widget child) {
                  return Positioned(
                      right:
                          widget.alignment == LetterAlignment.right ? 40 : null,
                      left:
                          widget.alignment == LetterAlignment.left ? 40 : null,
                      top: position.dy - widget.itemExtent - 20,
                      child: widget.waterMark == null
                          ? Container()
                          : widget.waterMark(_filteredAlphabets[selected]));
                })
      ],
    );
  }
}

class AlphaModel {
  final String key;
  final String secondaryKey;

  AlphaModel(this.key, {this.secondaryKey});
}
