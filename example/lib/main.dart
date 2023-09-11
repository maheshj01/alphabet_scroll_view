import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Alphabet ScrollView Demo',
        themeMode: ThemeMode.light,
        darkTheme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    list = list.map((String e) {
      return e.capitalize()!;
    }).toList();
    list.sort();
    for (int i = 0; i < list.length; i++) {
      final wKey = GlobalObjectKey(list[i]);
      _widgetKeys.add(wKey);
    }
    super.initState();
  }

  List<GlobalObjectKey> _widgetKeys = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Alphabet Scroll View Demo')),
      body: AlphabetScrollView<String>(
        list: list,
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            key: _widgetKeys[index],
            padding: const EdgeInsets.only(right: 20),
            child: ListTile(
              title: Text(list[index]),
              subtitle: Text('Secondary text index $index'),
              leading: Icon(Icons.person),
            ),
          );
        },
        onLetterChanged: (String x, int k) {
          print("Scroll to $k for $x");
          final listItem = list.firstWhere(
              (element) => element.startsWith(x.toUpperCase()),
              orElse: () => '');
          if (listItem.isEmpty) {
            print("listItem not found for $x");
            return;
          }
          final index = list.indexOf(listItem);

          // find position of widget
          final RenderBox? renderBox = _widgetKeys[index]
              .currentContext!
              .findRenderObject() as RenderBox?;
          final position = renderBox!.localToGlobal(Offset.zero);

          // animate to position
          _scrollController.jumpTo(
            position.dy,
          );

          // Scrollable.ensureVisible(_widgetKeys[index].currentContext!,
          //     duration:
          //         Duration(milliseconds: 300), // duration for scrolling time
          //     alignment: 0, // 0 mean, scroll to the top, 0.5 mean, half
          //     curve: Curves.bounceIn);
          // final index = list.firstWhere((element) => element.startsWith(x));
          // _scrollController.animateTo(index * 50.0,
          //     duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
        },
        overlayWidget: (value) => Stack(
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
                // color: Theme.of(context).primaryColor,
              ),
              alignment: Alignment.center,
              child: Text(
                '$value'.toUpperCase(),
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String? capitalize() {
    return this[0].toUpperCase() + substring(1);
  }

  String initals() {
    /// Returns the first letter of each word in the string.
    return this.split(' ').map((e) => e.capitalize()!.substring(0, 1)).join();
  }
}

List<String> list = [
  'angel',
  'bubbles',
  'shimmer',
  'angelic',
  'bubbly',
  'glimmer',
  'baby',
  'pink',
  'little',
  'butterfly',
  'sparkly',
  'doll',
  'sweet',
  'sparkles',
  'dolly',
  'sweetie',
  'sprinkles',
  'lolly',
  'princess',
  'fairy',
  'honey',
  'snowflake',
  'pretty',
  'sugar',
  'cherub',
  'lovely',
  'blossom',
  'Ecophobia',
  'Hippophobia',
  'Scolionophobia',
  'Ergophobia',
  'Musophobia',
  'Zemmiphobia',
  'Geliophobia',
  'Tachophobia',
  'Hadephobia',
  'Radiophobia',
  'Turbo Slayer',
  'Cryptic Hatter',
  'Crash TV',
  'Blue Defender',
  'Toxic Headshot',
  'Iron Merc',
  'Steel Titan',
  'Stealthed Defender',
  'Blaze Assault',
  'Venom Fate',
  'Dark Carnage',
  'Fatal Destiny',
  'Ultimate Beast',
  'Masked Titan',
  'Frozen Gunner',
  'Bandalls',
  'Wattlexp',
  'Sweetiele',
  'HyperYauFarer',
  'Editussion',
  'Experthead',
  'Flamesbria',
  'HeroAnhart',
  'Liveltekah',
  'Linguss',
  'Interestec',
  'FuzzySpuffy',
  'Monsterup',
  'MilkA1Baby',
  'LovesBoost',
  'Edgymnerch',
  'Ortspoon',
  'Oranolio',
  'OneMama',
  'Dravenfact',
  'Reallychel',
  'Reakefit',
  'Popularkiya',
  'Breacche',
  'Blikimore',
  'StoneWellForever',
  'Simmson',
  'BrightHulk',
  'Bootecia',
  'Spuffyffet',
  'Rozalthiric',
  'Bookman'
];
