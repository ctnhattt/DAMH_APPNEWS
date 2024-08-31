import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:itnew/Models/FontChange.dart';
import 'package:itnew/Models/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:itnew/Views/TrangChiTiet.dart';

class TimKiem extends StatefulWidget {
  const TimKiem({super.key});

  @override
  State<TimKiem> createState() => _TimKiemState();
}

class _TimKiemState extends State<TimKiem> {
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> filteredNews = [];

  final Xml2Json xml2json = Xml2Json();
  List NewsTechnology = [];
  List NewsBusiness = [];
  List NewsScience = [];
  List NewsSports = [];
  Future NewsTechnologyFeed() async {
    final url = Uri.parse('https://rss.app/feeds/vwYAjqZmpoZ1YdYA.xml');
    final response = await http.get(url);
    xml2json.parse(response.body.toString());
    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);
    NewsTechnology = data['rss']['channel']['item'];
    print(NewsTechnology);
  }

  Future NewsBusinessFeed() async {
    final url = Uri.parse('https://rss.app/feeds/6sN4b8UkfYtS8cz5.xml');
    final response = await http.get(url);
    xml2json.parse(response.body.toString());
    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);
    NewsBusiness = data['rss']['channel']['item'];
    print(NewsBusiness);
  }

  Future NewsScienceFeed() async {
    final url = Uri.parse('https://rss.app/feeds/N6pCtoQ6aBihTQr1.xml');
    final response = await http.get(url);
    xml2json.parse(response.body.toString());
    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);
    NewsScience = data['rss']['channel']['item'];
    print(NewsScience);
  }

  Future NewsSportsFeed() async {
    final url = Uri.parse('https://rss.app/feeds/lelwgvNNExQTQeZw.xml');
    final response = await http.get(url);
    xml2json.parse(response.body.toString());
    var jsondata = xml2json.toGData();
    var data = json.decode(jsondata);
    NewsSports = data['rss']['channel']['item'];
    print(NewsSports);
  }

  void filterNews(String query) {
    setState(() {
      filteredNews = [
        ...NewsTechnology.where((article) => (article['title']['__cdata'] ?? '')
            .toLowerCase()
            .contains(query.toLowerCase())),
        ...NewsBusiness.where((article) => (article['title']['__cdata'] ?? '')
            .toLowerCase()
            .contains(query.toLowerCase())),
        ...NewsScience.where((article) => (article['title']['__cdata'] ?? '')
            .toLowerCase()
            .contains(query.toLowerCase())),
        ...NewsSports.where((article) => (article['title']['__cdata'] ?? '')
            .toLowerCase()
            .contains(query.toLowerCase())),
      ];
    });
    print(filteredNews); // In giá trị để kiểm tra
  }

  @override
  void initState() {
    super.initState();
    NewsTechnologyFeed();
    NewsBusinessFeed();
    NewsScienceFeed();
    NewsSportsFeed();
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
        // Color textColor = themeProvider.isDarkMode
        //     ? Colors.white
        //     : const Color.fromARGB(255, 24, 24, 24);
        return Scaffold(
          backgroundColor: themeProvider.isDarkMode
              ? const Color.fromARGB(255, 24, 24, 24)
              : Colors.white,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(222, 0, 183, 255),
            leading: const Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 40,
                )
              ],
            ),
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ? const Color.fromARGB(255, 24, 24, 24)
                    : Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        filterNews(
                            query); // Đảm bảo gọi hàm filterNews khi có thay đổi trên TextField
                      },
                      style: TextStyle(
                        fontFamily: fontProvider.selectedFont == 'Inter'
                            ? 'Inter'
                            : 'Kalam',
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : const Color.fromARGB(255, 24, 24, 24),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(
                            fontFamily: fontProvider.selectedFont == 'Inter'
                                ? 'Inter'
                                : 'Kalam',
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: Icon(
                        Icons.clear,
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ))
                ],
              ),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                        fontFamily: fontProvider.selectedFont == 'Inter'
                            ? 'Inter'
                            : 'Kalam',
                        color: Colors.black,
                        fontSize: 20),
                  ))
            ],
          ),
          body: ListView.builder(
            itemCount: filteredNews.length,
            itemBuilder: (context, index) {
              return Card(
                color: themeProvider.isDarkMode
                    ? Color.fromARGB(255, 63, 62, 62)
                    : Color.fromARGB(255, 236, 234, 234),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrangChiTiet(
                          title: filteredNews[index]['title']['__cdata'],
                          imagedata:
                              filteredNews[index]['media\$content'] != null &&
                                      filteredNews[index]['media\$content']
                                              ['url'] !=
                                          null
                                  ? filteredNews[index]['media\$content']['url']
                                  : null,
                          description: filteredNews[index]['description'] !=
                                      null &&
                                  filteredNews[index]['description']
                                          ['__cdata'] !=
                                      null
                              ? filteredNews[index]['description']['__cdata']
                              : null,
                          date: filteredNews[index]['pubDate'],
                          link: filteredNews[index]['link'],
                        ),
                      ),
                    );
                  },
                  leading: filteredNews[index]['media\$content'] != null &&
                          filteredNews[index]['media\$content']['url'] != null
                      ? Image.network(
                          filteredNews[index]['media\$content']['url'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey), // Placeholder khi không có ảnh
                  title: Text(
                    filteredNews[index]['link'].toString().substring(
                        13,
                        filteredNews[index]['link']
                            .toString()
                            .indexOf('/', 13)),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: fontProvider.selectedFont == 'Inter'
                          ? 'Inter'
                          : 'Kalam',
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : const Color.fromARGB(255, 24, 24, 24),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        filteredNews[index]['pubDate']
                            .toString()
                            .substring(5, 30),
                        style: TextStyle(
                          fontFamily: fontProvider.selectedFont == 'Inter'
                              ? 'Inter'
                              : 'Kalam',
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : const Color.fromARGB(255, 24, 24, 24),
                        ),
                      ),
                      Text(
                        filteredNews[index]['title']['__cdata'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: fontProvider.selectedFont == 'Inter'
                              ? 'Inter'
                              : 'Kalam',
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : const Color.fromARGB(255, 24, 24, 24),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
