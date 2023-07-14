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
    list.sort();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alphabet Scroll View Demo')),
      body: AlphabetScrollView<String>(
        list: list,
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            key: GlobalObjectKey(list[index]),
            padding: const EdgeInsets.only(right: 20),
            child: ListTile(
              title: Text(list[index]),
              subtitle: Text('Secondary text'),
              leading: Icon(Icons.person),
            ),
          );
        },
        onLetterChanged: (x) {
          final listItem = list.firstWhere((element) => element.startsWith(x),
              orElse: () => '');
          if (listItem.isEmpty) return;
          final index = list.indexOf(listItem);
          // Scrollable.ensureVisible(GlobalObjectKey(index).currentContext!,
          //     duration: Duration(seconds: 1), // duration for scrolling time
          //     alignment: .5, // 0 mean, scroll to the top, 0.5 mean, half
          //     curve: Curves.easeInOutCubic);
          // final index = list.firstWhere((element) => element.startsWith(x));
          _scrollController.animateTo(index * 50.0,
              duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
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

//   int selectedIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: AlphabetScrollView(
//               list: list.map((e) => AlphaModel(e)).toList(),
//               // isAlphabetsFiltered: false,
//               alignment: LetterAlignment.right,
//               itemExtent: 50,
//               unselectedTextStyle: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.normal,
//                 color: Colors.black
//               ),
//               selectedTextStyle: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red
//               ),
//               overlayWidget: (value) => Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Icon(
//                     Icons.star,
//                     size: 50,
//                     color: Colors.red,
//                   ),
//                   Container(
//                     height: 50,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       // color: Theme.of(context).primaryColor,
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       '$value'.toUpperCase(),
//                       style: TextStyle(fontSize: 18, color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//               itemBuilder: (_, k, id) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 20),
//                   child: ListTile(
//                     title: Text('$id'),
//                     subtitle: Text('Secondary text'),
//                     leading: Icon(Icons.person),
//                     trailing: Radio<bool>(
//                       value: false,
//                       groupValue: selectedIndex != k,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedIndex = k;
//                         });
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           FloatingActionButton(
//             onPressed: _incrementCounter,
//             tooltip: 'Increment',
//             child: Icon(Icons.add),
//           ),
//         ],
//       ),
//     );
//   }
// }
