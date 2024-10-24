import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:snapmug_for_admins/user_data.dart';
import 'HomePage.dart';
import 'SignUp.dart'; // Import your HomePage class

Color yellowColor = const Color(0xffFBD700);

class SignInActivity extends StatefulWidget {
  const SignInActivity({super.key});

  @override
  _SignInActivityState createState() => _SignInActivityState();
}

class _SignInActivityState extends State<SignInActivity> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '534586490308-fpccq491a869l65lk4aq2kpf6gfrm763.apps.googleusercontent.com', // Specify your web client ID for web platform
  );
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String titleUUID = '';

  final TextEditingController _emailController =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: '12341234');
  bool termsAccepted = false;
  @override
  void initState() {
    _signInWithEmailAndPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        decoration: const BoxDecoration(
            color: Colors.black,
            // image: DecorationImage(
            //     image: AssetImage('assets/background.png'), fit: BoxFit.cover)
        ),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              Image.asset(
                width: GetPlatform.isWeb
                    ? MediaQuery.of(context).size.width / 4
                    : MediaQuery.of(context).size.width,
                height: 250,
                'assets/logo.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Container(
                width: GetPlatform.isWeb ? Get.width / 2 : Get.width,
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: yellowColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    appTextField(
                        context, 'Email', 'Enter email', _emailController,
                        isLogin: true),
                    appTextField(context, 'Password', 'Enter password',
                        _passwordController,
                        isLogin: true),
                    const SizedBox(height: 20),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                            backgroundColor: yellowColor,
                          ))
                        : SizedBox(
                            height: 35,
                            child: ElevatedButton(
                              onPressed: _signInWithEmailAndPassword,
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(color: yellowColor),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.transparent,
                                // elevation: 20,
                                minimumSize: const Size(100, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              // const SizedBox(height: 20),
              // SizedBox(
              //   width: GetPlatform.isWeb ? Get.width / 2 : Get.width,
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       // Handle button press
              //       final GoogleSignInAccount? googleUser =
              //           await _googleSignIn.signIn();
              //       if (googleUser != null) {
              //         final GoogleSignInAuthentication googleAuth =
              //             await googleUser.authentication;
              //         final AuthCredential credential =
              //             GoogleAuthProvider.credential(
              //           accessToken: googleAuth.accessToken,
              //           idToken: googleAuth.idToken,
              //         );
              //         final UserCredential result =
              //             await _auth.signInWithCredential(credential);
              //         final User? user = result.user;
              //         if (user != null) {
              //           // User is signed in, navigate to the home page
              //           // Store user's email and name in Firebase Realtime Database
              //           // _storeUserDetails(user.email!, user.displayName ?? '');
              //           Navigator.pushReplacement(
              //             context,
              //             MaterialPageRoute(builder: (context) => MyHomePage()),
              //           );
              //         }
              //       }
              //     },
              //     style: ElevatedButton.styleFrom(
              //       foregroundColor: Colors.black,
              //       backgroundColor: yellowColor,
              //       elevation: 20,
              //       minimumSize: const Size(100, 50), //////// HERE
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(25),
              //       ),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.only(right: 0),
              //           child: Image.asset(
              //             'assets/ic_google.png',
              //             width: 25,
              //             height: 25,
              //           ),
              //         ),
              //         const Expanded(
              //           child: Text(
              //             'Continue With Google',
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 16,
              //             ),
              //             textAlign: TextAlign.center, // Center the text
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  bool isLoading = false;
  void _signInWithEmailAndPassword() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Email and password is required',
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        final User? user = _auth.currentUser;
        final String? uid = user?.uid;
        final database = FirebaseDatabase.instance;
        final reference = database.ref('AllArtists').child(uid!);
        final snapshot = await reference.get();
        if (snapshot.exists) {
          final userData = snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            UserProfileData().setProfileData = userData;
            profileImageURL = userData['profilePicture'] ??
                'https://firebasestorage.googleapis.com/v0/b/snapmugflutter.appspot.com/o/users%2F5zZHTX35lwTKQWoVFWrfMCPjxmS2?alt=media&token=c8cb5499-f89a-481b-b4eb-06dd42570bae';
          });
          print('User Data: $userData');
        } else {
          final ref = _database.ref('AllArtists').child(uid);
          var data={
            'email': _emailController.text.trim(),
            'userId': uid,
            'name': '',
            'userName': '',
            'password': _passwordController.text.trim(),
            'country': '',
            'mobileNumber': '',
            'socialSS':['abc'],
            'instagram': '',
            'facebook': '',
            'distributerName': '',
            'recordLabel': '',
            'isRejected': false,
            'isVerified': false,
            'tikTok': '',
            'youTube': '',
            'profilePicture': '',
          };
          ref.set(data);
          print('No data available for this user.');
        }
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }





    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: e.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      debugPrint('this is firebase exception ${e.message}');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential result =
            await _auth.signInWithCredential(credential);
        final User? user = result.user;
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }
}
