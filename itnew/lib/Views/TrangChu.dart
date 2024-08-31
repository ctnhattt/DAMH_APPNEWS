import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:itnew/Models/FontChange.dart';
import 'package:itnew/Models/SaveArticle.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:itnew/Views/BottomNavi.dart';
import 'package:itnew/Views/TimKiem.dart';
import 'package:itnew/Views/TrangChiTiet.dart';
import 'package:itnew/Views/TrangThongBao.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:provider/provider.dart';
import '../Models/ThemeProvider.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({super.key, required this.title});
  final String title;
  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu>
    with SingleTickerProviderStateMixin {
  // minxin cung cấp đối tượng đối tượng TickerProvider
// duy nhất và có thể sử dụng cho 1 Ticker (đối tượng thời gian) -> animation
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

  TabController? _tabController;
  //late User? user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late firebase_auth.User? firebaseUser;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    //user = FirebaseAuth.instance.currentUser;

    firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
  }

  // void saveDarkModeToPreferences(bool isDarkMode) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isDarkMode', isDarkMode);
  // }

  // Future<bool> getDarkModeFromPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? isDarkMode = prefs.getBool('isDarkMode');
  //   return isDarkMode ??
  //       false; // Trả về false nếu không có giá trị trong SharedPreferences
  // }

  @override
  Widget build(BuildContext context) {
    NewsTechnologyFeed();
    NewsBusinessFeed();
    NewsScienceFeed();
    NewsSportsFeed();

    // var themeProvider = Provider.of<ThemeProvider>(context);

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
          // ----------------------------------------------- LOGO -----------------------------------------------
          backgroundColor:
              themeProvider.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(222, 0, 183, 255),
            title: Text(
              'ITFEEDS',
              style: TextStyle(
                fontFamily:
                    fontProvider.selectedFont == 'Inter' ? 'Inter' : 'Kalam',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TimKiem(),
                        ));
                  },
                  icon: const Icon(
                    Icons
                        .search, // ------------------------------------- TÌM KIẾM ------------------------
                    color: Colors.black,
                    size: 30.0,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TrangThongBao(
                                title: '',
                              )),
                    );
                  },
                  icon: const Icon(
                    Icons
                        .notifications_outlined, // ------------------------------------- THÔNG BÁO ------------------------
                    color: Colors.black,
                    size: 30.0,
                  )),
            ],
            iconTheme: const IconThemeData(color: Colors.black),
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(40), // kích thước tối ưu cho TabBar
              child: Container(
                color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                child: TabBar(
                  isScrollable: false,
                  controller: _tabController,
                  labelColor: Colors.blue,

                  indicatorColor:
                      themeProvider.isDarkMode ? Colors.blue : Colors.black,

                  unselectedLabelColor:
                      themeProvider.isDarkMode ? Colors.white : Colors.black,

                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 1),

                  // unfocus

                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 1),
                          Text(
                            'Technology',
                            style: TextStyle(
                              fontFamily: fontProvider.selectedFont == 'Inter'
                                  ? 'Inter'
                                  : 'Kalam',
                            ),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 1),
                          Text(
                            'Business',
                            style: TextStyle(
                              fontFamily: fontProvider.selectedFont == 'Inter'
                                  ? 'Inter'
                                  : 'Kalam',
                            ),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 1),
                          Text(
                            'Science',
                            style: TextStyle(
                              fontFamily: fontProvider.selectedFont == 'Inter'
                                  ? 'Inter'
                                  : 'Kalam',
                            ),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 1),
                          Text(
                            'Sports',
                            style: TextStyle(
                              fontFamily: fontProvider.selectedFont == 'Inter'
                                  ? 'Inter'
                                  : 'Kalam',
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ----------------------------------------------- DANH MỤC -------------------------------------------
          drawer: Drawer(
              child: Container(
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode ? Colors.black : Colors.white,
              border: Border.all(color: Colors.grey),
            ),
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(222, 0, 183, 255)),
                    child: Image.asset('assets/img/itfeeds.png')),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _tabController
                        ?.animateTo(0); // hiệu ứng chuyển đến tab "Mới nhất"
                  },
                  title: Text(
                    'Technology',
                    style: TextStyle(
                        fontFamily: fontProvider.selectedFont == 'Inter'
                            ? 'Inter'
                            : 'Kalam',
                        color: textColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _tabController
                        ?.animateTo(1); // hiệu ứng chuyển đến tab "Xu hướng"
                  },
                  title: Text(
                    'Business',
                    style: TextStyle(
                        fontFamily: fontProvider.selectedFont == 'Inter'
                            ? 'Inter'
                            : 'Kalam',
                        color: textColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _tabController
                        ?.animateTo(2); // hiệu ứng chuyển đến tab "Xu hướng"
                  },
                  title: Text(
                    'Science',
                    style: TextStyle(
                        fontFamily: fontProvider.selectedFont == 'Inter'
                            ? 'Inter'
                            : 'Kalam',
                        color: textColor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _tabController
                        ?.animateTo(3); // hiệu ứng chuyển đến tab "Xu hướng"
                  },
                  title: Text(
                    'Sports',
                    style: TextStyle(
                        fontFamily: fontProvider.selectedFont == 'Inter'
                            ? 'Inter'
                            : 'Kalam',
                        color: textColor),
                  ),
                ),
              ],
            ),
          )),
          // -------------------------------------------- FOOTER -----------------------------------------------------------------------------
          bottomNavigationBar: BottomNavi(index: 0),

          // -------------------------------------------- BODY --------TAB BAR VIEW ----------------------------------------------------------
          body: TabBarView(controller: _tabController, children: [
            FutureBuilder(
                future: NewsTechnologyFeed(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: NewsTechnology.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                        color: themeProvider.isDarkMode
                                            ? const Color.fromARGB(
                                                255, 57, 55, 55)
                                            : const Color.fromARGB(
                                                255, 246, 242, 242),
                                        borderRadius: BorderRadius.circular(
                                            8), // Bo tròn góc
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          _firestore.collection('noUser').add({
                                            'title': NewsTechnology[index]
                                                ['title']['__cdata'],
                                            'imagedata': NewsTechnology[index][
                                                            'media\$content'] !=
                                                        null &&
                                                    NewsTechnology[index][
                                                                'media\$content']
                                                            ['url'] !=
                                                        null
                                                ? NewsTechnology[index]
                                                    ['media\$content']['url']
                                                : null,
                                            'description': NewsTechnology[index]
                                                            ['description'] !=
                                                        null &&
                                                    NewsTechnology[index]
                                                                ['description']
                                                            ['__cdata'] !=
                                                        null
                                                ? NewsTechnology[index]
                                                    ['description']['__cdata']
                                                : null,
                                            'date': NewsTechnology[index]
                                                ['pubDate'],
                                            'link': NewsTechnology[index]
                                                ['link'],
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return TrangChiTiet(
                                                  title: NewsTechnology[index]
                                                      ['title']['__cdata'],
                                                  imagedata: NewsTechnology[
                                                                      index][
                                                                  'media\$content'] !=
                                                              null &&
                                                          NewsTechnology[index][
                                                                      'media\$content']
                                                                  ['url'] !=
                                                              null
                                                      ? NewsTechnology[index]
                                                              ['media\$content']
                                                          ['url']
                                                      : null,
                                                  description: NewsTechnology[
                                                                      index][
                                                                  'description'] !=
                                                              null &&
                                                          NewsTechnology[index][
                                                                      'description']
                                                                  ['__cdata'] !=
                                                              null
                                                      ? NewsTechnology[index]
                                                              ['description']
                                                          ['__cdata']
                                                      : null,
                                                  date: NewsTechnology[index] !=
                                                              null &&
                                                          NewsTechnology[index]
                                                                  ['pubDate'] !=
                                                              null
                                                      ? NewsTechnology[index]
                                                          ['pubDate']
                                                      : null,
                                                  link: NewsTechnology[index] !=
                                                              null &&
                                                          NewsTechnology[index]
                                                                  ['link'] !=
                                                              null
                                                      ? NewsTechnology[index]
                                                          ['link']
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
                                            SizedBox(
                                              width: double.infinity,
                                              child: NewsTechnology[index]
                                                          ['media\$content'] !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      imageUrl: NewsTechnology[
                                                                  index]
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
                                                      ), // Hiển thị indicator khi đang tải
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(), // Hiển thị icon lỗi nếu không tải được
                                                    )
                                                  : null, // Nếu không tìm thấy mục media\$content, không hiển thị gì lên giao diện
                                            ),
                                            const SizedBox(width: 30),
                                            Text(
                                              NewsTechnology[index]['link']
                                                  .toString()
                                                  .substring(
                                                      13,
                                                      NewsTechnology[index]
                                                              ['link']
                                                          .toString()
                                                          .indexOf('/', 13)),
                                              style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: textColor),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              NewsTechnology[index]['pubDate']
                                                  .toString()
                                                  .substring(5, 30),
                                              style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                  color: textColor),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                NewsTechnology[index]['title']
                                                    ['__cdata'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                  fontSize: fontProvider
                                                      .fontSize
                                                      .toDouble(),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
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
            FutureBuilder(
                future: NewsBusinessFeed(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: NewsBusiness.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                        color: themeProvider.isDarkMode
                                            ? const Color.fromARGB(
                                                255, 57, 55, 55)
                                            : const Color.fromARGB(
                                                255, 246, 242, 242),
                                        borderRadius: BorderRadius.circular(
                                            8), // Bo tròn góc
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          _firestore.collection('noUser').add({
                                            'title': NewsBusiness[index]
                                                ['title']['__cdata'],
                                            'imagedata': NewsBusiness[index][
                                                            'media\$content'] !=
                                                        null &&
                                                    NewsBusiness[index][
                                                                'media\$content']
                                                            ['url'] !=
                                                        null
                                                ? NewsBusiness[index]
                                                    ['media\$content']['url']
                                                : null,
                                            'description': NewsBusiness[index]
                                                            ['description'] !=
                                                        null &&
                                                    NewsBusiness[index]
                                                                ['description']
                                                            ['__cdata'] !=
                                                        null
                                                ? NewsBusiness[index]
                                                    ['description']['__cdata']
                                                : null,
                                            'date': NewsBusiness[index]
                                                ['pubDate'],
                                            'link': NewsBusiness[index]['link'],
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return TrangChiTiet(
                                                  title: NewsBusiness[index]
                                                      ['title']['__cdata'],
                                                  imagedata: NewsBusiness[index]
                                                                  [
                                                                  'media\$content'] !=
                                                              null &&
                                                          NewsBusiness[index][
                                                                      'media\$content']
                                                                  ['url'] !=
                                                              null
                                                      ? NewsBusiness[index]
                                                              ['media\$content']
                                                          ['url']
                                                      : null,
                                                  description: NewsBusiness[
                                                                      index][
                                                                  'description'] !=
                                                              null &&
                                                          NewsBusiness[index][
                                                                      'description']
                                                                  ['__cdata'] !=
                                                              null
                                                      ? NewsBusiness[index]
                                                              ['description']
                                                          ['__cdata']
                                                      : null,
                                                  date: NewsBusiness[index] !=
                                                              null &&
                                                          NewsBusiness[index]
                                                                  ['pubDate'] !=
                                                              null
                                                      ? NewsBusiness[index]
                                                          ['pubDate']
                                                      : null,
                                                  link: NewsBusiness[index] !=
                                                              null &&
                                                          NewsBusiness[index]
                                                                  ['link'] !=
                                                              null
                                                      ? NewsBusiness[index]
                                                          ['link']
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
                                            SizedBox(
                                              width: double.infinity,
                                              child: NewsBusiness[index]
                                                          ['media\$content'] !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      imageUrl: NewsBusiness[
                                                                  index]
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
                                                      ), // Hiển thị indicator khi đang tải
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(), // Hiển thị icon lỗi nếu không tải được
                                                    )
                                                  : null, // Nếu không tìm thấy mục media\$content, không hiển thị gì lên giao diện
                                            ),
                                            const SizedBox(width: 30),
                                            Text(
                                              NewsBusiness[index]['link']
                                                  .toString()
                                                  .substring(
                                                      13,
                                                      NewsBusiness[index]
                                                              ['link']
                                                          .toString()
                                                          .indexOf('/', 13)),
                                              style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: textColor),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              NewsBusiness[index]['pubDate']
                                                  .toString()
                                                  .substring(5, 30),
                                              style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                  color: textColor),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                NewsBusiness[index]['title']
                                                    ['__cdata'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                  fontSize: fontProvider
                                                      .fontSize
                                                      .toDouble(),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          ),
                        );
                }),
            FutureBuilder(
                future: NewsScienceFeed(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: NewsScience.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                        color: themeProvider.isDarkMode
                                            ? const Color.fromARGB(
                                                255, 57, 55, 55)
                                            : const Color.fromARGB(
                                                255, 246, 242, 242),
                                        borderRadius: BorderRadius.circular(
                                            8), // Bo tròn góc
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          _firestore.collection('noUser').add({
                                            'title': NewsScience[index]['title']
                                                ['__cdata'],
                                            'imagedata': NewsScience[index][
                                                            'media\$content'] !=
                                                        null &&
                                                    NewsScience[index][
                                                                'media\$content']
                                                            ['url'] !=
                                                        null
                                                ? NewsScience[index]
                                                    ['media\$content']['url']
                                                : null,
                                            'description': NewsScience[index]
                                                            ['description'] !=
                                                        null &&
                                                    NewsScience[index]
                                                                ['description']
                                                            ['__cdata'] !=
                                                        null
                                                ? NewsScience[index]
                                                    ['description']['__cdata']
                                                : null,
                                            'date': NewsScience[index]
                                                ['pubDate'],
                                            'link': NewsScience[index]['link'],
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return TrangChiTiet(
                                                  title: NewsScience[index]
                                                      ['title']['__cdata'],
                                                  imagedata: NewsScience[index][
                                                                  'media\$content'] !=
                                                              null &&
                                                          NewsScience[index][
                                                                      'media\$content']
                                                                  ['url'] !=
                                                              null
                                                      ? NewsScience[index]
                                                              ['media\$content']
                                                          ['url']
                                                      : null,
                                                  description: NewsScience[
                                                                      index][
                                                                  'description'] !=
                                                              null &&
                                                          NewsScience[index][
                                                                      'description']
                                                                  ['__cdata'] !=
                                                              null
                                                      ? NewsScience[index]
                                                              ['description']
                                                          ['__cdata']
                                                      : null,
                                                  date: NewsScience[index] !=
                                                              null &&
                                                          NewsScience[index]
                                                                  ['pubDate'] !=
                                                              null
                                                      ? NewsScience[index]
                                                          ['pubDate']
                                                      : null,
                                                  link: NewsScience[index] !=
                                                              null &&
                                                          NewsScience[index]
                                                                  ['link'] !=
                                                              null
                                                      ? NewsScience[index]
                                                          ['link']
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
                                            SizedBox(
                                              width: double.infinity,
                                              child: NewsScience[index]
                                                          ['media\$content'] !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      imageUrl: NewsScience[
                                                                  index]
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
                                                      ), // Hiển thị indicator khi đang tải
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(), // Hiển thị icon lỗi nếu không tải được
                                                    )
                                                  : null, // Nếu không tìm thấy mục media\$content, không hiển thị gì lên giao diện
                                            ),
                                            const SizedBox(width: 30),
                                            Text(
                                              NewsScience[index]['link']
                                                  .toString()
                                                  .substring(
                                                      13,
                                                      NewsScience[index]['link']
                                                          .toString()
                                                          .indexOf('/', 13)),
                                              style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: textColor),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              NewsScience[index]['pubDate']
                                                  .toString()
                                                  .substring(5, 30),
                                              style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                  color: textColor),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                NewsScience[index]['title']
                                                    ['__cdata'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                  fontSize: fontProvider
                                                      .fontSize
                                                      .toDouble(),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          ),
                        );
                }),
            FutureBuilder(
                future: NewsSportsFeed(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: NewsSports.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                        color: themeProvider.isDarkMode
                                            ? const Color.fromARGB(
                                                255, 57, 55, 55)
                                            : const Color.fromARGB(
                                                255, 246, 242, 242),
                                        borderRadius: BorderRadius.circular(
                                            8), // Bo tròn góc
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          _firestore.collection('noUser').add({
                                            'title': NewsSports[index]['title']
                                                ['__cdata'],
                                            'imagedata': NewsSports[index][
                                                            'media\$content'] !=
                                                        null &&
                                                    NewsSports[index][
                                                                'media\$content']
                                                            ['url'] !=
                                                        null
                                                ? NewsSports[index]
                                                    ['media\$content']['url']
                                                : null,
                                            'description': NewsSports[index]
                                                            ['description'] !=
                                                        null &&
                                                    NewsSports[index]
                                                                ['description']
                                                            ['__cdata'] !=
                                                        null
                                                ? NewsSports[index]
                                                    ['description']['__cdata']
                                                : null,
                                            'date': NewsSports[index]
                                                ['pubDate'],
                                            'link': NewsSports[index]['link'],
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                return TrangChiTiet(
                                                  title: NewsSports[index]
                                                      ['title']['__cdata'],
                                                  imagedata: NewsSports[index][
                                                                  'media\$content'] !=
                                                              null &&
                                                          NewsSports[index][
                                                                      'media\$content']
                                                                  ['url'] !=
                                                              null
                                                      ? NewsSports[index]
                                                              ['media\$content']
                                                          ['url']
                                                      : null,
                                                  description: NewsSports[index]
                                                                  [
                                                                  'description'] !=
                                                              null &&
                                                          NewsSports[index][
                                                                      'description']
                                                                  ['__cdata'] !=
                                                              null
                                                      ? NewsSports[index]
                                                              ['description']
                                                          ['__cdata']
                                                      : null,
                                                  date: NewsSports[index] !=
                                                              null &&
                                                          NewsSports[index]
                                                                  ['pubDate'] !=
                                                              null
                                                      ? NewsSports[index]
                                                          ['pubDate']
                                                      : null,
                                                  link: NewsSports[index] !=
                                                              null &&
                                                          NewsSports[index]
                                                                  ['link'] !=
                                                              null
                                                      ? NewsSports[index]
                                                          ['link']
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
                                            SizedBox(
                                              width: double.infinity,
                                              child: NewsSports[index]
                                                          ['media\$content'] !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      imageUrl: NewsSports[
                                                                  index]
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
                                                      ), // Hiển thị indicator khi đang tải
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(), // Hiển thị icon lỗi nếu không tải được
                                                    )
                                                  : null, // Nếu không tìm thấy mục media\$content, không hiển thị gì lên giao diện
                                            ),
                                            const SizedBox(width: 30),
                                            Text(
                                              NewsSports[index]['link']
                                                  .toString()
                                                  .substring(
                                                      13,
                                                      NewsSports[index]['link']
                                                          .toString()
                                                          .indexOf('/', 13)),
                                              style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: textColor),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              NewsSports[index]['pubDate']
                                                  .toString()
                                                  .substring(5, 30),
                                              style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                  color: textColor),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                NewsSports[index]['title']
                                                    ['__cdata'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontFamily: fontProvider
                                                              .selectedFont ==
                                                          'Inter'
                                                      ? 'Inter'
                                                      : 'Kalam',
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                  fontSize: fontProvider
                                                      .fontSize
                                                      .toDouble(),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
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
          ]),
        );
      }),
    );
    //);
  }
}
