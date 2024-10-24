
import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_audio/just_audio.dart';
import 'package:snapmug_for_admins/pages/customTrack.dart';
import 'package:uuid/uuid.dart';

class EditMusicBottom extends StatefulWidget {
  const EditMusicBottom(
    {super.key
    , required this.artistName, required this.albumArtUrl, required this.audioUrl, required this.dollorIconVisiblity, required this.facebookLink, required this.facebookUshes, required this.fireIconVisiblity, required this.instagramLink, required this.instagramUshes, required this.producerName, required this.recordLabel, required this.songId, required this.songName, required this.tikTokLink, required this.tikTokUshes, required this.writer, required this.yearOfProduction, required this.youtubeLink, required this.youtubeUshes
    }
    );
    final String artistName;
  final String albumArtUrl;
  final String audioUrl;
  final bool dollorIconVisiblity;
  final String facebookLink;
  final String facebookUshes;
  final bool fireIconVisiblity;
  final String instagramLink;
  final String instagramUshes;
  final String producerName;
  final String recordLabel;
  final String songId;
  final String songName;
  final String tikTokLink;
  final String tikTokUshes;
  final String writer;
  final String yearOfProduction;
  final String youtubeLink;
  final String youtubeUshes;

  @override
  State<EditMusicBottom> createState() => _EditMusicBottomState();
}

class _EditMusicBottomState extends State<EditMusicBottom> {
  bool _isChecked = false;
  bool _isCheckedTrending = false;
  bool isPlaying = false;
  FilePickerResult? result;
  String profileImageURL =
      'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration position = Duration.zero;
  final player = AudioPlayer();

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
  bool fireIconVisiblity = false;

  @override
  void initState() {
    super.initState();
    _artistNameController.text = widget.artistName;
    _musicNameController.text = widget.songName;
    _writerNameController.text = widget.writer;
    _producerNameController.text = widget.producerName;
    _recordLabelController.text = widget.recordLabel;
    _yearOfProductionController.text = widget.yearOfProduction;
    _youtubeLinkController.text = widget.youtubeLink;
    _instagramLinkController.text = widget.instagramLink;
    _facebookLinkController.text = widget.facebookLink;
    _tikTokLinkController.text = widget.tikTokLink;
    _youtubeUsesController.text = widget.youtubeUshes;
    _instagramUsesController.text = widget.instagramUshes;
    _facebookUsesController.text = widget.facebookUshes;
    _tikTokUsesController.text = widget.tikTokUshes;
    setState(() {
    _isCheckedTrending = fireIconVisiblity;
    });

  }

  Duration? duration = Duration(seconds: 10);
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

  String? _selectedAlbumImage;
  String? _selectedAudio;

  File? _albumImageFile;
  File? _audioFile;

  Uint8List? fileBytesMusic;
  Uint8List? fileBytesArtwork;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> _uploadArtwork() async {
    if (kIsWeb) {
      final storageRef = FirebaseStorage.instance.ref();

      final musicRef = storageRef.child(
          'music/$titleUUID'); // Include the file name in the storage path

      // final musicRef = storageRef.child('music/}');
      final uploadTask = musicRef.putData(fileBytesMusic!);

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
            musicURL = downloadUrl;
            // Handle successful uploads
            print("Music uploaded successfully!");
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
            // Handle successful uploads
            print("Artwork uploaded successfully!");
            final downloadUrl = await taskSnapshot.ref.getDownloadURL();
            print("Download URL: $downloadUrl");

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
            musicURL = downloadUrl;
            // Handle successful uploads
            print("Music uploaded successfully!");
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
            musicURL = downloadUrl;
            // Handle successful uploads
            print("Music uploaded successfully!");

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
            // final youtubeUses = _youtubeUsesController.text;
            // final instagramUses = _instagramUsesController.text;
            // final facebookUses = _facebookUsesController.text;
            // final tikTokUses = _tikTokUsesController.text;

            final ref = _database.ref('AllMusic').child(titleUUID);

            final User? user = _auth.currentUser;
            final String? uid = user?.uid;
            print(_isCheckedTrending );
            print(_isCheckedTrending );

            ref.update({
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
              // 'youtubeUshes': youtubeUses,
              // 'instagramUshes': instagramUses,
              // 'facebookUshes': facebookUses,
              // 'tikTokUshes': tikTokUses,
              'albumArtUrl': artWorkURL,
              'audioUrl': musicURL,
              'dollorIconVisiblity': dollorIconVisiblity,
              'fireIconVisiblity': _isCheckedTrending,
            });
            break;
        }
      });
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141118),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          SizedBox(height: 100,),

            const SizedBox(height: 20),
            // Album Art Image
            // Image Title
            updateUsernameAndImage(),

            // const SizedBox(height: 10),
            // // Select Album Image Button
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: GestureDetector(
            //     onTap: () async {
            //       FilePickerResult? result =
            //           await FilePicker.platform.pickFiles();
            //       if (result != null) {
            //         print("picked");
            //         print(result);
            //         print("asdfasdfasdfasdfasdfasdf");

            //         if (kIsWeb) {
            //           fileBytesArtwork = result.files.first.bytes;

            //           // running on the web!
            //           // _albumImageFile = fileBytes;
            //           print("Web running");
            //         } else {
            //           print("rinning in normal device");
            //           // NOT running on the web! You can check for additional platforms here.
            //           File file = File(result.files.single.path!);
            //           _albumImageFile = file;
            //         }
            //       } else {
            //         print("not picked");

            //         // User canceled the picker
            //       }
            //     },
            //     child: Row(
            //       children: [
            //         Container(
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(10),
            //               border: Border.all(color: Colors.yellow)),
            //           child: Text(
            //             'SELECT ARTWORK',
            //             style: TextStyle(color: Colors.white),
            //           ),
            //         ),

            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10),
            // Audio Layout
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Expanded(
            //         child: Text(
            //           _selectedAudio != null
            //               ? 'Selected Music Track Name: ${_selectedAudio}'
            //               : 'Selected Music Track Name',
            //           style: const TextStyle(fontSize: 16, color: Colors.white),
            //         ),
            //       ),
            //       // Play Audio Button
            //       Visibility(
            //         visible: _selectedAudio != null,
            //         child: IconButton(
            //           onPressed: () async {
            //             // Handle audio playback
            //           },
            //           icon: const Icon(Icons.play_arrow_rounded),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 10),
            // Select Audio Button
            GestureDetector(
              onTap: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  print("picked");
                  print(result);

                  if (kIsWeb) {
                    fileBytesMusic = result.files.first.bytes;
                    // running on the web!
                    // _albumImageFile = fileBytes;
                    print("Web running");
                  } else {
                    print("rinning in normal device");
                    print('hello 2');
                    // NOT running on the web! You can check for additional platforms here.
                    _audioFile = File(result.files.single.path!);
                    // _audioFile = file;
                    // File file = File(result.files.single.path!);
                    // _albumImageFile = file;
                    // print(file.path);
                    // await _audioPlayer.setFilePath(file.path);
                    // _audioPlayer.play();

                    // print('path : ${file.path}');
                    duration = await player.setFilePath(_audioFile!.path);
                    player.play();
                    print('playing...');
                  }
                } else {
                  print("not picked");
                  // User canceled the picker
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.yellow)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'SELECT AUDIO',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (isPlaying) {
                              player.pause();
                              isPlaying = false;
                            } else {
                              player.play();
                              isPlaying = true;
                            }
                            setState(() {});
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: 20,
                              height: 20,
                              color: Color(0xFF141118),
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
                        SizedBox(
                          width: 10,
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 6),
                            trackShape: CustomTrackShape(),
                          ),
                          child: Container(
                            // width: 200,
                            height:
                                24, // Adjust the height to fit the slider without extra padding
                            alignment: Alignment.center,
                            child: Slider(
                              activeColor: Colors.yellow,
                              thumbColor: Colors.yellow,
                              inactiveColor: Colors.grey,
                              value: position.inSeconds.toDouble(),
                              min: 0,
                              max: duration!.inSeconds.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  final seconds = value.toInt();
                                  position = Duration(seconds: seconds);
                                });
                              },
                              onChangeEnd: (value) {
                                final seconds = value.toInt();
                                player.seek(Duration(seconds: seconds));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Text Fields

            _buildProfileField("assets/musician-svgrepo-com.png", "Artist Name",
                "", _artistNameController),
            SizedBox(
              height: 10,
            ),
            _buildProfileField("assets/audio-svgrepo-com.png", "Music Name", "",
                _musicNameController),
            SizedBox(
              height: 10,
            ),

            _buildProfileField("assets/writing-hand-skin-5-svgrepo-com.png",
                "Writer Name", "", _writerNameController),
            SizedBox(
              height: 10,
            ),
            _buildProfileField("assets/mixer-music-6-svgrepo-com.png",
                "Producer Name", "", _producerNameController),
            SizedBox(
              height: 10,
            ),
            _buildProfileField("assets/icons8-music-record-94.png",
                "Record Label", "", _recordLabelController),
            SizedBox(
              height: 10,
            ),
            _buildProfileField("assets/calendar-date-time-2-svgrepo-com.png",
                "Year Of Production", "", _yearOfProductionController),
            SizedBox(
              height: 10,
            ),
            _buildProfileField("assets/social-3434840_1280.png", "Youtube Link",
                "", _youtubeLinkController),
            SizedBox(
              height: 10,
            ),
            _buildProfileField("assets/instagram-3814080_1280.png",
                "Instagram Link", "", _instagramLinkController),
            SizedBox(
              height: 10,
            ),
            _buildProfileField("assets/facebook-1924510_1280.png",
                "Facebook Link", "", _facebookLinkController),
            SizedBox(
              height: 10,
            ),
            _buildProfileField("assets/tiktok-6338429_1280.png", "TikTok Link",
                "", _tikTokLinkController),
            Row(
              children: [
                Checkbox(
                  value: _isCheckedTrending ,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCheckedTrending  = value!;
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Is this song trending?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // _buildCheckboxField('is fire?', _hotController),

            SizedBox(
              height: 10,
            ),

            Row(
              children: [
                GestureDetector(
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
                      color:
                          Colors.black, // Set the color of the image to black
                    ),
                  ),
                ),
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              ' I Confirm That I Read & Fully Understood The ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'Agreement,',
                          style: TextStyle(color: Colors.yellow),
                        ),
                        TextSpan(
                          text:
                              ' and hereby voluntarily grant license to Work Smart LLC',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // _buildNumberField("Youtube Ushes", _youtubeUsesController),
            // _buildNumberField("Instagram Ushes", _instagramUsesController),
            // _buildNumberField("Facebook Ushes", _facebookUsesController),
            // _buildNumberField("TikTok Ushes", _tikTokUsesController),

            // Dropdown Menus
            // _buildDropdown("Fire Icon Visibility"),
            // _buildDropdown("Dollar Icon Visibility"),

            const SizedBox(height: 20),
            // Upload Audio Button
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // _uploadFiles();
            //       _storeSongDetails();
            //       // Handle audio upload
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.yellow,
            //       foregroundColor: Colors.black,
            //       padding: const EdgeInsets.symmetric(vertical: 15),
            //       textStyle: const TextStyle(
            //         fontSize: 18,
            //         fontWeight: FontWeight.bold,
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(5),
            //       ),
            //     ),
            //     child: const Text('UPLOAD SONG TO SNAPMUG'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white), // Set text color to white
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.white), // Set hint text color to white
        ),
      ),
    );
  }

  Widget _buildNumberField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white), // Set text color to white
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.white), // Set hint text color to white
        ),
      ),
    );
  }

  // Helper function to build dropdown menus
  Widget _buildDropdown(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.white), // Set hint text color to white
        ),
        items: const [
          DropdownMenuItem(
              value: 'Visible',
              child: Text(
                'Visible',
                style: TextStyle(color: Colors.white),
              )),
          DropdownMenuItem(
              value: 'Hidden',
              child: Text(
                'Hidden',
                style: TextStyle(color: Colors.white),
              )),
        ],
        onChanged: (value) {
          // Handle dropdown selection
        },
      ),
    );
  }

  Widget _buildProfileField(String imagePath, String label, String hint,
      TextEditingController controller) {
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
              width: 25,
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
                    color: Colors.yellow), // Set the border color to yellow
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
Widget _buildCheckboxField(TextEditingController controller, String text) {
  bool isChecked = false; // initial state of the checkbox

  return CheckboxListTile(
    title: Text(text, style: TextStyle(color: Colors.white),),
    value: isChecked,
    onChanged: (bool? newValue) {
      isChecked = newValue ?? false;
      controller.text = isChecked ? "Checked" : "Unchecked"; // update the controller with the new state
    },
    controlAffinity: ListTileControlAffinity.leading, // places the checkbox at the start of the tile
  );
}

  Widget updateUsernameAndImage() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    // File? _albumImageFile;
    Uint8List? fileBytesArtwork;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              // result = await FilePicker.platform.pickFiles();
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                print("picked");
                print(result);
                print("asdfasdfasdfasdfasdfasdf");

                if (kIsWeb) {
                  fileBytesArtwork = result.files.first.bytes;

                  // running on the web!
                  // _albumImageFile = fileBytes;
                  print("Web running");
                } else {
                  print("rinning in normal device");
                  // NOT running on the web! You can check for additional platforms here.
                  File file = File(result.files.single.path!);
                  _albumImageFile = file;
                  print('hello');
                }
              } else {
                print("not picked");

                // User canceled the picker
              }
            },
            child: SizedBox(
              width: screenWidth / 2.5,
              height: 30,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.yellow)),
                child: const Text(
                  'SELECT ARTWORK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              // result = await FilePicker.platform.pickFiles();
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                print("picked");
                print(result);
                print("asdfasdfasdfasdfasdfasdf");

                if (kIsWeb) {
                  fileBytesArtwork = result.files.first.bytes;

                  // running on the web!
                  // _albumImageFile = fileBytes;
                  print("Web running");
                } else {
                  print("rinning in normal device");
                  // NOT running on the web! You can check for additional platforms here.
                  File file = File(result.files.single.path!);
                  _albumImageFile = file;
                  print('hello');
                }
              } else {
                print("not picked");
                // User canceled the picker
              }
            },
            child: Container(
              width: 150,
              height: 150,
              child: DottedBorder(
                  dashPattern: [2, 5],
                  radius: Radius.circular(30),
                  color: Colors.yellow,
                  strokeWidth: 1,
                  child: Image(
                    image: NetworkImage(profileImageURL),
                  )
                  // Image.asset(
                  //   'assets/musician-svgrepo-com.png',
                  //   width: 150,
                  //   height: 150,
                  // )
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build dropdown menus

  Future<void> _storeSongDetails() async {
    final uuid = Uuid();
    final randomChildKey = uuid.v4(); // This generates a version 4 UUID
    titleUUID = widget.songId;
    final User? user = _auth.currentUser;
    final String? uid = user?.uid;
    print("Stronig data into db");
    if (kIsWeb) {
      print("its web");
      // await FirebaseStorage.instance.ref('artwork/$titleUUID').putData(fileBytes!);
      final storageRef = FirebaseStorage.instance.ref();

      final musicRef = storageRef.child(
          'music/$titleUUID'); // Include the file name in the storage path

      // final musicRef = storageRef.child('music/}');
      final uploadTask = musicRef.putData(fileBytesMusic!);

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
            musicURL = downloadUrl;
            // Handle successful uploads
            print("Music uploaded successfully!");
            break;
        }
      });

      final artworkref = storageRef.child(
          'artwork/$titleUUID'); // Include the file name in the storage path
// Create metadata
      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/png', // Set the content type to mp3
      );

      // final musicRef = storageRef.child('music/}');
      final uploadTaskArtwork = artworkref.putData(fileBytesArtwork!, metadata);

      uploadTaskArtwork.snapshotEvents
          .listen((TaskSnapshot taskSnapshot) async {
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
            musicURL = downloadUrl;
            // Handle successful uploads
            print("Music uploaded successfully!");
            break;
        }
      });
    } else {
      print('its mobile');
      print(_albumImageFile?.path);
      print(_audioFile?.path);
      if (_albumImageFile != null && _audioFile != null) {
        _uploadArtwork();
      } else {
         final ref = _database.ref('AllMusic').child(titleUUID);

            final User? user = _auth.currentUser;
            final String? uid = user?.uid;
            print(_isCheckedTrending );
            print(_isCheckedTrending );

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


            ref.update({
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
              // 'youtubeUshes': youtubeUses,
              // 'instagramUshes': instagramUses,
              // 'facebookUshes': facebookUses,
              // 'tikTokUshes': tikTokUses,
              // 'albumArtUrl': artWorkURL,
              // 'audioUrl': musicURL,
              'dollorIconVisiblity': dollorIconVisiblity,
              'fireIconVisiblity': _isCheckedTrending,
            });
        print("one of it is null");
      }
    }
    print("SEtting REF>>>>>>>");
  }
}
