import 'package:flutter/material.dart';

import 'package:itnew/Models/FontChange.dart';
import 'package:provider/provider.dart';
import '../Models/ThemeProvider.dart';

class CoChuvaFontChu extends StatefulWidget {
  const CoChuvaFontChu({Key? key}) : super(key: key);

  //const CoChuvaFontChu({super.key});

  @override
  State<CoChuvaFontChu> createState() => _CoChuvaFontChuState();
}

class _CoChuvaFontChuState extends State<CoChuvaFontChu> {
  // void updateFontsChus(String newFont) {
  //   // ----------------------------------------------- CẬP NHẬT FONT CHỮ -------------------
  //   setState(() {
  //     fontsChu.updateFontsChu(newFont);
  //     //selectedFont = newFont; // cập nhật kiểu chữ đã chọn
  //   });
  // }

  // void updateFontSize_CoChu(int newFontSize) {
  //   // ----------------------------------------------- CẬP NHẬT CỠ CHỮ -------------------
  //   setState(() {
  //     fontSize.updateFontSize(newFontSize);
  //   });
  // }

  // late FontsChu fontsChu;
  // late TangGiamFont fontSize;
  // late String selectedFont;

  // @override
  // void initState() {
  //   super.initState();
  //   fontsChu = FontsChu();
  //   fontSize = TangGiamFont();
  //   selectedFont = fontsChu.fontInter;
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FontTextProvider()..init()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()..init()),
      ],
      child: Consumer2<FontTextProvider, ThemeProvider>(
          builder: (context, fontProvider, themeProvider, child) {
        Color textColor = themeProvider.isDarkMode
            ? Colors.white
            : const Color.fromARGB(255, 24, 24, 24);
        return Scaffold(
          backgroundColor:
              themeProvider.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
              // automaticallyImplyLeading: false,
              // iconTheme: const IconThemeData(color: Colors.black),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isActive);
                  Navigator.pushNamed(context, '/caidat');
                },
              ),
              backgroundColor: const Color.fromARGB(222, 0, 183, 255),
              centerTitle: true,
              title: Text(
                'Font and Size Text',
                style: TextStyle(
                  fontFamily:
                      fontProvider.selectedFont == 'Inter' ? 'Inter' : 'Kalam',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
          body: Column(
            children: [
              Expanded(
                child: Column(
                  key: UniqueKey(),
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/img/g63.jpg',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'The news app is growing, trying its best...',
                      style: TextStyle(
                        fontSize: fontProvider.fontSize,
                        fontFamily: fontProvider.selectedFont == 'Inter'
                            ? 'Inter'
                            : 'Kalam',
                        color: textColor,
                      ),
                    ),
                    // Các phần khác của mã ở đây
                    // ...
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 15,
                          height: 120,
                        ),
                        Text(
                          'Size Text',
                          style: TextStyle(
                            fontFamily: fontProvider.selectedFont == 'Inter'
                                ? 'Inter'
                                : 'Kalam',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(width: 60),
                        IconButton(
                          onPressed: () {
                            fontProvider.decreaseFontSize();
                          },
                          icon: Icon(
                            Icons.arrow_circle_down_outlined,
                            color: textColor,
                            size: 50,
                          ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          fontProvider.fontSize.toInt().toString(),
                          style: TextStyle(
                            color: textColor,
                            fontFamily: fontProvider.selectedFont == 'Inter'
                                ? 'Inter'
                                : 'Kalam',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 30),
                        IconButton(
                          onPressed: () {
                            fontProvider.increaseFontSize();
                          },
                          icon: Icon(
                            Icons.arrow_circle_up_outlined,
                            color: textColor,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Font Text',
                          style: TextStyle(
                            color: textColor,
                            fontFamily: fontProvider.selectedFont == 'Inter'
                                ? 'Inter'
                                : 'Kalam',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 50),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              fontProvider.changeFont('Inter');
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            backgroundColor:
                                fontProvider.selectedFont == 'Inter'
                                    ? Colors.green
                                    : Colors.white,
                          ),
                          child: Text(
                            'Inter',
                            style: TextStyle(
                              fontFamily: fontProvider.selectedFont,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              fontProvider.changeFont('Kalam');
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(color: Colors.black),
                            backgroundColor:
                                fontProvider.selectedFont == 'Kalam'
                                    ? Colors.green
                                    : Colors.white,
                          ),
                          child: Text(
                            'Kalam',
                            style: TextStyle(
                              fontFamily: fontProvider.selectedFont,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
