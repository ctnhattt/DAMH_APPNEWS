import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itnew/Models/FontChange.dart';
import 'package:itnew/Models/SaveArticle.dart';
import 'package:itnew/ViewModels/News.dart';
import 'package:provider/provider.dart';
import '../Models/ThemeProvider.dart';

class TrangChiTiet extends StatefulWidget {
  final title;
  final imagedata;
  final description;
  final date;
  final link;

  const TrangChiTiet({
    super.key,
    required this.title,
    required this.imagedata,
    required this.description,
    required this.date,
    required this.link,
  });

  @override
  State<TrangChiTiet> createState() => _TrangChiTietState();
}

class _TrangChiTietState extends State<TrangChiTiet> {
  late User? user = FirebaseAuth.instance.currentUser;
  bool isArticleSaved = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String userId;
  void _showLoginAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Login required.',
            //style: TextStyle(fontFamily: fontProvider.selectedFont == 'Inter' ? 'Inter' : 'Kalam',),
          ),
          content: const Text(
            'Please log in to use this function.',
            //style: TextStyle(fontFamily: fontsChu.fontInter == 'Inter' ? 'Inter' : 'Kalam',)
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  //style: TextStyle(fontFamily: fontsChu.fontInter == 'Inter' ? 'Inter' : 'Kalam',)
                )),
          ],
        );
      },
    );
  }

  void _showSnackBar(String mess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mess),
        duration: const Duration(seconds: 1),
      ),
    );
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
          Color textColor = themeProvider.isDarkMode
              ? Colors.white
              : const Color.fromARGB(255, 24, 24, 24);
          return Scaffold(
            backgroundColor:
                themeProvider.isDarkMode ? Colors.black : Colors.white,
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(222, 0, 183, 255),
              title: Text(
                'ITFEEDS',
                style: TextStyle(
                  fontFamily:
                      fontProvider.selectedFont == 'Inter' ? 'Inter' : 'Kalam',
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                IconButton(
                  onPressed: () async {
                    try {
                      if (user != null) {
                        String userId = user!.uid;
                        Map<String, dynamic> articleData = {
                          'title': widget.title,
                          'imagedata': widget.imagedata,
                          'description': widget.description,
                          'date': widget.date,
                          'link': widget.link,
                        };

                        print('mã tài khoản: $userId');
                        print('lưu thành công');
                        await SaveArticle().saveArticle(userId, articleData);
                        _showSnackBar('Đã lưu tin tức vào danh sách');

                        setState(() {
                          isArticleSaved = !isArticleSaved;
                        });
                      } else {
                        _showLoginAlertDialog();
                      }
                    } catch (e) {
                      print('Lỗi: $e');
                    }
                  },
                  icon: Icon(
                    isArticleSaved ? Icons.bookmark : Icons.bookmark_outline,
                    color: isArticleSaved ? Colors.yellow : Colors.black,
                    size: 40,
                  ),
                )
              ],
            ),
            body: ListView(
              children: [
                Image.network(
                  widget.imagedata ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title ?? '',
                        style: TextStyle(
                          fontFamily: fontProvider.selectedFont == 'Inter'
                              ? 'Inter'
                              : 'Kalam',
                          fontWeight: FontWeight.w500,
                          fontSize: fontProvider.fontSize.toDouble(),
                          color: textColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          widget.date.toString().substring(5, 34),
                          style: TextStyle(
                            fontFamily: fontProvider.selectedFont == 'Inter'
                                ? 'Inter'
                                : 'Kalam',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: textColor,
                          ),
                        ),
                      ),
                      Text(
                        (widget.description != null &&
                                widget.description.toString().contains('<div>'))
                            ? (() {
                                String noidung = widget.description.toString();
                                int startDivIndex = noidung.indexOf(
                                    '<div>', noidung.indexOf('<div>') + 1);
                                int endDivIndex =
                                    noidung.indexOf('</div>', startDivIndex);
                                String contentdescription = noidung.substring(
                                    startDivIndex + 5, endDivIndex);
                                return contentdescription;
                              })()
                            : 'Không có mô tả hoặc mô tả không hợp lệ',
                        style: TextStyle(
                          fontFamily: fontProvider.selectedFont == 'Inter'
                              ? 'Inter'
                              : 'Kalam',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsWebView(
                          url: widget.link.toString().substring(
                              5, widget.link.toString().indexOf('}', 5)),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Xem chi tiết >>>",
                      style: TextStyle(
                        fontFamily: fontProvider.selectedFont == 'Inter'
                            ? 'Inter'
                            : 'Kalam',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



                      // if (isArticleSaved) {
                      //   final latestNews = _getLatestSavedNews();
                      //   if (latestNews != null) {
                      //     print('XOÁ thành công');
                      //     await _removeLatestNews();
                      //     _showSnackBar('Đã xoá tin tức khỏi danh sách');
                      //   }
                      // } else {
                      //   // Code để lưu tin tức
                      //   // Tin tức chưa được lưu, lưu nó

                      //   print('lưu thành công');
                      //   await SaveArticle().saveArticle(userId, articleData);
                      //   _showSnackBar('Đã lưu tin tức vào danh sách');
                      // }