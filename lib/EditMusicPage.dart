import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditMusicPage extends StatefulWidget {
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

  const EditMusicPage({
    required this.artistName,
    required this.albumArtUrl,
    required this.audioUrl,
    required this.dollorIconVisiblity,
    required this.facebookLink,
    required this.facebookUshes,
    required this.fireIconVisiblity,
    required this.instagramLink,
    required this.instagramUshes,
    required this.producerName,
    required this.recordLabel,
    required this.songId,
    required this.songName,
    required this.tikTokLink,
    required this.tikTokUshes,
    required this.writer,
    required this.yearOfProduction,
    required this.youtubeLink,
    required this.youtubeUshes,
    super.key,
  });

  @override
  State<EditMusicPage> createState() => _EditMusicPageState();
}

class _EditMusicPageState extends State<EditMusicPage> {
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
  }

  String? _selectedAlbumImage;
  String? _selectedAudio;

  File? _albumImageFile;
  File? _audioFile;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> _uploadArtwork(File file) async {
    final storageRef = FirebaseStorage.instance.ref();
    // final fileName =
    // 'your_desired_file_name.jpg'; // Specify the desired file name here
    final artworkRef = storageRef.child(
        'artwork/$titleUUID'); // Include the file name in the storage path
    final uploadTask = artworkRef.putFile(file);

    // Listen for upload progress and completion
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
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
          _uploadMusic(_audioFile!);

          break;
      }
    });
  }

  Future<void> _uploadMusic(File file) async {
    final storageRef = FirebaseStorage.instance.ref();
    final fileName =
        'your_desired_file_name.jpg'; // Specify the desired file name here
    final musicRef = storageRef
        .child('music/$titleUUID'); // Include the file name in the storage path

    // final musicRef = storageRef.child('music/}');
    final uploadTask = musicRef.putFile(file);

    // Listen for upload progress and completion
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141118),
      appBar: AppBar(
        title: const Text(
          "Update Song",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            // Album Art Image
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 150,
              decoration: BoxDecoration(
                image: _selectedAlbumImage != null
                    ? DecorationImage(
                        image: AssetImage(_selectedAlbumImage!),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/app_icon.png'),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 10),
            // Image Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _selectedAlbumImage != null
                    ? 'Selected Image Name: ${_selectedAlbumImage}'
                    : 'Selected Image Name',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            // Select Album Image Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    _albumImageFile = file;

                    // _uploadArtwork(file);
                  } else {
                    // User canceled the picker
                  }
                  // Handle image selection
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'SELECT ALBUM ARTWORK',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Audio Layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedAudio != null
                          ? 'Selected Music Track Name: ${_selectedAudio}'
                          : 'Selected Music Track Name',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  // Play Audio Button
                  Visibility(
                    visible: _selectedAudio != null,
                    child: IconButton(
                      onPressed: () async {
                        // Handle audio playback
                      },
                      icon: const Icon(Icons.play_arrow_rounded),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Select Audio Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File file = File(result.files.single.path!);
                    _audioFile = file;

                    // print(file);
                    // _uploadMusic(file);
                  } else {
                    // User canceled the picker
                  }

                  // Handle audio selection
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'SELECT AUDIO / MUSIC',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Text Fields
            _buildTextField("Artist Name", _artistNameController),
            _buildTextField("Music Name", _musicNameController),
            _buildTextField("Writer Name", _writerNameController),
            _buildTextField("Producer Name", _producerNameController),
            _buildTextField("Record Label", _recordLabelController),
            _buildTextField("Year Of Production", _yearOfProductionController),
            _buildTextField("Youtube Link", _youtubeLinkController),
            _buildTextField("Instagram Link", _instagramLinkController),
            _buildTextField("Facebook Link", _facebookLinkController),
            _buildTextField("TikTok Link", _tikTokLinkController),
            // _buildNumberField("Youtube Ushes", _youtubeUsesController),
            // _buildNumberField("Instagram Ushes", _instagramUsesController),
            // _buildNumberField("Facebook Ushes", _facebookUsesController),
            // _buildNumberField("TikTok Ushes", _tikTokUsesController),

            // Dropdown Menus
            // _buildDropdown("Fire Icon Visibility"),
            // _buildDropdown("Dollar Icon Visibility"),

            const SizedBox(height: 20),
            // Upload Audio Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // _uploadFiles();
                  _updateSongDetails(widget.songId);
                  // Handle audio upload
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text('UPDATE SONG'),
              ),
            ),
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

  Future<void> _updateSongDetails(String songId) async {
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
    final youtubeUses = _youtubeUsesController.text;
    final instagramUses = _instagramUsesController.text;
    final facebookUses = _facebookUsesController.text;
    final tikTokUses = _tikTokUsesController.text;

    final ref = _database.ref('AllMusic').child(songId);

    if (_albumImageFile != null && _audioFile != null) {
      _uploadArtwork(_albumImageFile!);
    } else {
      print("one of it is null");
      // Handle error: no files selected
    }
    print("updating");

    ref.update({
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
    });
  }
}

//when button is hitted you just have to upload files to storage and get it's links then exec above fxn to store all info in the AllMusic list and done!
