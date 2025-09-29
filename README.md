# [alphabet_scroll_view: ^0.3.2](https://pub.dev/packages/alphabet_scroll_view)

A Scrollable ListView Widget with the dynamic vertical Alphabet List on the Side which you can drag and tap to scroll to the first item starting with that letter in the list.

## Features

- **Dynamic Height Calculation**: No need to specify `itemExtent` - automatically calculates item positions
- **Controller Support**: New `AlphabetScrollController` provides programmatic scroll-to-letter functionality  
- **Haptic Feedback**: Automatic haptic feedback when alphabet selection changes
- **Context-Aware Overlay**: `overlayBuilder` now receives `BuildContext` for better theming support
- Responsive on all screens of different Sizes and runs on all Flutter supported platforms
- show your own widget(`overlayBuilder`) when pointer is in focus with Screen
- Align the alphabet list on the left or right
- Tap or drag to scroll to particular Alphabet.

![ezgif com-gif-maker](https://user-images.githubusercontent.com/31410839/105130232-a58abc00-5b0c-11eb-930e-445ae498ba98.gif)

### Responsive on device of any size

![ezgif com-gif-maker (2)](https://user-images.githubusercontent.com/31410839/105130852-c7d10980-5b0d-11eb-9915-0996d808d5e9.gif)

### Installation

- Add the dependency

```
flutter pub add alphabet_scroll_view
```

- Import the package
  ​

```
import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';

```

### Example Usage

```dart
final AlphabetScrollController _controller = AlphabetScrollController();

AlphabetScrollView(
  list: list.map((e) => AlphaModel(e)).toList(),
  alignment: LetterAlignment.right,
  controller: _controller,
  selectedTextStyle: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.red,
    fontSize: 20
  ),
  unselectedTextStyle: TextStyle(
    fontWeight: FontWeight.normal,
    color: Colors.grey,
    fontSize: 18
  ),
  overlayBuilder: (BuildContext context, String selectedLetter) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColor,
      ),
      alignment: Alignment.center,
      child: Text(
        selectedLetter.toUpperCase(),
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  },
  itemBuilder: (context, index, id) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: ListTile(
        title: Text('$id'),
        subtitle: Text('Secondary text'),
        leading: Icon(Icons.person),
      ),
    );
  },
)

// Programmatically scroll to a letter
_controller.scrollToLetter('s');

// Listen to letter selection changes  
_controller.addListener(() {
  print('Selected letter: ${_controller.selectedLetter}');
});
```

### Controller Usage

The new `AlphabetScrollController` provides programmatic control:

```dart
final controller = AlphabetScrollController();

// Scroll to a specific letter
controller.scrollToLetter('m');

// Listen to selection changes
controller.addListener(() {
  if (controller.selectedLetter != null) {
    print('User selected: ${controller.selectedLetter}');
  }
});

// Don't forget to dispose
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

### Customize your overlay widget

<img width="552" alt="Screenshot 2021-01-24 at 1 12 37 PM" src="https://user-images.githubusercontent.com/31410839/105624279-9fffdf80-5e46-11eb-8900-bcb99ddf7220.png">

```
overlayBuilder: (BuildContext context, String selectedLetter) => Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: 50,
                    color: Colors.red,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      selectedLetter.toUpperCase(),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
```

<img width="549" alt="Screenshot 2021-01-24 at 1 09 55 PM" src="https://user-images.githubusercontent.com/31410839/105624283-a2fad000-5e46-11eb-9707-3c072c07a2d7.png">

```
 overlayBuilder: (BuildContext context, String selectedLetter) => Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      selectedLetter.toUpperCase(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
```

### Overlay Widget in Action

![ezgif com-gif-maker](https://user-images.githubusercontent.com/31410839/105623290-983c3d00-5e3e-11eb-9012-0f0e75fde074.gif)

Refer the [complete example here](https://github.com/maheshmnj/alphabet_scroll_view/blob/master/example/lib/main.dart)

### Breaking Changes in v0.4.0

- **Removed**: `itemExtent` parameter (automatic height calculation)
- **Replaced**: `overlayWidget: (String) → Widget` with `overlayBuilder: (BuildContext, String) → Widget`
- **Added**: `controller: AlphabetScrollController?` parameter  
- **Added**: Automatic haptic feedback on letter selection

### Migration Guide

**Old API:**
```dart
AlphabetScrollView(
  itemExtent: 50,
  overlayWidget: (value) => Container(
    child: Text(value),
  ),
  // ...
)
```

**New API:**
```dart  
AlphabetScrollView(
  // itemExtent removed - calculated automatically
  overlayBuilder: (context, selectedLetter) => Container(
    child: Text(selectedLetter),
  ),
  controller: AlphabetScrollController(), // optional
  // ...
)
```

### Contributing

You are welcome to contribute to this package, contribution doesnt necessarily mean sending a pull request it could be

- pointing out bugs/issues
- requesting a new feature
- improving the documentation

If you feel generous and confident send a PR but make sure theres an open issue if not feel free to create one before you send a PR. This helps Identify the problem and helps everyone to stay aligned with the issue :)
