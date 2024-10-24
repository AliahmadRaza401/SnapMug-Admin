import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snapmug_for_admins/pages/verification_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'dart:html' as html;
import '../EditProfilePage.dart';
import '../SignIn.dart';
import '../splash_screen.dart';
import '../user_data.dart';
import 'audio_widgets.dart';

class UploadMusicScreen extends StatefulWidget {
  const UploadMusicScreen({super.key});

  @override
  State<UploadMusicScreen> createState() => _UploadMusicScreenState();
}

class _UploadMusicScreenState extends State<UploadMusicScreen> {
  bool isPlaying = false;
  FilePickerResult? result;
  String profileImageURL =
      'https://t4.ftcdn.net/jpg/04/81/13/43/360_F_481134373_0W4kg2yKeBRHNEklk4F9UXtGHdub3tYk.jpg';
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration position = Duration.zero;

  final TextEditingController _artistNameController = TextEditingController();
  final TextEditingController _musicNameController = TextEditingController();
  final TextEditingController _writerNameController = TextEditingController();
  final TextEditingController _producerNameController = TextEditingController();
  final TextEditingController _recordLabelController = TextEditingController();
  final TextEditingController _yearOfProductionController =
      TextEditingController();
  final TextEditingController _youtubeLinkController = TextEditingController();
  final TextEditingController _instagramLinkController =
      TextEditingController();
  final TextEditingController _facebookLinkController = TextEditingController();
  final TextEditingController _tikTokLinkController = TextEditingController();
  final TextEditingController _youtubeUsesController = TextEditingController();
  final TextEditingController _instagramUsesController =
      TextEditingController();
  final TextEditingController _facebookUsesController = TextEditingController();
  final TextEditingController _tikTokUsesController = TextEditingController();
  String titleUUID = '';
  String artWorkURL = '';
  String musicURL = '';
  bool dollorIconVisiblity = false;
  bool musicLoading = false;
  bool fireIconVisiblity = false;

  Duration? duration = const Duration(seconds: 10);
  @override
  void dispose() {
    _artistNameController.dispose();
    _musicNameController.dispose();
    _writerNameController.dispose();
    _producerNameController.dispose();
    _recordLabelController.dispose();
    _yearOfProductionController.dispose();
    _youtubeLinkController.dispose();
    _instagramLinkController.dispose();
    _facebookLinkController.dispose();
    _tikTokLinkController.dispose();
    _youtubeUsesController.dispose();
    _instagramUsesController.dispose();
    _facebookUsesController.dispose();
    _tikTokUsesController.dispose();
    super.dispose();
  }

  clearSongData() {
    _artistNameController.clear();
    _musicNameController.clear();
    _writerNameController.clear();
    _producerNameController.clear();
    _recordLabelController.clear();
    _yearOfProductionController.clear();
    _youtubeLinkController.clear();
    _instagramLinkController.clear();
    _facebookLinkController.clear();
    _tikTokLinkController.clear();
    _youtubeUsesController.clear();
    _instagramUsesController.clear();
    _facebookUsesController.clear();
    _tikTokUsesController.clear();
    _audioFile = null;
    _albumImageFile = null;
  }

  String? _selectedAlbumImage;
  String? _selectedAudio;

  File? _albumImageFile;
  File? _audioFile;

  Uint8List? fileBytesMusic;
  Uint8List? fileBytesArtwork;
  String musicFileName = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> _uploadArtwork() async {
    if (kIsWeb) {
      final storageRef = FirebaseStorage.instance.ref();

      final musicRef = storageRef.child(
          'artwork/$titleUUID'); // Include the file name in the storage path

      // final musicRef = storageRef.child('music/}');
      final uploadTask = musicRef.putData(fileBytesArtwork!);
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            debugPrint("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            debugPrint("Upload is paused.");
            break;
          case TaskState.canceled:
            debugPrint("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            final downloadUrl = await taskSnapshot.ref.getDownloadURL();
            debugPrint("Download URL In web artwork: $downloadUrl");
            artWorkURL = downloadUrl;
            _uploadMusic();
            // Handle successful uploads
            debugPrint("Music uploaded successfully!");
            break;
        }
      });
    } else {
      File file = _albumImageFile!;
      final storageRef = FirebaseStorage.instance.ref();
      final artworkRef = storageRef.child(
          'artwork/$titleUUID'); // Include the file name in the storage path
      final uploadTask = artworkRef.putFile(file);
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            debugPrint("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            debugPrint("Upload is paused.");
            break;
          case TaskState.canceled:
            debugPrint("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            // Handle successful uploads
            debugPrint("Artwork uploaded successfully!");
            final downloadUrl = await taskSnapshot.ref.getDownloadURL();
            debugPrint("Download URL: $downloadUrl");

            artWorkURL = downloadUrl;
            _uploadMusic();

            break;
        }
      });
    }

    // Listen for upload progress and completion
  }

  Future<void> _uploadMusic() async {
    if (kIsWeb) {
      final storageRef = FirebaseStorage.instance.ref();

      final musicRef = storageRef.child(
          'music/$titleUUID.mp3'); // Include the file name in the storage path
// final SettableMetadata metadata = SettableMetadata(
//   contentType: 'audio/mpeg', // Set the content type to mp3
// );
      // final musicRef = storageRef.child('music/}');
      final uploadTask = musicRef.putData(
          fileBytesMusic!, SettableMetadata(contentType: 'audio/mpeg'));

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            debugPrint("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            debugPrint("Upload is paused.");
            break;
          case TaskState.canceled:
            debugPrint("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            final downloadUrl = await taskSnapshot.ref.getDownloadURL();
            debugPrint("Download URL in web music: $downloadUrl");
            musicURL = downloadUrl;

            final artistName = _artistNameController.text;
            final musicName = _musicNameController.text;
            final writerName = _writerNameController.text;
            final producerName = _producerNameController.text;
            final recordLabel = _recordLabelController.text;
            final yearOfProduction = _yearOfProductionController.text;
            final youtubeLink = _youtubeLinkController.text;
            final instagramLink = _instagramLinkController.text;
            final facebookLink = _facebookLinkController.text;
            final tikTokLink = _tikTokLinkController.text;
            print('tis is title id $titleUUID');

            final ref = _database.ref('AllMusic').child(titleUUID);
            final User? user = _auth.currentUser;
            final String? uid = user?.uid;

            var data = {
              'userId': uid,
              'songId': titleUUID,
              'artistName': artistName,
              'songName': musicName,
              'writer': writerName,
              'producerName': producerName,
              'recordLabel': recordLabel,
              'yearOfProduction': yearOfProduction,
              'youtubeLink': youtubeLink,
              'instagramLink': instagramLink,
              'facebookLink': facebookLink,
              'tikTokLink': tikTokLink,
              'albumArtUrl': artWorkURL,
              'audioUrl': musicURL,
              'dollorIconVisiblity': dollarIcon,
              'fireIconVisiblity': fireIcon
            };
            print('data uploading web $data');
            ref.set(data);
            final noti_ref = _database.ref('AllNotification').child(titleUUID);
            noti_ref.set({
              'userId': uid,
              'songId': titleUUID,
              'userProfilePicture':
                  UserProfileData().profileData['profilePicture'] ?? '',
              'app': 'Artist',
              'notification':
                  '${UserProfileData().profileData['name'] ?? user?.displayName ?? ''} Uploaded A new Song',
              'artistName': artistName,
              'songName': musicName,
              'writer': writerName,
              'producerName': producerName,
              'recordLabel': recordLabel,
              'yearOfProduction': yearOfProduction,
              'youtubeLink': youtubeLink,
              'instagramLink': instagramLink,
              'facebookLink': facebookLink,
              'tikTokLink': tikTokLink,
              'albumArtUrl': artWorkURL,
              'audioUrl': musicURL,
            });

            Fluttertoast.showToast(
              msg: "Upload Music Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
            clearSongData();
            setState(() {
              isLoading = false;
            });
            break;
        }
      });
    } else {
      File file = _audioFile!;
      final storageRef = FirebaseStorage.instance.ref();

      final musicRef = storageRef.child(
          'music/$titleUUID'); // Include the file name in the storage path

      // final musicRef = storageRef.child('music/}');
      final uploadTask = musicRef.putFile(file);

      // Listen for upload progress and completion
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            debugPrint("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            setState(() {
              isLoading = false;
            });
            debugPrint("Upload is paused.");
            break;
          case TaskState.canceled:
            setState(() {
              isLoading = false;
            });
            debugPrint("Upload was canceled");
            break;
          case TaskState.error:
            setState(() {
              isLoading = false;
            });
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            final downloadUrl = await taskSnapshot.ref.getDownloadURL();
            debugPrint("Download URL: $downloadUrl");
            musicURL = downloadUrl;
            // Handle successful uploads
            debugPrint("Music uploaded successfully!");

            final artistName = _artistNameController.text;
            final musicName = _musicNameController.text;
            final writerName = _writerNameController.text;
            final producerName = _producerNameController.text;
            final recordLabel = _recordLabelController.text;
            final yearOfProduction = _yearOfProductionController.text;
            final youtubeLink = _youtubeLinkController.text;
            final instagramLink = _instagramLinkController.text;
            final facebookLink = _facebookLinkController.text;
            final tikTokLink = _tikTokLinkController.text;

            final ref = _database.ref('AllMusic').child(titleUUID);
            final User? user = _auth.currentUser;
            final String? uid = user?.uid;
            ref.set({
              'userId': uid,
              'songId': titleUUID,
              'artistName': artistName,
              'songName': musicName,
              'writer': writerName,
              'producerName': producerName,
              'recordLabel': recordLabel,
              'yearOfProduction': yearOfProduction,
              'youtubeLink': youtubeLink,
              'instagramLink': instagramLink,
              'facebookLink': facebookLink,
              'tikTokLink': tikTokLink,
              'albumArtUrl': artWorkURL,
              'audioUrl': musicURL,
              'dollorIconVisiblity': dollarIcon,
              'fireIconVisiblity': fireIcon
            });
            final noti_ref = _database.ref('AllNotification').child(titleUUID);
            noti_ref.set({
              'userId': uid,
              'songId': titleUUID,
              'userProfilePicture':
                  UserProfileData().profileData['profilePicture'] ?? '',
              'app': 'Artist',
              'notification':
                  '${UserProfileData().profileData['name'] ?? user?.displayName ?? ''} Uploaded A new Song',
              'artistName': artistName,
              'songName': musicName,
              'writer': writerName,
              'producerName': producerName,
              'recordLabel': recordLabel,
              'yearOfProduction': yearOfProduction,
              'youtubeLink': youtubeLink,
              'instagramLink': instagramLink,
              'facebookLink': facebookLink,
              'tikTokLink': tikTokLink,
              'albumArtUrl': artWorkURL,
              'audioUrl': musicURL,
            });

            Fluttertoast.showToast(
              msg: "Upload Music Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
            clearSongData();
            setState(() {
              isLoading = false;
            });
            break;
        }
      });
    }
  }

  Stream<PositionData> get _positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  Future<File> convertBytesToFile(Uint8List fileBytes, String fileName) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(fileBytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141118),
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  bottom: 30, left: 15, right: 15, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20),

                  _buildProfileField("assets/musician-svgrepo-com.png",
                      "Artist Name", "", _artistNameController),

                  _buildProfileField("assets/audio-svgrepo-com.png",
                      "Music Name", "", _musicNameController),
                  _buildProfileField(
                      "assets/writing-hand-skin-5-svgrepo-com.png",
                      "Writer Name",
                      "",
                      _writerNameController),

                  _buildProfileField("assets/mixer-music-6-svgrepo-com.png",
                      "Producer Name", "", _producerNameController),

                  _buildProfileField("assets/icons8-music-record-94.png",
                      "Record Label", "", _recordLabelController),

                  _buildProfileField(
                      "assets/calendar-date-time-2-svgrepo-com.png",
                      "Production Year",
                      "",
                      _yearOfProductionController),

                  _buildProfileField("assets/social-3434840_1280.png",
                      "Youtube Link", "", _youtubeLinkController),

                  _buildProfileField("assets/instagram-3814080_1280.png",
                      "Instagram Link", "", _instagramLinkController),

                  _buildProfileField("assets/facebook-1924510_1280.png",
                      "Facebook Link", "", _facebookLinkController),

                  _buildProfileField("assets/tiktok-6338429_1280.png",
                      "TikTok Link", "", _tikTokLinkController),

                  _buildDropdown('DOLLAR SIGN', 'assets/money.png',
                      val: dollarIcon ? "Visible" : "Invisible", onChange: (v) {
                    setState(() {
                      dollarIcon = v ?? false;
                    });
                  }),
                  _buildDropdown('FIRE SIGN', 'assets/fire_icon.png',
                      val: fireIcon ? "Visible" : "Invisible", onChange: (v) {
                    setState(() {
                      fireIcon = v ?? false;
                    });
                  }),

                  // const SizedBox(height: 20),
                  // Upload Audio Button
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child:  ElevatedButton(
                  //           onPressed: () {
                  //             // _uploadFiles();
                  //             _storeSongDetails();
                  //             // Handle audio upload
                  //           },
                  //           style: ElevatedButton.styleFrom(
                  //             backgroundColor: yellowColor,
                  //             foregroundColor: Colors.black,
                  //             padding: const EdgeInsets.symmetric(vertical: 15),
                  //             textStyle: const TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(5),
                  //             ),
                  //           ),
                  //           child: const Text('UPLOAD SONG TO SNAPMUG'),
                  //         ),
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(width: Get.width / 10),
          Container(
            width: Get.width / 2,
            padding: EdgeInsets.only(right: Get.width / 14),
            child: Column(
              children: [
                updateUsernameAndImage(),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    // border: Border.all(color: yellowColor)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        musicLoading
                            ? const AppLoader()
                            : GestureDetector(
                                onTap: () async {
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles(type: FileType.audio);
                                  setState(() {
                                    musicLoading = true;
                                  });
                                  if (result != null) {
                                    debugPrint("picked");
                                    debugPrint(result.toString());

                                    if (kIsWeb) {
                                      // fileBytesMusic = result.files.first.bytes;
                                      debugPrint("Web running");
                                      try {
                                        fileBytesMusic =
                                            result.files.first.bytes;
                                        musicFileName = result.files.first.name;
                                        _audioPlayer.setWebCrossOrigin(
                                            WebCrossOrigin.useCredentials);
                                        final blob = html.Blob(
                                            fileBytesMusic as List,
                                            'audio/mp3');
                                        final url =
                                            html.Url.createObjectUrlFromBlob(
                                                blob);
                                        print('this is url $url');
                                        final audioSource =
                                            AudioSource.uri(Uri.parse(url));
                                        _audioPlayer
                                            .setAudioSource(audioSource);
                                        _audioPlayer.play();
                                        setState(() {
                                          // isPlaying = true;
                                          musicLoading = false;
                                        });
                                        debugPrint(
                                            'Playing audio from bytes... $fileBytesMusic');
                                      } catch (e) {
                                        setState(() {
                                          // isPlaying = true;
                                          musicLoading = false;
                                        });
                                        debugPrint(
                                            'Error playing audio from bytes: $e');
                                      }
                                    } else {
                                      _audioFile =
                                          File(result.files.single.path!);
                                      duration = await _audioPlayer
                                          .setFilePath(_audioFile!.path);
                                      _audioPlayer.play();
                                      setState(() {
                                        isPlaying = true;
                                      });
                                      debugPrint('playing...');
                                    }
                                  } else {
                                    debugPrint("not picked");
                                    setState(() {
                                      musicLoading = false;
                                    });
                                  }
                                },
                                child: Container(
                                  width: Get.width / 5,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: yellowColor)),
                                  child: const Center(
                                    child: Text(
                                      'SELECT AUDIO',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                )),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_audioFile != null) {
                                      if (isPlaying) {
                                        _audioPlayer.pause();
                                        isPlaying = false;
                                      } else {
                                        _audioPlayer.play();
                                        isPlaying = true;
                                      }
                                      setState(() {});
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      color: const Color(0xFF141118),
                                      child: Icon(
                                        isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                StreamBuilder<PositionData>(
                                  stream: _positionDataStream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data;
                                    return SeekBar(
                                      duration: positionData?.duration ??
                                          Duration.zero,
                                      position: positionData?.position ??
                                          Duration.zero,
                                      bufferedPosition:
                                          positionData?.bufferedPosition ??
                                              Duration.zero,
                                      showTimes: false,
                                      onChangeEnd: (duration) {
                                        _audioPlayer.seek(duration);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            musicFileName.isNotEmpty
                                ? Text(
                                    musicFileName,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(height: 50),
                const Spacer(),
                isLoading
                    ? const AppLoader()
                    : GestureDetector(
                        onTap: () {
                          _storeSongDetails();
                        },
                        child: CircleAvatar(
                          radius:
                              30, // Set the radius to half the width/height of your desired circle size
                          backgroundColor: Colors
                              .yellow, // Set the background color of the circle to yellow
                          child: Image.asset(
                            'assets/noun-upload-6840889.png',
                            width: 48, // Set the width of the image
                            height: 48, // Set the height of the image
                            color: Colors
                                .black, // Set the color of the image to black
                          ),
                        ),
                      ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool dollarIcon = true;
  bool fireIcon = true;

  // Helper function to build dropdown menus
  Widget _buildDropdown(String label, String imagePath,
      {Function(bool?)? onChange, String val = 'Visible'}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: yellowColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Image.asset(
                    imagePath,
                    width: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: 50,
              ),
            ],
          ),
          Container(
            width: Get.width / 5,
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(
                  color: yellowColor), // Set the border color to yellow
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: DropdownButton<String>(
              underline: const SizedBox(),
              isExpanded: true,
              style: TextStyle(color: yellowColor),
              items: const [
                DropdownMenuItem(
                    value: 'Visible',
                    child: Text(
                      'Visible',
                      // style: TextStyle(color: yellowColor),
                    )),
                DropdownMenuItem(
                    value: 'Invisible',
                    child: Text(
                      'Invisible',
                      // style: TextStyle(color: yellowColor),
                    )),
              ],
              value: val,
              onChanged: (value) {
                onChange!(value == "Visible");
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isLoading = false;
  Future<void> _storeSongDetails() async {
    titleUUID = generateRandomId(30);
    if (GetPlatform.isWeb) {
      if (fileBytesArtwork == null) {
        appToast('Please select the music file');
        return;
      }
      if (fileBytesMusic == null) {
        appToast('Please select the Album Image');
        return;
      }
    } else {
      if (_audioFile == null) {
        appToast('Please select the music file');
        return;
      }
      if (_albumImageFile == null) {
        appToast('Please select the Album Image');
        return;
      }
    }
    if (_artistNameController.text.isEmpty ||
        _musicNameController.text.isEmpty ||
        _writerNameController.text.isEmpty ||
        _producerNameController.text.isEmpty ||
        _recordLabelController.text.isEmpty ||
        _yearOfProductionController.text.isEmpty) {
      appToast('Please add all required fields');
      return;
    }

    setState(() {
      isLoading = true;
    });
    _uploadArtwork();
  }

  Widget _buildProfileField(String imagePath, String label, String hint,
      TextEditingController controller) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Container(
      width: screenWidth,
      height: 35,
      margin: const EdgeInsets.only(bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
              const SizedBox(
                width: 50,
              ),
            ],
          ),
          SizedBox(
            width: Get.width / 5,
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
                // label: SizedBox(
                //   width: 130,
                //   child: Row(
                //     children: [
                //
                //     ],
                //   ),
                // ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: yellowColor), // Set the border color to yellow
                  borderRadius:
                      BorderRadius.circular(10), // Set the border radius
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors
                          .yellow), // Set the border color to yellow for enabled state
                  borderRadius:
                      BorderRadius.circular(10), // Set the border radius
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors
                          .yellow), // Set the border color to yellow for focused state
                  borderRadius:
                      BorderRadius.circular(10), // Set the border radius
                ),
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget updateUsernameAndImage() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              _audioPlayer.stop();
              isPlaying = false;
              setState(() {});
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(type: FileType.image);
              if (result != null) {
                debugPrint("picked ::::::::::: ${result.toString()}");
                if (kIsWeb) {
                  if (result != null && result.files.isNotEmpty) {
                    setState(() {
                      fileBytesArtwork = result.files.first.bytes;
                    });
                  }
                } else {
                  debugPrint("running in normal device");
                  // NOT running on the web! You can check for additional platforms here.
                  File file = File(result.files.single.path!);
                  _albumImageFile = file;
                }
              } else {
                debugPrint("not picked");
              }
              setState(() {});
            },
            child: SizedBox(
              width: screenWidth / 5,
              height: 30,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: yellowColor)),
                child: const Center(
                  child: Text(
                    'SELECT ARTWORK',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () async {
              _audioPlayer.stop();
              isPlaying = false;
              setState(() {});
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(type: FileType.image);
              if (result != null) {
                if (kIsWeb) {
                  if (result.files.isNotEmpty) {
                    fileBytesArtwork = result.files.first.bytes;
                    setState(() {});
                  }
                  debugPrint("picked ::::::::::: ${fileBytesArtwork}");
                } else {
                  File file = File(result.files.single.path!);
                  _albumImageFile = file;
                  setState(() {});
                }
              } else {
                debugPrint("not picked");
                // User canceled the picker
              }
            },
            child: Container(
              width: 150,
              height: 150,
              child: DottedBorder(
                  dashPattern: const [2, 5],
                  radius: const Radius.circular(30),
                  color: yellowColor,
                  strokeWidth: 1,
                  child: fileBytesArtwork != null
                      ? Image.memory(
                          fileBytesArtwork!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, s, a) {
                            return const Center(child: Icon(Icons.error));
                          },
                        )
                      : Image.network(
                          profileImageURL,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, a, b) {
                            return const Icon(Icons.add);
                          },
                        )
                  // Image(
                  //                 width: 150,
                  //                 height: 150,
                  //                 image: _albumImageFile == null
                  //                     ? NetworkImage(profileImageURL)
                  //                     : FileImage(_albumImageFile!) as ImageProvider<Object>,
                  //                 fit: BoxFit.cover,
                  //               )
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
