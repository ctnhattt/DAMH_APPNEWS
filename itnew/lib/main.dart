import 'package:flutter/material.dart';
import 'package:itnew/Views/CoChuvaFontChu.dart';
import 'package:itnew/Views/DaLuu.dart';
import 'package:itnew/Views/LichSu.dart';
import 'package:itnew/Views/TrangCaiDat.dart';
import 'package:itnew/Views/TrangChu.dart';
import 'package:itnew/Views/TrangVideo.dart';
import 'package:provider/provider.dart';
import 'Models/ThemeProvider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // tắt chữ debug trên app
      initialRoute: '/',
      routes: {
        '/': (context) => const TrangChu(
              title: '',
            ),
        '/caidat': (context) => const CaiDat(),
        '/video': (context) => TrangVideo(),
        '/daluu': (context) => const DaLuu(),
        '/lichsu': (context) => const LichSu(),
        '/cochuvafontchu': (context) => const CoChuvaFontChu(),
      },
    );
  }
}
