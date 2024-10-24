import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snapmug_for_admins/pages/all_users.dart';
import 'package:snapmug_for_admins/user_data.dart';
import '../SignIn.dart';

class EditArtistProfile extends StatefulWidget {
  String id;
  EditArtistProfile({super.key, required this.id});
  @override
  _EditArtistProfileState createState() => _EditArtistProfileState();
}

class _EditArtistProfileState extends State<EditArtistProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  FilePickerResult? result;
  String profileImageURL = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _tikTokController = TextEditingController();
  final TextEditingController _youTubeController = TextEditingController();
  final TextEditingController _mobileMoneyNameController =
      TextEditingController();
  final TextEditingController _paypalEmailController = TextEditingController();
  final TextEditingController _mobileMoneyNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  UserProfile? profileData;

  bool dateLoading = false;
  bool isLoading = false;
  var artistId = '';
  Future<void> getUserProfile() async {
    print('gettting the data for uid ${widget.id}');
    try {
      setState(() {
        dateLoading = true;
      });
      final DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref().child('AllArtists').child(widget.id);
      final snapshot = await databaseRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final artistProfile = ArtisProfile.fromMap(data);
        debugPrint('this is user data $artistProfile');
        setState(() {
          artistId = artistProfile.userId;
          _nameController.text = artistProfile.name;
          _countryController.text = artistProfile.country;
          _mobileNumberController.text = artistProfile.mobileNumber;
          _instagramController.text = artistProfile.instagram;
          _facebookController.text = artistProfile.facebook;
          _tikTokController.text = artistProfile.tikTok;
          _youTubeController.text = artistProfile.youTube;
          _userNameController.text = artistProfile.name;
          _mobileMoneyNumberController.text = artistProfile.mobileNumber;
          _emailController.text = artistProfile.email;
          profileImageURL = artistProfile.profilePicture;
        });
      } else {
        debugPrint('No data available for this UID.');
      }
      await fetchArtistSongs();
      setState(() {
        dateLoading = false;
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
          msg: e.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 16.0);
      setState(() {
        dateLoading = false;
      });
    } catch (error) {
      setState(() {
        dateLoading = false;
      });
      print('Error fetching data: $error');
    }
  }

  Map<String, Map<String, dynamic>> songTitles = {};

  Future<void> fetchArtistSongs() async {
    songTitles.clear();
    setState(() {
      isLoading = true;
    });

    final database = FirebaseDatabase.instance.ref().child('AllMusic');
    database.once().then((DatabaseEvent event) async {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final songMap = snapshot.value as Map<dynamic, dynamic>;
        songMap.forEach((key, value) {
          if (value['userId'] == artistId) {
            Map<String, dynamic> songData = {
              'artistName': value['artistName'],
              'albumArtUrl': value['albumArtUrl'] ??
                  'https://firebasestorage.googleapis.com/v0/b/snapmug-54ade.appspot.com/o/tmpp%2Fwell.jpeg?alt=media&token=1749d61b-734b-4739-b9e1-e5daefcbb500',
              'audioUrl': value['audioUrl'],
              'dollorIconVisiblity': value['dollorIconVisiblity'] ?? false,
              'facebookLink': value['facebookLink'],
              'facebookUshes': value['facebookUshes'],
              'fireIconVisiblity': value['fireIconVisiblity'] ?? false,
              'instagramLink': value['instagramLink'],
              'instagramUshes': value['instagramUshes'],
              'producerName': value['producerName'],
              'recordLabel': value['recordLabel'],
              'songId': value['songId'],
              'songName': value['songName'],
              'tikTokLink': value['tikTokLink'],
              'tikTokUshes': value['tikTokUshes'],
              'writer': value['writer'],
              'yearOfProduction': value['yearOfProduction'],
              'youtubeLink': value['youtubeLink'],
              'youtubeUshes': value['youtubeUshes'],
              'userId': value['userId'],
            };
            songTitles[key] = songData;
          }
        });
        print("feeding done");
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("No data found in the 'AllMusic' node");
      }
    });
  }

  Future<void> deleteUserAccount() async {
    debugPrint('deleting account');
    setState(() {
      isLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: UserProfileData().profileData['password'] ?? '');
        await user.reauthenticateWithCredential(credential);
        await user.delete();
        debugPrint("User account deleted successfully.");
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInActivity(),
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        debugPrint("Error deleting user account: $e");
      }
    } else {
      debugPrint("No user is currently signed in.");
    }
  }

  void deleteFireBaseStorageItem(String fileUrl) {
    String filePath = fileUrl.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/snapmugflutter.appspot.com/o/'),
        '');

    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');

    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

    final storageReferance = FirebaseStorage.instance.ref();

    storageReferance.child(filePath).delete().then((_) {
      fetchArtistSongs();
      print('Successfully deleted $filePath storage item');
    });
  }

  Future<void> _deleteSong(String songId, String artWorkUrl, String musicURL,
      {String key = ''}) async {
    try {
      final songRef = _database.ref('AllMusic').child(songId);
      await songRef.remove();
      deleteFireBaseStorageItem(artWorkUrl);
      deleteFireBaseStorageItem(musicURL);
      songTitles.remove(key);

      setState(() {});
      debugPrint('Song deleted successfully');
    } catch (error) {
      debugPrint('Error deleting song: $error');
      // Handle error
    }
  }

  bool isEdit = false;
  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _mobileNumberController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _tikTokController.dispose();
    _youTubeController.dispose();
    _mobileMoneyNameController.dispose();
    _mobileMoneyNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: const Color(0xFF141118),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141118),
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5), // Add 10 pixels of space
          child: Image.asset('assets/logo.png'),
        ),
      ),
      body: dateLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: SingleChildScrollView(
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
                                      // Icon(Icons.edit, color: Colors.yellow),
                                      Image.asset('assets/edit_prof_icon.png',
                                          height: 16),
                                      const SizedBox(height: 5),
                                      const Text('Edit',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _buildProfileField(
                                'assets/musician-svgrepo-com.png',
                                'Name',
                                'Enter your name',
                                controller: _nameController,
                                isEdit: isEdit),
                            const SizedBox(height: 10),
                            _buildProfileField(
                                'assets/worldwide-global-svgrepo-com.png',
                                'Country',
                                'Enter your country',
                                controller: _countryController,
                                isEdit: isEdit,
                                suffixWidget: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: GestureDetector(
                                      onTap: () {
                                        showCountryPicker(
                                          context: context,
                                          showPhoneCode:
                                              false, // optional. Shows phone code before the country name.
                                          onSelect: (Country country) {
                                            setState(() {
                                              _countryController.text =
                                                  country.name;
                                            });
                                          },
                                        );
                                      },
                                      child: Image.asset(
                                          'assets/country_drop.png',
                                          color: isEdit
                                              ? Colors.yellow
                                              : Colors.grey)),
                                )),
                            const SizedBox(height: 10),
                            _buildProfileField(
                                'assets/mixer-music-6-svgrepo-com.png',
                                'Mobile Money Name',
                                'Enter your mobile money name',
                                controller: _mobileMoneyNameController,
                                isEdit: isEdit),
                            const SizedBox(height: 10),
                            build2IconProfileField(
                                context,
                                'assets/mtn-mobile-logo-icon.png',
                                'assets/PinClipart.com_clip-art-2010_1162739.png',
                                'Mobile Money Number',
                                'Enter your mobile money number',
                                _mobileMoneyNumberController,
                                isEdit: isEdit),
                            const SizedBox(height: 10),
                            _buildProfileField('assets/paypal-784404_1280.png',
                                'PayPal Email', 'Enter PayPal Email',
                                controller: _paypalEmailController,
                                isEdit: isEdit),
                            const SizedBox(height: 10),
                            _buildProfileField(
                                'assets/instagram-3814080_1280.png',
                                'Instagram Links',
                                '',
                                isEdit: isEdit),
                            const SizedBox(height: 10),
                            _buildProfileField(
                                'assets/facebook-1924510_1280.png',
                                'Facebook Links',
                                '',
                                isEdit: isEdit),
                            const SizedBox(height: 10),
                            _buildProfileField('assets/tiktok-6338429_1280.png',
                                'TikTok Link', '',
                                isEdit: isEdit),
                            const SizedBox(height: 10),
                            _buildProfileField('assets/social-3434840_1280.png',
                                'YouTube Links', '',
                                isEdit: isEdit),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: isLoading
                                  ? const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Center(
                                            child: CircularProgressIndicator()
                                        ),
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
                                                border: Border.all(
                                                    color: Colors.yellow),
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Update Profile',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(width: 5),
                                                Image.asset(
                                                  'assets/approval.png',
                                                  color: isEdit
                                                      ? Colors.yellow
                                                      : Colors.grey,
                                                  height: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            deleteUserAccount();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7, horizontal: 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.yellow),
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Delete Profile',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(width: 5),
                                                Image.asset(
                                                  'assets/trash.png',
                                                  height: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(color: yellowColor),
                            borderRadius: BorderRadius.circular(30)),
                        child: songTitles.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Song found',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : ListView.separated(
                                itemCount: songTitles.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  height: 0, // or a very small value like 1
                                  color: Color(0xFF141118),
                                ),
                                itemBuilder: (context, index) {
                                  final songKey =
                                      songTitles.keys.elementAt(index);
                                  final songData = songTitles[songKey]!;
                                  return ListTile(
                                    leading: SizedBox(
                                      width: 55,
                                      height: 55,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Stack(
                                          children: [
                                            // Image
                                            CachedNetworkImage(
                                              width: 55,
                                              height: 55,
                                              imageUrl: songData['albumArtUrl'],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                            // Dollar Icon
                                            if (songData[
                                                    'dollorIconVisiblity'] ??
                                                false)
                                              Positioned(
                                                left: -5,
                                                top: -4,
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.black,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  padding: EdgeInsets.all(
                                                      6.0), // Adjust the padding as needed
                                                  child: Icon(
                                                    Icons.attach_money_rounded,
                                                    color: yellowColor,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {},
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/boat-9-512.png'),
                                          width: 20,
                                          color: yellowColor,
                                        ),
                                        const SizedBox(width: 5),
                                        Image(
                                          image: AssetImage(
                                              'assets/car-25-512 (1).png'),
                                          width: 20,
                                          color: yellowColor,
                                        ),
                                        SizedBox(width: 5),
                                        if (songData['fireIconVisiblity'] ??
                                            false)
                                          Icon(
                                              Icons
                                                  .local_fire_department_rounded,
                                              color: yellowColor),
                                        const SizedBox(width: 5),
                                        Image(
                                          image: AssetImage(
                                              'assets/rocket-512.png'),
                                          width: 20,
                                          color: yellowColor,
                                        ),
                                        const SizedBox(width: 5),
                                        PopupMenuButton(
                                          child: const Image(
                                            image: AssetImage(
                                                'assets/settings-25-512.png'),
                                            width: 20,
                                          ),
                                          onSelected: (value) {
                                            if (value == 'delete') {
                                              // delete song logic here
                                              print('Delete song');
                                            } else if (value == 'edit') {
                                              // edit song logic here
                                              print('Edit song');
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'),
                                              onTap: () {
                                                print("==================");
                                                print(songData['songId']);
                                                _deleteSong(
                                                    songData['songId'],
                                                    songData['albumArtUrl'],
                                                    songData['audioUrl']);
                                              },
                                            ),
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit'),
                                              onTap: () async {
                                                // await Navigator.of(context).push(
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             UpdateMusicScreen(
                                                //               songId:
                                                //                   songData['songId'],
                                                //             )));
                                                // fetchDataFromFirebase();

                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         MyHomePage(
                                                //       artistName:
                                                //           songData['artistName'],
                                                //       albumArtUrl:
                                                //           songData['albumArtUrl'],
                                                //       audioUrl:
                                                //           songData['audioUrl'],
                                                //       dollorIconVisiblity: songData[
                                                //               'dollorIconVisiblity'] ??
                                                //           false, // Convert string to bool
                                                //       facebookLink: songData[
                                                //           'facebookLink'],
                                                //       facebookUshes: songData[
                                                //               'facebookUshes'] ??
                                                //           '',
                                                //       fireIconVisiblity: songData[
                                                //               'fireIconVisiblity'] ??
                                                //           false, // Convert string to bool
                                                //       instagramLink: songData[
                                                //           'instagramLink'],
                                                //       instagramUshes: songData[
                                                //               'instagramUshes'] ??
                                                //           '',
                                                //       producerName: songData[
                                                //           'producerName'],
                                                //       recordLabel:
                                                //           songData['recordLabel'],
                                                //       songId: songData['songId'],
                                                //       songName:
                                                //           songData['songName'],
                                                //       tikTokLink:
                                                //           songData['tikTokLink'],
                                                //       tikTokUshes: songData[
                                                //               'tikTokUshes'] ??
                                                //           '',
                                                //       writer: songData['writer'],
                                                //       yearOfProduction: songData[
                                                //           'yearOfProduction'],
                                                //       youtubeLink:
                                                //           songData['youtubeLink'],
                                                //       youtubeUshes: songData[
                                                //               'youtubeUshes'] ??
                                                //           '',
                                                //     ),
                                                //   ),
                                                // );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    title: Text(songData['songName'],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10)), // Display song name
                                    subtitle: Text(songData['artistName'],
                                        style: TextStyle(
                                            color: yellowColor,
                                            fontSize:
                                                10)), // Display artist name
                                  );
                                },
                              ))),
              ],
            ),
    );
  }

  Widget _buildProfileField(String imagePath, String label, String hint,
      {bool isEdit = false,
      Widget? suffixWidget,
      TextEditingController? controller}) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow),
                borderRadius: BorderRadius.circular(10)),
            child: Image(
              image: AssetImage(imagePath),
              width: 25,
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
              width: screenWidth / 7,
              height: 30,
              child: TextField(
                controller: controller,
                enabled: isEdit,
                style: const TextStyle(color: Colors.white, fontSize: 10),
                decoration: InputDecoration(
                  suffixIcon: suffixWidget,
                  contentPadding:
                      EdgeInsets.only(bottom: suffixWidget != null ? 9 : 15),
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
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
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

  Widget updateUsernameAndImage() {
    final screenSize = MediaQuery.of(context).size;
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
          //               color: Colors.yellow), // Set the border color to yellow
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
              width: 120,
              height: 120,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(100)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  width: 120,
                  height: 120,
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
      isLoading = true;
    });
    String profileImageURL = '';
    final User? user = _auth.currentUser;
    final String? uid = user?.uid;
    final ref = _database.ref('AllUsers').child(uid!);
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
              final mobileMoneyName = _mobileMoneyNameController.text;
              final mobileMoneyNumber = _mobileMoneyNumberController.text;
              final userName = _userNameController.text;
              print("profileImageURL: $profileImageURL");
              ref.update({
                'name': name,
                'country': country,
                'mobileNumber': mobileNumber,
                'instagram': instagram,
                'paypalEmail': _paypalEmailController.text.trim(),
                'facebook': facebook,
                'userName': facebook,
                'tikTok': tikTok,
                'youTube': youTube,
                'userName': userName,
                'mobileMoneyName': mobileMoneyName,
                'mobileMoneyNumber': mobileMoneyNumber,
                'profilePicture': profileImageURL,
              });
              // Handle successful uploads
              print("Profile uploaded successfully!");
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
              setState(() {
                isLoading = false;
              });
              print("Upload is paused.");
              break;
            case TaskState.canceled:
              setState(() {
                isLoading = false;
              });
              print("Upload was canceled");
              break;
            case TaskState.error:
              setState(() {
                isLoading = false;
              });
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
              final mobileMoneyName = _mobileMoneyNameController.text;
              final userName = _userNameController.text;
              final mobileMoneyNumber = _mobileMoneyNumberController.text;
              print("profileImageURL: $profileImageURL");
              ref.update({
                'name': name,
                'country': country,
                'mobileNumber': mobileNumber,
                'instagram': instagram,
                'facebook': facebook,
                'tikTok': tikTok,
                'youTube': youTube,
                'userName': userName,
                'mobileMoneyName': mobileMoneyName,
                'mobileMoneyNumber': mobileMoneyNumber,
                'profilePicture': profileImageURL,
              });
              Navigator.of(context).pop();
              setState(() {
                isLoading = false;
              });
              Fluttertoast.showToast(
                  msg: 'Profile updated successfully!',
                  toastLength: Toast.LENGTH_SHORT,
                  // gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              // print("Music uploaded successfully!");
              break;
          }
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print("No file selected");
    }
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
          // Container(
          //   height: 40,
          //   width: 40,
          //   padding: EdgeInsets.all(5),
          //   decoration: BoxDecoration(
          //       border: Border.all(color: Colors.yellow),
          //       borderRadius: BorderRadius.circular(10)),
          //   child: Image(
          //     image: AssetImage(iconPath),
          //     width: 25,
          //   ),
          // ),
          Container(
            height: 40,
            width: 40,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow),
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
          width: screenWidth / 7,
          height: 30,
          child: TextField(
            controller: controller,
            enabled: isEdit,
            style: TextStyle(color: Colors.white, fontSize: 10),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 15),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              hintStyle: TextStyle(color: Colors.grey.shade800, fontSize: 10),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
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

class ArtisProfile {
  final String country;
  final String distributerName;
  final String email;
  final String facebook;
  final String instagram;
  final String mobileNumber;
  final String name;
  final String recordLabel;
  final List<String> socialSS;
  final String tikTok;
  final String userId;
  final String profilePicture;
  final String youTube;

  ArtisProfile({
    required this.country,
    required this.distributerName,
    required this.email,
    required this.facebook,
    required this.instagram,
    required this.mobileNumber,
    required this.profilePicture,
    required this.name,
    required this.recordLabel,
    required this.socialSS,
    required this.tikTok,
    required this.userId,
    required this.youTube,
  });

  // Factory method to create a UserProfile from a map
  factory ArtisProfile.fromMap(Map<dynamic, dynamic> map) {
    return ArtisProfile(
      country: map['country'] ?? '',
      distributerName: map['distributerName'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      email: map['email'] ?? '',
      facebook: map['facebook'] ?? '',
      instagram: map['instagram'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      name: map['name'] ?? '',
      recordLabel: map['recordLabel'] ?? '',
      socialSS: map['socialSS'] == null || map['socialSS'] == []
          ? []
          : List<String>.from(map['socialSS']),
      tikTok: map['tikTok'] ?? '',
      userId: map['userId'] ?? '',
      youTube: map['youTube'] ?? '',
    );
  }

  // Method to convert the UserProfile back to a map
  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'distributerName': distributerName,
      'email': email,
      'facebook': facebook,
      'profilePicture': profilePicture,
      'instagram': instagram,
      'mobileNumber': mobileNumber,
      'name': name,
      'recordLabel': recordLabel,
      'socialSS': socialSS,
      'tikTok': tikTok,
      'userId': userId,
      'youTube': youTube,
    };
  }
}
