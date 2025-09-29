import 'package:alphabet_scroll_view/src/meta.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum LetterAlignment { left, right }

/// Controller for AlphabetScrollView that provides scroll-to-letter functionality
/// and allows adding listeners for letter selection changes
class AlphabetScrollController extends ChangeNotifier {
  String? _selectedLetter;
  late _AlphabetScrollViewState _state;

  /// The currently selected letter
  String? get selectedLetter => _selectedLetter;

  /// Scroll to a specific letter in the alphabet list
  void scrollToLetter(String letter) {
    if (_state._filteredAlphabets.contains(letter.toLowerCase())) {
      final index = _state._filteredAlphabets.indexOf(letter.toLowerCase());
      _state._selectedIndexNotifier.value = index;
      _state.scrolltoIndex(index, _state.positionNotifer.value);
    }
  }

  void _attach(_AlphabetScrollViewState state) {
    _state = state;
  }

  void _updateSelectedLetter(String letter) {
    if (_selectedLetter != letter) {
      _selectedLetter = letter;
      // Trigger haptic feedback when letter changes
      HapticFeedback.selectionClick();
      notifyListeners();
    }
  }
}

class AlphabetScrollView extends StatefulWidget {
  AlphabetScrollView(
      {Key? key,
      required this.list,
      this.alignment = LetterAlignment.right,
      this.isAlphabetsFiltered = true,
      this.overlayBuilder,
      required this.selectedTextStyle,
      required this.unselectedTextStyle,
      this.controller,
      required this.itemBuilder})
      : super(key: key);

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

  /// Alignment for the Alphabet List
  /// can be aligned on either left/right side
  /// of the screen
  final LetterAlignment alignment;

  /// defaults to ```true```
  /// if specified as ```false```
  /// all alphabets will be shown regardless of
  /// whether the item in the [list] exists starting with
  /// that alphabet.

  final bool isAlphabetsFiltered;

  /// Builder for the overlay widget that appears beside the selected alphabet
  /// if not specified it will be hidden.
  /// ```
  /// overlayBuilder: (BuildContext context, String selectedLetter) =>
  ///    Container(
  ///       height: 50,
  ///       width: 50,
  ///       alignment: Alignment.center,
  ///       color: Theme.of(context).primaryColor,
  ///       child: Text(
  ///                 selectedLetter.toUpperCase(),
  ///                  style: TextStyle(fontSize: 20, color: Colors.white),
  ///              ),
  ///      )
  /// ```

  final Widget Function(BuildContext, String)? overlayBuilder;

  /// Controller that provides scroll-to-letter functionality and letter selection listeners
  final AlphabetScrollController? controller;

  /// Text styling for the selected alphabet by which
  /// we can customize the font color, weight, size etc.
  /// ```
  /// selectedTextStyle:
  ///   TextStyle(
  ///     fontWeight: FontWeight.bold,
  ///     color: Colors.black,
  ///     fontSize: 20
  ///   )
  /// ```

  final TextStyle selectedTextStyle;

  /// Text styling for the unselected alphabet by which
  /// we can customize the font color, weight, size etc.
  /// ```
  /// unselectedTextStyle:
  ///   TextStyle(
  ///     fontWeight: FontWeight.normal,
  ///     color: Colors.grey,
  ///     fontSize: 18
  ///   )
  /// ```

  final TextStyle unselectedTextStyle;

  /// The itemBuilder must return a non-null widget and the third paramter id specifies
  /// the string mapped to this widget from the ```[list]``` passed.

  Widget Function(BuildContext, int, String) itemBuilder;

  @override
  _AlphabetScrollViewState createState() => _AlphabetScrollViewState();
}

class _AlphabetScrollViewState extends State<AlphabetScrollView> {
  late AlphabetScrollController _controller;
  final Map<int, double> _itemOffsets = {};
  final GlobalKey _listViewKey = GlobalKey();
  
  void init() {
    widget.list
        .sort((x, y) => x.key.toLowerCase().compareTo(y.key.toLowerCase()));
    _list = widget.list;
    setState(() {});

    /// filter Out AlphabetList
    if (widget.isAlphabetsFiltered) {
      List<String> temp = [];
      alphabets.forEach((letter) {
        AlphaModel? firstAlphabetElement = _list.firstWhereOrNull(
            (item) => item.key.toLowerCase().startsWith(letter.toLowerCase()));
        if (firstAlphabetElement != null) {
          temp.add(letter);
        }
      });
      _filteredAlphabets = temp;
    } else {
      _filteredAlphabets = alphabets;
    }
    calculateFirstIndex();
    _calculateItemOffsets();
    setState(() {});
  }

  @override
  void initState() {
    _controller = widget.controller ?? AlphabetScrollController();
    _controller._attach(this);
    init();
    if (listController.hasClients) {
      maxScroll = listController.position.maxScrollExtent;
    }
    super.initState();
  }

  ScrollController listController = ScrollController();
  final _selectedIndexNotifier = ValueNotifier<int>(0);
  final positionNotifer = ValueNotifier<Offset>(Offset(0, 0));
  final Map<String, int> firstIndexPosition = {};
  List<String> _filteredAlphabets = [];
  final letterKey = GlobalKey();
  List<AlphaModel> _list = [];
  bool isLoading = false;
  bool isFocused = false;
  final key = GlobalKey();

  @override
  void didUpdateWidget(covariant AlphabetScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller = widget.controller ?? AlphabetScrollController();
      _controller._attach(this);
    }
    if (oldWidget.list != widget.list ||
        oldWidget.isAlphabetsFiltered != widget.isAlphabetsFiltered) {
      _list.clear();
      firstIndexPosition.clear();
      _itemOffsets.clear();
      init();
    }
  }

  int getCurrentIndex(double vPosition) {
    double kAlphabetHeight = letterKey.currentContext!.size!.height;
    return (vPosition ~/ kAlphabetHeight);
  }

  /// Calculate and store offsets for each item to enable precise scrolling
  /// without requiring itemExtent
  void _calculateItemOffsets() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_listViewKey.currentContext != null) {
        // This would typically be calculated based on rendered item heights
        // For now, we'll use a default height and calculate based on item count
        double cumulativeHeight = 0.0;
        const double defaultItemHeight = 56.0; // Material ListTile default height
        
        for (int i = 0; i < _list.length; i++) {
          _itemOffsets[i] = cumulativeHeight;
          cumulativeHeight += defaultItemHeight;
        }
      }
    });
  }

  /// calculates and Maintains a map of
  /// [letter:index] of the position of the first Item in list
  /// starting with that letter.
  /// This helps to avoid recomputing the position to scroll to
  /// on each Scroll.
  void calculateFirstIndex() {
    _filteredAlphabets.forEach((letter) {
      AlphaModel? firstElement = _list.firstWhereOrNull(
          (item) => item.key.toLowerCase().startsWith(letter));
      if (firstElement != null) {
        int index = _list.indexOf(firstElement);
        firstIndexPosition[letter] = index;
      }
    });
  }

  void scrolltoIndex(int x, Offset offset) {
    final letter = _filteredAlphabets[x].toLowerCase();
    final index = firstIndexPosition[letter];
    if (index != null) {
      // Use calculated offset instead of itemExtent * index
      final scrollToPosition = _itemOffsets[index] ?? 0.0;
      listController.animateTo(scrollToPosition,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      
      // Update controller with selected letter and trigger haptic feedback
      _controller._updateSelectedLetter(_filteredAlphabets[x]);
    }
    positionNotifer.value = offset;
  }

  void onVerticalDrag(Offset offset) {
    int index = getCurrentIndex(offset.dy);
    if (index < 0 || index >= _filteredAlphabets.length) return;
    _selectedIndexNotifier.value = index;
    setState(() {
      isFocused = true;
    });
    scrolltoIndex(index, offset);
  }

  double? maxScroll;

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
            key: _listViewKey,
            controller: listController,
            scrollDirection: Axis.vertical,
            itemCount: _list.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (_, x) {
              return widget.itemBuilder(_, x, _list[x].key);
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
                child: ValueListenableBuilder<int>(
                    valueListenable: _selectedIndexNotifier,
                    builder: (context, int selected, Widget? child) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _filteredAlphabets.length,
                            (x) => GestureDetector(
                              key: x == selected ? letterKey : null,
                              onTap: () {
                                _selectedIndexNotifier.value = x;
                                scrolltoIndex(x, positionNotifer.value);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                child: Text(
                                  _filteredAlphabets[x].toUpperCase(),
                                  style: selected == x
                                      ? widget.selectedTextStyle
                                      : widget.unselectedTextStyle,
                                ),
                              ),
                            ),
                          ));
                    }),
              ),
            ),
          ),
        ),
        !isFocused
            ? Container()
            : ValueListenableBuilder<Offset>(
                valueListenable: positionNotifer,
                builder:
                    (BuildContext context, Offset position, Widget? child) {
                  return Positioned(
                      right:
                          widget.alignment == LetterAlignment.right ? 40 : null,
                      left:
                          widget.alignment == LetterAlignment.left ? 40 : null,
                      top: position.dy,
                      child: widget.overlayBuilder == null
                          ? Container()
                          : widget.overlayBuilder!(context, _filteredAlphabets[
                              _selectedIndexNotifier.value]));
                })
      ],
    );
  }
}

class AlphaModel {
  final String key;
  final String? secondaryKey;

  AlphaModel(this.key, {this.secondaryKey});
}
