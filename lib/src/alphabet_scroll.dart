import 'package:alphabet_scroll/src/meta.dart';
import 'package:flutter/material.dart';

class AlphabetScroll extends StatefulWidget {
  /// List of Items should be non Empty
  /// should contain List of Strings
  /// if String is a non alphabet
  /// it will be considered based on its ascii value
  /// and assigned an alphabet internally
  final List<AlphaModel> list;

  /// max height of each Item
  final double itemExtent;
  final TextStyle alphabetStyle;
  AlphabetScroll(
      {Key key,
      @required this.list,
      // this.onChange,
      this.isAlphabetsFiltered = true,
      this.alphabetStyle,
      this.itemExtent = 40,
      @required this.itemBuilder})
      : super(key: key);

  /// defaults to ```true```
  /// if specified as ```false```
  /// all alphabets will be shown regardless of
  /// whether the item in the [list] exists with
  /// that alphabet.

  final bool isAlphabetsFiltered;

  /// returns the current Item being Scrolled
  // final Function(String) onChange;

  Widget Function(BuildContext context, int index, String id) itemBuilder;

  @override
  _AlphabetScrollState createState() => _AlphabetScrollState();
}

class _AlphabetScrollState extends State<AlphabetScroll> {
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
    // TODO: implement initState
    super.initState();
    init();
  }

  ScrollController listController = ScrollController();
  int selected = 0;
  List<AlphaModel> _list = [];
  List<String> _filteredAlphabets = [];

  @override
  void didUpdateWidget(covariant AlphabetScroll oldWidget) {
    // TODO: implement didUpdateWidget
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
  /// letter:index of the position the first Item in list
  /// starting with that letter.
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

  ////    TODO: put a check for scroll offset
  /// if(listController.offset == listController.position.maxScrollExtent){
  ///     do not try to scroll,since already at the end of the list
  /// }
  void scrolltoIndex(int x) {
    int index = firstIndexPosition[_filteredAlphabets[x].toLowerCase()];
    if (index != null) {
      listController.animateTo((widget.itemExtent * index),
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      // widget.onChange(_filteredAlphabets.elementAt(x));
    }
  }

  void onVerticalDrag(Offset offset) {
    int index = getCurrentIndex(offset.dy);
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
    // TODO: implement build
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
          alignment: Alignment.centerRight,
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
                              ? Colors.blue.withOpacity(0.8)
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
