import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snapmug_for_admins/EditProfilePage.dart';
import 'package:snapmug_for_admins/pages/FinanceScreen.dart';
import 'package:snapmug_for_admins/pages/VerificationScreen.dart';
import 'package:snapmug_for_admins/pages/artists.dart';
import 'package:snapmug_for_admins/pages/MusicHomeScreen.dart';
import 'package:snapmug_for_admins/pages/home.dart';
import 'package:snapmug_for_admins/pages/notification.dart';
import 'package:snapmug_for_admins/pages/promotion.dart';
import 'package:snapmug_for_admins/pages/upload_music.dart';
import 'package:snapmug_for_admins/pages/all_users.dart';
import 'package:snapmug_for_admins/pages/verification_widget.dart';
import 'package:snapmug_for_admins/user_data.dart';
import 'SignIn.dart';
import 'edit_specific_profile.dart';
import 'globals.dart' as globals;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool isLoggedin = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

//m y music with config
//promotion - my musci with promotion option
//notification
  String profileImageURL =
      'https://firebasestorage.googleapis.com/v0/b/snapmugflutter.appspot.com/o/users%2F5zZHTX35lwTKQWoVFWrfMCPjxmS2?alt=media&token=c8cb5499-f89a-481b-b4eb-06dd42570bae';

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

//upload music
  static final List<Widget> _widgetOptions = <Widget>[
    const MyMusicBottom(),
    const AllArtists(),
    const AllUsers(),
    const PromotionBottom(),
    const NotificationScreen(),
    const FinanceScreen(),
    const VerificationScreen(),
    const UploadMusicScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> fetchUserDetails() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final String uid = user.uid;
      print('fetching user data $uid');
      final database = FirebaseDatabase.instance;
      final reference = database.ref('AllArtists').child(uid);
      final snapshot = await reference.get();
      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          UserProfileData().setProfileData = userData;
          profileImageURL = userData['profilePicture'] ??
              'https://firebasestorage.googleapis.com/v0/b/snapmugflutter.appspot.com/o/users%2F5zZHTX35lwTKQWoVFWrfMCPjxmS2?alt=media&token=c8cb5499-f89a-481b-b4eb-06dd42570bae';
          globals.profileImageURL = profileImageURL;
        });
        print('User Data: $userData');
      } else {
        print('No data available for this user.');
      }
    } else {
      print('User is not signed in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141118),
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5), // Add 10 pixels of space
          child: Image.asset('assets/logo.png'),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF141118),
        height: 86,
        child: Stack(
          children: [
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          // sets the background color of the `BottomNavigationBar`
                          canvasColor: yellowColor,
                          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                          primaryColor: yellowColor,
                          textTheme: Theme.of(context).textTheme.copyWith(
                              bodySmall: new TextStyle(color: yellowColor))),
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        selectedFontSize: 0.0,
                        unselectedFontSize: 0.0,
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Container(
                              // padding: EdgeInsets.all(1),
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: _selectedIndex == 0
                                      ? Colors.black26
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey)),
                              child: Image.asset(
                                'assets/noun-menu-4748399.png',
                                width: 44,
                                height: 44,
                                color: Colors.black,
                              ),
                            ),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: _selectedIndex == 1
                                        ? Colors.black26
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)),
                                child: Image.asset(
                                  'assets/noun-musician-750606.png',
                                  width: 34,
                                  height: 34,
                                  color: Colors.black,
                                )),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: _selectedIndex == 2
                                        ? Colors.black26
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)),
                                child: Image.asset(
                                  'assets/noun-users-6329590.png',
                                  width: 34,
                                  height: 34,
                                  color: Colors.black,
                                )),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: _selectedIndex == 3
                                        ? Colors.black26
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)),
                                child: Image.asset(
                                  'assets/noun-promotion-6769667.png',
                                  width: 44,
                                  height: 44,
                                  color: Colors.black,
                                )),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: _selectedIndex == 4
                                        ? Colors.black26
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)),
                                child: Image.asset(
                                  'assets/noun-notification-bell-6486567.png',
                                  width: 34,
                                  height: 34,
                                  color: Colors.black,
                                )),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Container(
                                height: 40,
                                width: 40,
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: _selectedIndex == 5
                                        ? Colors.black26
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)),
                                child: Image.asset(
                                  'assets/noun-withdraw-6556064.png',
                                  width: 34,
                                  height: 34,
                                  color: Colors.black,
                                )),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Stack(
                              children: [
                                Container(
                                    height: 40,
                                    width: 40,
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: _selectedIndex == 6
                                            ? Colors.black26
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.grey)),
                                    child: Image.asset(
                                      'assets/noun-musician-750606.png',
                                      width: 34,
                                      height: 34,
                                      color: Colors.black,
                                    )),
                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: Image.asset(
                                    'assets/approval.png',
                                    height: 15,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Container(
                              height: 40,
                              width: 40,
                              // padding: EdgeInsets.all(3),
                              // margin: EdgeInsets.all(3),
                              // decoration: BoxDecoration(
                              //     color: _selectedIndex == 7
                              //         ? Colors.black26
                              //         : Colors.transparent,
                              //     borderRadius: BorderRadius.circular(5),
                              //     border: Border.all(color: Colors.grey)),
                              // child: Image.asset(
                              //   'assets/noun-upload-6840889.png',
                              //   width: 34,
                              //   height: 34,
                              //   color: Colors.black,
                              // )
                            ),
                            label: '',
                          ),
                        ],
                        currentIndex: _selectedIndex,
                        selectedItemColor: Colors.blue,
                        onTap: _onItemTapped,
                      ),
                    ),
                  ),
                )),
            Positioned(
              right: 20,
              bottom: 1,
              child: GestureDetector(
                onTap: () {
                  _onItemTapped(7);
                },
                child: Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                      color: yellowColor,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2))
                      ],
                      borderRadius: BorderRadius.circular(100)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        backgroundColor: _selectedIndex == 7
                            ? Colors.black26
                            : Colors.transparent,
                        child: Image.asset(
                          'assets/noun-upload-6840889.png',
                          color: Colors.black,
                        )),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
