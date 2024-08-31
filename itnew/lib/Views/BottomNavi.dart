import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../Models/ThemeProvider.dart';
import 'package:itnew/Models/FontChange.dart';

class BottomNavi extends StatelessWidget {
  BottomNavi({super.key, required this.index});
  final index;

  @override
  Widget build(BuildContext context) {
    // var themeProvider = Provider.of<ThemeProvider>(context);
    // var fontProvider = Provider.of<FontTextProvider>(context);
    // TextStyle labelStyle = TextStyle(
    //   fontFamily: fontProvider.selectedFont == 'Inter' ? 'Inter' : 'Kalam',
    //   fontSize: 12.0,
    //   fontWeight: FontWeight.bold,
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FontTextProvider()..init()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()..init()),
      ],
      child: Consumer2<FontTextProvider, ThemeProvider>(
          builder: (context, fontProvider, themeProvider, child) {
        TextStyle labelStyle = TextStyle(
          fontFamily: fontProvider.selectedFont == 'Inter' ? 'Inter' : 'Kalam',
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        );
        return Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: BottomNavigationBar(
            backgroundColor: themeProvider.isDarkMode
                ? const Color.fromARGB(255, 24, 24, 24)
                : Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: themeProvider.isDarkMode
                ? Colors.white
                : const Color.fromARGB(255, 24, 24, 24),
            items: const [
              BottomNavigationBarItem(
                label: 'News',
                icon: Icon(Icons.mail_outline),
              ),
              BottomNavigationBarItem(
                  label: 'Video', icon: Icon(Icons.video_collection_outlined)),
              BottomNavigationBarItem(
                  label: 'Setting', icon: Icon(Icons.settings)),
            ],
            currentIndex: index,
            onTap: (int indexOfItem) {
              if (indexOfItem == 0 &&
                  ModalRoute.of(context)?.settings.name != '/') {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacementNamed(context, '/');
              } else if (indexOfItem == 1 &&
                  ModalRoute.of(context)?.settings.name != '/video') {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushNamed(context, '/video');
              } else if (indexOfItem == 2 &&
                  ModalRoute.of(context)?.settings.name != '/caidat') {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushNamed(context, '/caidat');
              }
            },
            selectedLabelStyle: labelStyle,
            unselectedLabelStyle: labelStyle,
          ),
        );
      }),
    );
  }
}
