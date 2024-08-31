import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:itnew/Models/FontChange.dart';
import 'package:itnew/Models/ThemeProvider.dart';
import 'package:itnew/Models/Video.dart';
import 'package:itnew/ViewModels/VideoDetail.dart';
import 'package:itnew/ViewModels/VideoTitle.dart';
import 'package:itnew/Views/BottomNavi.dart';
import 'package:provider/provider.dart';

class TrangVideo extends StatefulWidget {
  TrangVideo({Key? key});

  @override
  State<TrangVideo> createState() => _TrangVideoState();
}

class _TrangVideoState extends State<TrangVideo> {
  DatabaseReference videosRef = FirebaseDatabase.instance.ref().child('videos');
  bool showUpdate = false;

  @override
  void initState() {
    super.initState();
    videosRef.child('videos').onValue.listen((event) {
      setState(() {
        showUpdate = true;
      });
      // Ẩn thông báo sau 3 giây
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          showUpdate = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FontTextProvider()..init()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()..init()),
      ],
      child: Consumer2<FontTextProvider, ThemeProvider>(
          builder: (context, fontProvider, themeProvider, child) {
        return Scaffold(
          backgroundColor:
              themeProvider.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isActive);
                  Navigator.pushNamed(context, '/');
                },
              ),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(222, 0, 183, 255),
              title: Text(
                'Watch',
                style: TextStyle(
                    fontFamily: fontProvider.selectedFont == 'Inter'
                        ? 'Inter'
                        : 'Kalam',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
          body: FirebaseAnimatedList(
            query: videosRef,
            itemBuilder: (context, snapshot, animation, index) {
              var video =
                  Video.fromJson(json.decode(json.encode(snapshot.value)));

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: VideoTitle(
                          video: video,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: VideoDetail(
                          video: video,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: BottomNavi(index: 1),
        );
      }),
    );
  }
}
