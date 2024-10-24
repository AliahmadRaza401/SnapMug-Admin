import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../EditProfilePage.dart';
import '../SignIn.dart';

class VerificationWidget extends StatefulWidget {
  Map<dynamic, dynamic> data;
  Function(bool) updated;
  VerificationWidget({super.key, required this.data,required this.updated});

  @override
  State<VerificationWidget> createState() => _VerificationWidgetState();
}

class _VerificationWidgetState extends State<VerificationWidget> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController distributerController = TextEditingController();
  TextEditingController recordLabelController = TextEditingController();
  bool isLoading = false;
  FilePickerResult? result;
  var imagesList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    addDataFields();
    super.initState();
  }

  addDataFields() {
    setState(() {
      fullNameController.text = widget.data['name'] ?? '';
      emailController.text = widget.data['email'] ?? '';
      phoneController.text = widget.data['mobileNumber'] ?? '';
      distributerController.text = widget.data['distributerName'] ?? '';
      recordLabelController.text = widget.data['recordLabel'] ?? '';
      imagesList = widget.data['socialSS'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFF141118),
              child: Stack(
                children: [
                  Image.asset('assets/oval_logo.png'),
                  Positioned(
                      top: 20,
                      right: 20,
                      child: Image.asset(
                        'assets/approval.png',
                        height: 30,
                      )),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 14),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: yellowColor)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/musician-svgrepo-com.png',
                      height: 10,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Your Contact Information',
                      style: TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildProfileField("assets/musician-svgrepo-com.png", "Full Name", "",
              fullNameController),
          _buildProfileField("assets/writing-hand-skin-5-svgrepo-com.png",
              "Email Address", "", emailController),
          _buildProfileField("assets/writing-hand-skin-5-svgrepo-com.png",
              "Mobile Number", "", phoneController),
          _buildProfileField("assets/distributer.png", "Distributor Name", "",
              distributerController),
          _buildProfileField("assets/icons8-music-record-94.png",
              "Record Label", "", recordLabelController),
          Container(
            alignment: Alignment.topLeft,
            // width: 132,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Social Media Screenshot',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                // const Text(
                //   'Maxmium Size: 5MB',
                //   style: TextStyle(color: Colors.white, fontSize: 10),
                // ),
                // const Text(
                //   'Format: jpg/png/jpeg',
                //   style: TextStyle(color: Colors.white, fontSize: 10),
                // ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 132,
                  child: Row(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: imagesList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 110,
                                  width: 110,
                                  margin: const EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      imagesList[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }))
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 35,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          updateArtistDetails(widget.data['userId']);
                        },
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
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          updateArtistDetails(widget.data['userId'],
                              isApproved: false);
                        },
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
                          'Deny',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }

  Widget _buildProfileField(String imagePath, String label, String hint,
      TextEditingController controller) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Container(
      width: screenWidth,
      height: 28,
      margin: const EdgeInsets.only(bottom: 25),
      child: TextField(
        controller: controller,
        cursorHeight: 15,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 11),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 0, left: 10),
          floatingLabelStyle:
              const TextStyle(color: Colors.white, fontSize: 12),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: SizedBox(
            width: 150,
            child: Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: yellowColor), // Set the border color to yellow
            borderRadius: BorderRadius.circular(20), // Set the border radius
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.yellow),
            // Set the border color to yellow for enabled state
            borderRadius: BorderRadius.circular(20), // Set the border radius
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.yellow),
            // Set the border color to yellow for focused state
            borderRadius: BorderRadius.circular(20), // Set the border radius
          ),
          hintText: hint,
        ),
      ),
    );
  }

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  void updateArtistDetails(String id, {bool isApproved = true}) async {
    try {
      setState(() {
        isLoading = true;
      });

      final ref = _database.ref('AllArtists');
      var data = isApproved ? {'isVerified': true} : {'isRejected': true};

      ref.child(id).update(data).then((v) {
        widget.updated(true);
        setState(() {
          isLoading = false;
        });
        appToast('Artist approved successfully');
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> uploadFile(File file) async {
    String downloadUrl = '';
    final storageRef = FirebaseStorage.instance.ref();
    var id = generateRandomId(10);
    final stRef = storageRef.child('socialMediaImages/$id');

    try {
      final uploadTask = await stRef.putFile(file);

      // Get the download URL after the file is successfully uploaded
      downloadUrl = await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print('Error occurred during upload: $e');
      downloadUrl = ''; // Handle the error appropriately
    }

    return downloadUrl;
  }
}

String generateRandomId(int length) {
  const String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final Random random = Random();

  return List.generate(length, (index) {
    final int randomIndex = random.nextInt(characters.length);
    return characters[randomIndex];
  }).join();
}
