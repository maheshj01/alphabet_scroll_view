# [alphabet_scroll_view: ^0.1.0](https://pub.dev/packages/alphabet_scroll_view)

A Scrollable ListView Widget with the dynamic vertical Alphabet List on the Side which you can drag and tap to scroll to the first item starting with that letter in the list.

## Supported Platforms

Compatible with All platforms and all screens of different Sizes.

- Android
- Ios
- Web
- Macos

![ezgif com-gif-maker](https://user-images.githubusercontent.com/31410839/105130232-a58abc00-5b0c-11eb-930e-445ae498ba98.gif)

![ezgif com-gif-maker (2)](https://user-images.githubusercontent.com/31410839/105130852-c7d10980-5b0d-11eb-9915-0996d808d5e9.gif)

### Installation

- Add the dependency

```
dependencies:
  alphabet_scroll_view: ^0.1.0
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

### Contributing

You are welcome to contribute to this package,contribution doesnt necessarily mean sending a pull request it could be

- pointing out bugs/issues
- requesting a new feature
- improving the documentation

If you feel generous and confident send a PR but make sure theres an open issue if not feel free to create one before you send a PR. This helps Identify the problem and helps everyone to stay aligned with the issue :)
