// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:uuid/uuid.dart';
// import 'HomePage.dart';
// import 'SignIn.dart'; // Import your HomePage class
//
// class SignUPActivity extends StatefulWidget {
//   @override
//   _SignUPActivityState createState() => _SignUPActivityState();
// }
//
// class _SignUPActivityState extends State<SignUPActivity> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId:
//         '534586490308-fpccq491a869l65lk4aq2kpf6gfrm763.apps.googleusercontent.com', // Specify your web client ID for web platform
//   );
//   final FirebaseDatabase _database = FirebaseDatabase.instance;
//   String titleUUID = '';
//
//   final TextEditingController userNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: Get.width,
//         height: Get.height,
//         decoration: const BoxDecoration(
//             color: Colors.black,
//             image: DecorationImage(
//                 image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: MediaQuery.of(context).size.height / 8),
//                 Image.asset(
//                   width: MediaQuery.of(context).size.width,
//                   height: 250,
//                   'assets/logo.png',
//                   fit: BoxFit.cover,
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   padding:
//                       const EdgeInsets.only(left: 15, right: 15, bottom: 15),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: yellowColor),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Column(
//                     children: [
//                       appTextField(context, 'User Name', 'User name',
//                           userNameController),
//                       appTextField(
//                           context, 'Email', 'Enter email', _emailController),
//                       appTextField(context, 'Password', 'Enter password',
//                           _passwordController),
//                       appTextField(context, 'Confirm Password',
//                           'Enter confirm password', _confirmPasswordController),
//                       const SizedBox(height: 20),
//                       isLoading
//                           ? Center(
//                               child: CircularProgressIndicator(
//                               backgroundColor: yellowColor,
//                             ))
//                           : SizedBox(
//                               height: 35,
//                               child: ElevatedButton(
//                                 onPressed: _signUpWithEmailAndPassword,
//                                 style: ElevatedButton.styleFrom(
//                                   side: BorderSide(color: yellowColor),
//                                   foregroundColor: Colors.white,
//                                   backgroundColor: Colors.transparent,
//                                   // elevation: 20,
//                                   minimumSize: const Size(100, 50),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(35),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   'Register',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     RichText(
//                         textAlign: TextAlign.left,
//                         text: TextSpan(
//                           style: const TextStyle(
//                               fontSize: 13,
//                               color: Colors.white), // Default text style
//                           children: <TextSpan>[
//                             const TextSpan(
//                                 text: 'Already have an account? ',
//                                 style: TextStyle(color: Colors.white)),
//                             TextSpan(
//                               text: 'Login',
//                               style: TextStyle(
//                                   color: yellowColor,
//                                   fontWeight: FontWeight.bold),
//                               recognizer: TapGestureRecognizer()
//                                 ..onTap = () {
//                                   Navigator.of(context).pop();
//                                 },
//                             ),
//                           ],
//                         )),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     // Handle button press
//                     final GoogleSignInAccount? googleUser =
//                         await _googleSignIn.signIn();
//                     if (googleUser != null) {
//                       final GoogleSignInAuthentication googleAuth =
//                           await googleUser.authentication;
//                       final AuthCredential credential =
//                           GoogleAuthProvider.credential(
//                         accessToken: googleAuth.accessToken,
//                         idToken: googleAuth.idToken,
//                       );
//                       final UserCredential result =
//                           await _auth.signInWithCredential(credential);
//                       final User? user = result.user;
//                       if (user != null) {
//                         // User is signed in, navigate to the home page
//                         // Store user's email and name in Firebase Realtime Database
//                         _storeUserDetails(user.email!, user.displayName ?? '');
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => MyHomePage()),
//                         );
//                       }
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.black,
//                     backgroundColor: yellowColor,
//                     elevation: 20,
//                     minimumSize: const Size(100, 50), //////// HERE
//
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 0),
//                         child: Image.asset(
//                           'assets/ic_google.png',
//                           width: 25,
//                           height: 25,
//                         ),
//                       ),
//                       const Expanded(
//                         child: Text(
//                           'Continue With Google',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                           textAlign: TextAlign.center, // Center the text
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   bool isLoading = false;
//   void _signUpWithEmailAndPassword() async {
//     String email = _emailController.text;
//     String password = _passwordController.text;
//     if (email.isEmpty ||
//         password.isEmpty ||
//         userNameController.text.isEmpty ||
//         _confirmPasswordController.text.isEmpty) {
//       Fluttertoast.showToast(
//           msg: 'All fields are required',
//           toastLength: Toast.LENGTH_SHORT,
//           // gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//
//       return;
//     }
//     if (_passwordController.text != _confirmPasswordController.text) {
//       Fluttertoast.showToast(
//           msg: 'Please enter same confirm password',
//           toastLength: Toast.LENGTH_SHORT,
//           // gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       return;
//     }
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       User? user = userCredential.user;
//       if (user != null) {
//         _storeUserDetails(user.email!, '');
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => MyHomePage()),
//         );
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(
//           msg: e.message ?? '',
//           toastLength: Toast.LENGTH_SHORT,
//           // gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       debugPrint('this is firebase exception ${e.message}');
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error creating account: $e');
//     }
//   }
//
//   void _signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser != null) {
//         final GoogleSignInAuthentication googleAuth =
//             await googleUser.authentication;
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//
//         final UserCredential result =
//             await _auth.signInWithCredential(credential);
//         final User? user = result.user;
//         if (user != null) {
//           _storeUserDetails(user.email!, user.displayName ?? '');
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const MyHomePage()),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error signing in with Google: $e');
//     }
//   }
//
//   void _storeUserDetails(String email, String name) {
//     final User? user = _auth.currentUser;
//     final String? uid = user?.uid;
//     final ref = _database.ref('AllArtists');
//     ref.child(uid!).set({
//       'email': email,
//       'userId': uid,
//       'name': name,
//       'userName': userNameController.text.trim(),
//       'password': _passwordController.text.trim(),
//       'country': '',
//       'mobileNumber': '',
//       'instagram': '',
//       'facebook': '',
//       'distributerName': '',
//       'tikTok': '',
//       'youTube': '',
//       'profilePicture': '',
//     });
//   }
// }

Widget appTextField(BuildContext context, String label, String hint,
    TextEditingController controller,
    {bool isLogin = false}) {
  final screenSize = MediaQuery.of(context).size;
  final screenWidth =GetPlatform.isWeb? screenSize.width/2:screenSize.width;
  final screenHeight = screenSize.height;
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize:!GetPlatform.isWeb? Get.width / 30:Get.width / 100),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            width: isLogin ? screenWidth / 1.9 : screenWidth / 2.3,
            height: 30,
            child: TextField(
              maxLines: 1,
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(bottom: 12),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                hintStyle: TextStyle(color: Colors.grey.shade800, fontSize: 14),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                disabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                hintText: hint,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
