import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snapmug_for_admins/splash_screen.dart';
import 'package:uuid/uuid.dart';

import 'SignIn.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  FilePickerResult? result;

  String profileImageURL = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _tikTokController = TextEditingController();
  final TextEditingController _youTubeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController distributerNameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _mobileNumberController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _tikTokController.dispose();
    _youTubeController.dispose();
    distributerNameController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
        backgroundColor: const Color(0xFF141118),
        appBar: AppBar(
          title: Text(
            'Edit Profile Info',
            style: TextStyle(
              color: yellowColor,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: yellowColor,
            ),
            onPressed: () {
              Navigator.pop(context);

              // handle back button press
            },
          ),
          backgroundColor: Colors.black,
        ),
        body: isLoading
            ? const AppLoader()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Spacer(flex: 4),
                          Column(
                            children: [
                              updateUsernameAndImage(),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _emailController.text.trim(),
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                          const Spacer(flex: 3),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEdit = !isEdit;
                              });
                            },
                            child: Column(
                              children: [
                                // Icon(Icons.edit, color: yellowColor),
                                Image.asset('assets/edit_prof_icon.png',
                                    height: 16),
                                const SizedBox(height: 5),
                                const Text(
                                  'Edit',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildProfileField('assets/musician-svgrepo-com.png',
                          'Artist Name', 'Enter your name', _nameController,
                          isEdit: isEdit),
                      const SizedBox(height: 10),
                      _buildProfileField(
                          'assets/worldwide-global-svgrepo-com.png',
                          'Country',
                          'Enter your country',
                          _countryController,
                          isEdit: isEdit,
                          suffixWidget: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode:
                                        false, // optional. Shows phone code before the country name.
                                    onSelect: (Country country) {
                                      setState(() {
                                        _countryController.text = country.name;
                                      });
                                    },
                                  );
                                },
                                child: Image.asset('assets/country_drop.png',
                                    color:
                                        !isEdit ? Colors.grey : yellowColor)),
                          )),
                      const SizedBox(height: 10),
                      _buildProfileField(
                          'assets/email.png',
                          'Email',
                          color: Colors.white,
                          'Enter email',
                          _emailController,
                          isEdit: false),
                      const SizedBox(height: 20),
                      _buildProfileField(
                          'assets/mobile.png',
                          'Mobile Number',
                          color: Colors.white,
                          'Enter your mobile number',
                          _mobileNumberController,
                          isEdit: false),
                      const SizedBox(height: 10),
                      _buildProfileField(
                          'assets/distributer.png',
                          'Distributor Name',
                          'Enter Distributor Name',
                          distributerNameController,
                          isEdit: isEdit),
                      const SizedBox(height: 10),
                      _buildProfileField(
                          'assets/tiktok-6338429_1280.png',
                          'TIKTOK LINK',
                          'Enter your TikTok link',
                          _tikTokController,
                          isEdit: isEdit),
                      const SizedBox(height: 10),
                      _buildProfileField(
                          'assets/social-3434840_1280.png',
                          'YOUTUBE LINK',
                          'Enter your YouTube link',
                          _youTubeController,
                          isEdit: isEdit),
                      const SizedBox(height: 10),
                      _buildProfileField(
                          'assets/instagram-3814080_1280.png',
                          'INSTAGRAM LINK',
                          'Enter your Instagram link',
                          _instagramController,
                          isEdit: isEdit),
                      const SizedBox(height: 10),
                      _buildProfileField(
                          'assets/facebook-1924510_1280.png',
                          'FACEBOOK LINK',
                          'Enter your Facebook link',
                          _facebookController,
                          isEdit: isEdit),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: updateLoading
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppLoader(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        if (isEdit) {
                          _uploadFileAndSaveData();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: yellowColor),
                            borderRadius: BorderRadius.circular(100)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Update Profile',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              'assets/approval.png',
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    )),
                    SizedBox(width: 10),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        _signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInActivity(),
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: yellowColor,
                            ),
                            borderRadius: BorderRadius.circular(100)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Log Out',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                            const SizedBox(width: 7),
                            Image.asset(
                              'assets/logout.png',
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
        ));
  }

  bool isLoading = false;
  bool updateLoading = false;
  Widget _buildProfileField(String imagePath, String label, String hint,
      TextEditingController controller,
      {bool isEdit = false, Color? color, Widget? suffixWidget}) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: yellowColor),
                borderRadius: BorderRadius.circular(10)),
            child: Image(
              image: AssetImage(imagePath),
              width: 25,
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: screenWidth / 2.5,
              height: 30,
              child: TextField(
                controller: controller,
                enabled: isEdit,
                style: const TextStyle(color: Colors.white, fontSize: 10),
                decoration: InputDecoration(
                  suffixIcon: suffixWidget,
                  contentPadding: const EdgeInsets.only(bottom: 15),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  hintStyle:
                      TextStyle(color: Colors.grey.shade800, fontSize: 10),
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

  Widget _build2IconProfileField(String imagePath, String icon2Path,
      String label, String hint, TextEditingController controller) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              imagePath,
              width: 12,
            ),
            Image.asset(
              icon2Path,
              width: 12,
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 5),
          ],
        ),
        SizedBox(
          width: screenWidth / 2.5,
          height: 30,
          child: TextField(
            controller: controller, // Add the controller here

            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: yellowColor), // Set the border color to yellow
                borderRadius:
                    BorderRadius.circular(10.0), // Set the border radius
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors
                        .yellow), // Set the border color to yellow for enabled state
                borderRadius:
                    BorderRadius.circular(10.0), // Set the border radius
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors
                        .yellow), // Set the border color to yellow for focused state
                borderRadius:
                    BorderRadius.circular(10.0), // Set the border radius
              ),
              hintText: hint,
            ),
          ),
        ),
      ],
    );
  }

  Widget updateUsernameAndImage() {
    final screenSize = MediaQuery.of(context).size;
    // final screenWidth = screenSize.width;
    // final screenHeight = screenSize.height;
    Uint8List? fileBytesArtwork;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   width: screenWidth / 2.5,
          //   height: 30,
          //   child: TextField(
          //     style: const TextStyle(color: Colors.white),
          //     controller: _userNameController,
          //     decoration: InputDecoration(
          //         contentPadding: const EdgeInsets.only(left: 15, top: 10),
          //         border: OutlineInputBorder(
          //           borderSide: const BorderSide(
          //               color: yellowColor), // Set the border color to yellow
          //           borderRadius:
          //               BorderRadius.circular(10.0), // Set the border radius
          //         ),
          //         enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //               color: Colors
          //                   .yellow), // Set the border color to yellow for enabled state
          //           borderRadius:
          //               BorderRadius.circular(10.0), // Set the border radius
          //         ),
          //         focusedBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //               color: Colors
          //                   .yellow), // Set the border color to yellow for focused state
          //           borderRadius:
          //               BorderRadius.circular(10.0), // Set the border radius
          //         ),
          //         hintText: 'username',
          //         hintStyle: TextStyle(color: Colors.grey)),
          //   ),
          // ),
          GestureDetector(
            onTap: () async {
              result = await FilePicker.platform.pickFiles();
              setState(() {});
            },
            child: Container(
              width: 150,
              height: 150,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(100)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  width: 150,
                  height: 150,
                  image: profileImageURL.isEmpty && result == null
                      ? AssetImage('assets/musician-svgrepo-com.png')
                      : result != null
                          ? FileImage(File(result?.paths.firstOrNull ?? ''))
                          : NetworkImage(profileImageURL)
                              as ImageProvider<Object>,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFileAndSaveData() async {
    setState(() {
      updateLoading = true;
    });
    String profileImageURL = '';
    final User? user = _auth.currentUser;
    final String? uid = user?.uid;

    final ref = _database.ref('AllArtists').child(uid!);

    if (result != null) {
      if (kIsWeb) {
        Uint8List? fileBytes = result?.files.first.bytes;
        final storageRef = FirebaseStorage.instance.ref();
        final musicRef = storageRef.child('users/$uid');
        final uploadTask = musicRef.putData(fileBytes!);
        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              print("Upload is $progress% complete.");
              break;
            case TaskState.paused:
              print("Upload is paused.");
              break;
            case TaskState.canceled:
              print("Upload was canceled");
              break;
            case TaskState.error:
              // Handle unsuccessful uploads
              break;
            case TaskState.success:
              final downloadUrl = await taskSnapshot.ref.getDownloadURL();
              print("Download URL: $downloadUrl");
              profileImageURL = downloadUrl;
              final name = _nameController.text;
              final country = _countryController.text;
              final mobileNumber = _mobileNumberController.text;
              final instagram = _instagramController.text;
              final facebook = _facebookController.text;
              final tikTok = _tikTokController.text;
              final youTube = _youTubeController.text;
              final distName = distributerNameController.text;

              print("profileImageURL: $profileImageURL");
              ref.set({
                'userId': uid,
                'name': name,
                'country': country,
                'mobileNumber': mobileNumber,
                'instagram': instagram,
                'facebook': facebook,
                'tikTok': tikTok,
                'youTube': youTube,
                'profilePicture': profileImageURL,
                'distributerName': distName,
              });
              // Handle successful uploads
              appToast('profile updated successfully!');
              Navigator.of(context).pop();
              setState(() {
                updateLoading = false;
              });
              break;
          }
        });
      } else {
        File file = File(result!.files.single.path!);
        final storageRef = FirebaseStorage.instance.ref();
        final musicRef = storageRef.child('users/$uid');
        final uploadTask = musicRef.putFile(file);
        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              print("Upload is $progress% complete.");
              break;
            case TaskState.paused:
              print("Upload is paused.");
              break;
            case TaskState.canceled:
              print("Upload was canceled");
              break;
            case TaskState.error:
              // Handle unsuccessful uploads
              break;
            case TaskState.success:
              final downloadUrl = await taskSnapshot.ref.getDownloadURL();
              print("Download URL: $downloadUrl");
              profileImageURL = downloadUrl;
              final name = _nameController.text;
              final country = _countryController.text;
              final mobileNumber = _mobileNumberController.text;
              final instagram = _instagramController.text;
              final facebook = _facebookController.text;
              final tikTok = _tikTokController.text;
              final youTube = _youTubeController.text;
              final distName = distributerNameController.text;

              print("profileImageURL: $profileImageURL");
              ref.set({
                'userId': uid,
                'name': name,
                'country': country,
                'mobileNumber': mobileNumber,
                'instagram': instagram,
                'facebook': facebook,
                'tikTok': tikTok,
                'youTube': youTube,
                'profilePicture': profileImageURL,
                'distributerName': distName,
              });
              appToast('profile updated successfully!');
              Navigator.of(context).pop();

              setState(() {
                updateLoading = false;
              });
              break;
          }
        });
      }
    } else {
      print("No file selected");
      final name = _nameController.text;
      final country = _countryController.text;
      final mobileNumber = _mobileNumberController.text;
      final instagram = _instagramController.text;
      final facebook = _facebookController.text;
      final tikTok = _tikTokController.text;
      final youTube = _youTubeController.text;
      final distName = distributerNameController.text;

      print("profileImageURL: $profileImageURL");
      ref.set({
        'userId': uid,
        'name': name,
        'country': country,
        'mobileNumber': mobileNumber,
        'instagram': instagram,
        'facebook': facebook,
        'tikTok': tikTok,
        'youTube': youTube,
        'distributerName': distName,

        // 'profilePicture': profileImageURL,
      });
      Future.delayed(const Duration(seconds: 3), () {
        appToast('profile updated successfully!');
        Navigator.of(context).pop();

        setState(() {
          updateLoading = false;
        });
      });
    }
  }

  Future<void> fetchUserDetails() async {
    setState(() {
      isLoading = true;
    });
    final User? user = _auth.currentUser;
    if (user != null) {
      final String uid = user.uid;
      final database = FirebaseDatabase.instance;
      final reference = database.ref('AllArtists').child(uid);
      final snapshot = await reference.get();
      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>;
        debugPrint('User Data: $userData');
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _countryController.text = userData['country'] ?? '';
          _mobileNumberController.text = userData['mobileNumber'] ?? '';
          _instagramController.text = userData['instagram'] ?? '';
          _facebookController.text = userData['facebook'] ?? '';
          _tikTokController.text = userData['tikTok'] ?? '';
          _youTubeController.text = userData['youTube'] ?? '';
          _emailController.text = userData['email'] ?? '';
          distributerNameController.text = userData['distributerName'] ?? '';
          profileImageURL = userData['profilePicture'] ?? '';
        });
        setState(() {
          isLoading = false;
        });
        debugPrint('User Data: $userData');
      } else {
        setState(() {
          isLoading = false;
        });
        debugPrint('No data available for this user.');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      debugPrint('User is not signed in.');
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

Widget build2IconProfileField(
    BuildContext context,
    String imagePath,
    String icon2Path,
    String label,
    String hint,
    TextEditingController controller,
    {bool isEdit = false}) {
  final screenSize = MediaQuery.of(context).size;
  final screenWidth = screenSize.width;
  final screenHeight = screenSize.height;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Container(
            height: 40,
            width: 40,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: yellowColor),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    imagePath,
                    width: 12,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    icon2Path,
                    width: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          SizedBox(width: 5),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: screenWidth / 2.5,
          height: 30,
          child: TextField(
            controller: controller,
            enabled: isEdit,
            style: const TextStyle(color: Colors.white, fontSize: 10),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 15),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              hintStyle: TextStyle(color: Colors.grey.shade800, fontSize: 10),
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
  );
}

appToast(String msg) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
  );
}
