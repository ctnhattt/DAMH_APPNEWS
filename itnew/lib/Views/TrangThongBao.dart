import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:itnew/Models/FontChange.dart';
import 'package:itnew/Views/TrangChiTiet.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xml2json/xml2json.dart';
import 'package:provider/provider.dart';
import '../Models/ThemeProvider.dart';

class TrangThongBao extends StatefulWidget {
  const TrangThongBao({super.key, required this.title});
  final String title;

  @override
  State<TrangThongBao> createState() => _TrangThongBaoState();
}

class _TrangThongBaoState extends State<TrangThongBao> {
  final Xml2Json xml2json = Xml2Json();
  List NewsTop = [];
  Future newsFeed() async {
    final url = Uri.parse('https://rss.app/feeds/JTkeXcKl11bcnj4L.xml');
    final response = await http.get(url);
    xml2json.parse(response.body.toString());
    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);
    if (data['rss'] != null &&
        data['rss']['channel'] != null &&
        data['rss']['channel']['item'] != null) {
      if (data['rss']['channel']['item'] is List) {
        NewsTop = data['rss']['channel']['item'];
        print(NewsTop);
      } else {
        print('Dữ liệu không hợp lệ');
      }
    } else {
      print('Cấu trúc dữ liệu không đúng');
    }
  }

  @override
  Widget build(BuildContext context) {
    newsFeed();

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
            title: Text(
              'New Feeds',
              style: TextStyle(
                  fontFamily:
                      fontProvider.selectedFont == 'Inter' ? 'Inter' : 'Kalam',
                  color: Colors.white),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: const Color.fromARGB(222, 0, 183, 255),
          ),
          body: FutureBuilder(
              future: newsFeed(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: NewsTop.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return TrangChiTiet(
                                                title: NewsTop[index]['title']
                                                    ['__cdata'],
                                                imagedata: NewsTop[index][
                                                                'media\$content'] !=
                                                            null &&
                                                        NewsTop[index][
                                                                    'media\$content']
                                                                ['url'] !=
                                                            null
                                                    ? NewsTop[index]
                                                            ['media\$content']
                                                        ['url']
                                                    : null,
                                                description: NewsTop[index][
                                                                'description'] !=
                                                            null &&
                                                        NewsTop[index][
                                                                    'description']
                                                                ['__cdata'] !=
                                                            null
                                                    ? NewsTop[index]
                                                            ['description']
                                                        ['__cdata']
                                                    : null,
                                                date: NewsTop[index] != null &&
                                                        NewsTop[index]
                                                                ['pubDate'] !=
                                                            null
                                                    ? NewsTop[index]['pubDate']
                                                    : null,
                                                link: NewsTop[index] != null &&
                                                        NewsTop[index]
                                                                ['link'] !=
                                                            null
                                                    ? NewsTop[index]['link']
                                                    : null,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              color: themeProvider.isDarkMode
                                                  ? Color.fromARGB(
                                                      255, 57, 55, 55)
                                                  : Color.fromARGB(
                                                      255,
                                                      246,
                                                      242,
                                                      242), // Chọn màu xám cho nền khung
                                              borderRadius: BorderRadius.circular(
                                                  10), // Bo tròn góc của khung
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (NewsTop[index]
                                                        ['media\$content'] !=
                                                    null)
                                                  SizedBox(
                                                    width:
                                                        80, // Điều chỉnh kích thước của hình ảnh tại đây
                                                    height: 80,

                                                    child: CachedNetworkImage(
                                                      imageUrl: NewsTop[index]
                                                              ['media\$content']
                                                          ['url'],
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child: SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Colors
                                                                        .blue),
                                                          ),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(),
                                                    ),
                                                  ),
                                                const SizedBox(
                                                    width:
                                                        5), // Tạo khoảng cách giữa hình ảnh và văn bản
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        NewsTop[index]['link']
                                                            .toString()
                                                            .substring(
                                                                13,
                                                                NewsTop[index]
                                                                        ['link']
                                                                    .toString()
                                                                    .indexOf(
                                                                        '/',
                                                                        13)),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                fontProvider.selectedFont ==
                                                                        'Inter'
                                                                    ? 'Inter'
                                                                    : 'Kalam',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10,
                                                            color: textColor),
                                                      ),
                                                      Text(
                                                        NewsTop[index]
                                                                ['pubDate']
                                                            .toString()
                                                            .substring(5, 30),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                fontProvider.selectedFont ==
                                                                        'Inter'
                                                                    ? 'Inter'
                                                                    : 'Kalam',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 9,
                                                            color: textColor),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 8,
                                                                bottom: 8),
                                                        child: Text(
                                                          NewsTop[index]
                                                                  ['title']
                                                              ['__cdata'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                fontProvider.selectedFont ==
                                                                        'Inter'
                                                                    ? 'Inter'
                                                                    : 'Kalam',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: textColor,
                                                            fontSize:
                                                                fontProvider
                                                                    .fontSize
                                                                    .toDouble(),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                          ],
                        ),
                      );
              }),
        );
      }),
    );
  }
}
