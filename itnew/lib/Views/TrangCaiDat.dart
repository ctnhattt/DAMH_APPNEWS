import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itnew/Models/FontChange.dart';
import 'package:itnew/Views/BottomNavi.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Models/ThemeProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaiDat extends StatefulWidget {
  const CaiDat({super.key});

  @override
  State<CaiDat> createState() => _CaiDatState();
}

class _CaiDatState extends State<CaiDat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isUserLoggedIn = false;
  String userName = '';
  //late User? users = _auth.currentUser; // xác nhận từng user

  bool light = false;

  String status = 'Dark Theme';

  @override
  void initState() {
    super.initState();
    // Khởi tạo trạng thái đăng nhập từ SharedPreferences khi widget được tạo ra
    _loadUserLoginStatus();
  }

  // Hàm để lấy trạng thái đăng nhập từ SharedPreferences
  void _loadUserLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String savedUserName = prefs.getString('userName') ?? '';

    setState(() {
      isUserLoggedIn = isLoggedIn;
      userName = savedUserName;
    });
  }

  // Hàm để lưu trạng thái đăng nhập vào SharedPreferences
  void _saveUserLoginStatus(bool isLoggedIn, String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
    prefs.setString('userName', userName);
  }

  // Hàm để lưu trạng thái đăng xuất vào SharedPreferences
  void _saveUserLogoutStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('userName');
  }

  // Hàm để xóa tài khoản trên firebase
  Future<void> _deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Warning!'),
              content: Text('Are you sure you want to delete the account?'),
              actions: <Widget>[
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng hộp thoại
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () async {
                    try {
                      await user.delete();

                      await _auth.signOut();

                      setState(() {
                        // userName = '';
                        isUserLoggedIn = false;
                      });
                      _saveUserLogoutStatus();
                    } catch (error) {
                      print(
                          'Error when signing in/signing out with Google: $error');
                    }
                    Navigator.of(context)
                        .pop(); // Đóng hộp thoại sau khi xử lý xong
                  },
                ),
              ],
            );
          },
        );
      } else {
        _showLoginAlertDialog();
      }
    } catch (error) {
      print('Error deleting account: $error');
    }
  }

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isActive);
                Navigator.pushNamed(context, '/');
              },
            ),
            backgroundColor: const Color.fromARGB(222, 0, 183, 255),
            title: Text(
              'Setting',
              style: TextStyle(
                  fontFamily:
                      fontProvider.selectedFont == 'Inter' ? 'Inter' : 'Kalam',
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
            centerTitle: true,
          ),
          bottomNavigationBar: BottomNavi(index: 2),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      padding: const EdgeInsets.all(10),
                      child: ClipOval(
                        child: Icon(
                          Icons.account_circle,
                          size: 130,
                          color: textColor,
                        ),
                      ),
                    ),
                    isUserLoggedIn
                        ? Text(
                            userName,
                            style: TextStyle(
                              fontFamily: fontProvider.selectedFont == 'Inter'
                                  ? 'Inter'
                                  : 'Kalam',
                              color: textColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              try {
                                // Đăng xuất tài khoản Google hiện tại (nếu có)
                                await _googleSignIn.signOut();

                                // Đăng nhập với tài khoản Google mới
                                GoogleSignInAccount? googleUser =
                                    await _googleSignIn.signIn();
                                if (googleUser == null) {
                                  // Người dùng hủy đăng nhập hoặc không chọn tài khoản
                                  return;
                                }

                                GoogleSignInAuthentication googleAuth =
                                    await googleUser.authentication;
                                AuthCredential credential =
                                    GoogleAuthProvider.credential(
                                  accessToken: googleAuth.accessToken,
                                  idToken: googleAuth.idToken,
                                );

                                UserCredential authResult = await _auth
                                    .signInWithCredential(credential);
                                User? user = authResult.user;

                                if (user != null) {
                                  setState(() {
                                    userName = user.displayName ?? '';
                                    isUserLoggedIn = true;
                                  });
                                  _saveUserLoginStatus(true, userName);
                                }
                              } catch (error) {
                                print('Error signing in with Google: $error');
                              }
                              Navigator.of(context).pop(); // Đóng hộp thoại
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: textColor, // Màu của viền
                              ),
                            ),
                            child: Text(
                              'Login', // --------------------------------------------------- ĐĂNG NHẬP ----------------------------------
                              style: TextStyle(
                                  fontFamily:
                                      fontProvider.selectedFont == 'Inter'
                                          ? 'Inter'
                                          : 'Kalam',
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        User? user = _auth.currentUser;
                        if (user != null) {
                          Navigator.popUntil(
                              context, (route) => route.isCurrent);
                          Navigator.pushNamed(context, '/daluu');
                        } else {
                          _showLoginAlertDialog();
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons
                                .bookmark, // ------------------------------------------------- LƯU TIN TỨC --------------------------------
                            color: Colors.green,
                            size: 50,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Saved',
                            style: TextStyle(
                                fontFamily: fontProvider.selectedFont == 'Inter'
                                    ? 'Inter'
                                    : 'Kalam',
                                fontSize: 25,
                                color: textColor),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // User? user = _auth.currentUser;
                        // if (user != null) {
                        Navigator.popUntil(context, (route) => route.isCurrent);
                        Navigator.pushNamed(context, '/lichsu');
                        // } else {
                        //   _showLoginAlertDialog();
                        // }
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons
                                .access_time_filled, // ---------------------------------------- LỊCH SỬ --------------------------------
                            color: Colors.green,
                            size: 50,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'History',
                            style: TextStyle(
                                fontFamily: fontProvider.selectedFont == 'Inter'
                                    ? 'Inter'
                                    : 'Kalam',
                                fontSize: 25,
                                color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  thickness: 2, // ------------------------- ĐỘ DÀY
                  color: Colors.grey, // ----------------- MÀU SẮC
                  indent: 1, // ---------------------------- LÙI SANG TRÁI
                  endIndent: 1, // ------------------------- LÙI SANG PHẢI
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 25,
                      height: 70,
                    ),
                    Text(
                      'Setting',
                      style: TextStyle(
                          fontFamily: fontProvider.selectedFont == 'Inter'
                              ? 'Inter'
                              : 'Kalam',
                          fontSize: 30,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 25,
                      height: 70,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.popUntil(
                              context, (route) => route.isCurrent);
                          Navigator.pushNamed(context, '/cochuvafontchu');
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.format_color_text_outlined,
                              size: 40,
                              color: textColor,
                            ),
                            Text(
                              'Font & Size Text',
                              style: TextStyle(
                                  fontFamily:
                                      fontProvider.selectedFont == 'Inter'
                                          ? 'Inter'
                                          : 'Kalam',
                                  fontSize: 25,
                                  color: textColor),
                            ),
                          ],
                        ))
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 25,
                      height: 70,
                    ),
                    Text(
                      status,
                      style: TextStyle(
                          fontFamily: fontProvider.selectedFont == 'Inter'
                              ? 'Inter'
                              : 'Kalam',
                          fontSize: 25,
                          color: textColor),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Switch(
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.green,
                        // value: themeProvider.isDarkMode,
                        value: themeProvider.isDarkMode,
                        onChanged: (value) => themeProvider.changeTheme())
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 25,
                      height: 70,
                    ),
                    GestureDetector(
                      onTap: () {
                        _deleteAccount();
                      },
                      child: Row(
                        children: [
                          Text(
                            'Delete account',
                            style: TextStyle(
                                fontFamily: fontProvider.selectedFont == 'Inter'
                                    ? 'Inter'
                                    : 'Kalam',
                                fontSize: 25,
                                color: textColor),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          if (isUserLoggedIn) {
                            // Hiển thị hộp thoại xác nhận đăng xuất
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Log Out'),
                                  content:
                                      Text('Are you sure you want to log out?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Đóng hộp thoại
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Yes'),
                                      onPressed: () async {
                                        try {
                                          // Xử lý đăng xuất ở đây
                                          await _auth.signOut();
                                          setState(() {
                                            isUserLoggedIn = false;
                                          });
                                          _saveUserLogoutStatus();
                                        } catch (error) {
                                          print(
                                              'Error when signing in/signing out with Google: $error');
                                        }
                                        Navigator.of(context)
                                            .pop(); // Đóng hộp thoại
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            _showLoginAlertDialog();
                          }
                        } catch (error) {
                          print(
                              'Error when signing in/signing out with Google: $error');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.black, // Màu của viền
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            fontFamily: fontProvider.selectedFont == 'Inter'
                                ? 'Inter'
                                : 'Kalam',
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
