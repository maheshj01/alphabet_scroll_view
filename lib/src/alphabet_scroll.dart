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

  final LetterAlignment alignment;

  AlphabetScrollView(
      {Key key,
      @required this.list,
      this.alignment = LetterAlignment.right,
      this.isAlphabetsFiltered = true,
      this.itemExtent = 40,
      @required this.itemBuilder})
      : super(key: key);

  /// defaults to ```true```
  /// if specified as ```false```
  /// all alphabets will be shown regardless of
  /// whether the item in the [list] exists starting with
  /// that alphabet.

  final bool isAlphabetsFiltered;

  /// The itemBuilder must return a non-null widget and the third paramter id specifies
  /// the string mapped to this widget form the ```[list]``` passed.
  Widget Function(BuildContext, int, String) itemBuilder;

  @override
  _AlphabetScrollViewState createState() => _AlphabetScrollViewState();
}

class _AlphabetScrollViewState extends State<AlphabetScrollView> {
  Future<void> init() {
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
  }

  void onVerticalDrag(Offset offset) {
    int index = getCurrentIndex(offset.dy);
    if (index < 0 || index >= _filteredAlphabets.length) return;
    setState(() {
      selected = index;
    });
    scrolltoIndex(index);
  }

  final Map<String, int> firstIndexPosition = {};
  final key = GlobalKey();
  final letterKey = GlobalKey();
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _filteredAlphabets.length,
                      (x) => GestureDetector(
                        key: x == 0 ? letterKey : null,
                        onTap: () {
                          setState(() {
                            selected = x;
                          });
                          scrolltoIndex(x);
                        },
                        child: Container(
                          color: selected == x
                              ? Theme.of(context).primaryColor
                              // Colors.blue.withOpacity(0.8)
                              : null,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          child: Text(
                            _filteredAlphabets[x].toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                color: selected == x
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class AlphaModel {
  final String key;
  final String secondaryKey;

  AlphaModel(this.key, {this.secondaryKey});
}
