# [alphabet_scroll_view: ^0.2.0](https://pub.dev/packages/alphabet_scroll_view)

A Scrollable ListView Widget with the dynamic vertical Alphabet List on the Side which you can drag and tap to scroll to the first item starting with that letter in the list.

## Features

- Responsive on all screens of different Sizes and runs on all Flutter supported platforms
- show your own widget(`waterMark`) when pointer is in focus with Screen
- Align the alphabet list on the left or right
- Tap or drag to scroll to particular Alphabet.

![ezgif com-gif-maker](https://user-images.githubusercontent.com/31410839/105130232-a58abc00-5b0c-11eb-930e-445ae498ba98.gif)

### Responsive on device of any size

![ezgif com-gif-maker (2)](https://user-images.githubusercontent.com/31410839/105130852-c7d10980-5b0d-11eb-9915-0996d808d5e9.gif)

### Installation

- Add the dependency

```
dependencies:
  alphabet_scroll_view: ^0.2.0
```

- Import the package
  ​

```
import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';

```

### Example Usage

```
AlphabetScrollView(
    list: list.map((e) => AlphaModel(e)).toList()
    itemExtent: 50,
    itemBuilder: (_, k, id) {
    return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ListTile(
                    title: Text('$id'),
                    subtitle: Text('Secondary text'),
                    leading: Icon(Icons.label),
                    trailing: Radio<bool>(
                      value: false,
                      groupValue: selectedIndex != k,
                      onChanged: (value) {
                        setState(() {
                          selectedIndex = k;
                        });
                      },
                    ),
                ),
            );
        },
    ),
```

### Customize your waterMark

<img width="552" alt="Screenshot 2021-01-24 at 1 12 37 PM" src="https://user-images.githubusercontent.com/31410839/105624279-9fffdf80-5e46-11eb-8900-bcb99ddf7220.png">

```
waterMark: (value) => Stack(
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
                      '$value'.toUpperCase(),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
```

<img width="549" alt="Screenshot 2021-01-24 at 1 09 55 PM" src="https://user-images.githubusercontent.com/31410839/105624283-a2fad000-5e46-11eb-9707-3c072c07a2d7.png">

```
 waterMark: (value) => Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$value'.toUpperCase(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
```

### WaterMark in Action

![ezgif com-gif-maker](https://user-images.githubusercontent.com/31410839/105623290-983c3d00-5e3e-11eb-9012-0f0e75fde074.gif)

Refer the [complete example here](https://github.com/maheshmnj/alphabet_scroll_view/blob/master/example/lib/main.dart)

### Contributing

You are welcome to contribute to this package,contribution doesnt necessarily mean sending a pull request it could be

- pointing out bugs/issues
- requesting a new feature
- improving the documentation

If you feel generous and confident send a PR but make sure theres an open issue if not feel free to create one before you send a PR. This helps Identify the problem and helps everyone to stay aligned with the issue :)
