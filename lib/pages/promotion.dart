import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapmug_for_admins/SignIn.dart';
import '../EditMusicPage.dart';
Color parrotColor = const Color(0xff26ff26);
class PromotionBottom extends StatefulWidget {
  const PromotionBottom({super.key});

  @override
  State<PromotionBottom> createState() => _PromotionBottomState();
}

class _PromotionBottomState extends State<PromotionBottom> {
  Map<String, Map<String, dynamic>> songTitles = {};
  Map<String, Map<String, dynamic>> AllTitles = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool ShowForwardRocket = false;
  bool ShowForwardBoat = false;
  bool ShowForwardCar = false;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void initState() {
    print('=============x  init state');
    super.initState();
    print('=============x super init state');
    print('=============x playing');
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    print("fetching from firebase");

    await Firebase.initializeApp();
    final User? user = _auth.currentUser;
    final String? uid = user?.uid;
    print(uid);
    // Reference to the "AllMusic" node

    // final database = FirebaseDatabase.instance.reference().child('AllMusic');
    final database =
        FirebaseDatabase.instance.reference().child('AllPromotions');
    // .orderByChild('userId') // Order by the 'userid' field
    // .equalTo(uid); // Filter for children with 'userid' equal to "abcdxyz"

    print("fetching done");
    // Read song titles from the database
    database.once().then((DatabaseEvent event) async {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final songMap = snapshot.value as Map<dynamic, dynamic>;
        songMap.forEach((key, value) {
          Map<String, dynamic> songData = {
            'artistName': value['artistName'],
            'albumArtUrl': value['albumArtUrl'],
            'audioUrl': value['audioUrl'],
            'dollorIconVisiblity': value['dollorIconVisiblity'],
            'facebookLink': value['facebookLink'],
            'facebookUshes': value['facebookUshes'],
            'fireIconVisiblity': value['fireIconVisiblity'],
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
            'promotionType': value['promotionType'],
          };
          songTitles[key] = songData;
          AllTitles[key] = songData;
        });

        // if (songTitles.isNotEmpty) {
        final firstSongKey = songTitles.keys.first;
        final firstSongData = songTitles[firstSongKey]!;
        final audioUrl = firstSongData['audioUrl'];
        print("feeding done");
        // print(firstSongData);
        // print(firstSongData['audioUrl']);

        // duration = (await player.setUrl(audioUrl))!;
        // print('duration: $duration');
        setState(() {});

        // player.play();
        // duration = duration!;
        // isPlaying = true; // Update _isPlaying state to true
      } else {
        // Handle the case where no data is found (optional)
        print("No data found in the 'AllMusic' node");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF141118),
        body: Expanded(
          // height: Get.height,
          child: Padding(
            padding: const EdgeInsets.only(bottom:10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/boat-9-512.png',
                        height: 50,
                        color: parrotColor,
                      ),
                      const SizedBox(height: 10,),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(horizontal:15),
                          decoration: BoxDecoration(
                              border: Border.all(color: yellowColor),
                              borderRadius: BorderRadius.circular(50)),
                          child: ListView.separated(
                            itemCount: songTitles.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => const Divider(
                              height: 0, // or a very small value like 1
                              color: Color(0xFF141118),
                            ),
                            itemBuilder: (context, index) {
                              final songKey = songTitles.keys.elementAt(index);
                              final songData = songTitles[songKey]!;
                              return songData['promotionType'] != 'boat'?SizedBox.shrink(): ListTile(
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
                                          imageUrl:songData['albumArtUrl']??
                                              'https://firebasestorage.googleapis.com/v0/b/snapmug-54ade.appspot.com/o/tmpp%2Fwell.jpeg?alt=media&token=1749d61b-734b-4739-b9e1-e5daefcbb500',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        // Dollar Icon
                                        if (songData['dollorIconVisiblity'] ??
                                            false)
                                          Positioned(
                                            left: -5,
                                            top: -4,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(
                                                  6.0), // Adjust the padding as needed
                                              child: const Icon(
                                                Icons.attach_money_rounded,
                                                color: Colors.yellow,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  print(songData['promotionType']);
                                  // trackLoading = true;
                                  // playAudio(songData['audioUrl']);
                                  // globals.playingSongIconURL = songData['albumArtUrl'];
                                  // print(globals.playingSongIconURL);
                                  // setState(() {
                                  //   globals.playingSongTitle = songData['songName'];
                                  // });
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (songData['promotionType'] == 'boat')
                                      Image(
                                        image:
                                            AssetImage('assets/boat-9-512.png'),
                                        color: parrotColor,
                                        width: 20,
                                      ),
                                    if (songData['promotionType'] == 'car')
                                      Image(
                                        image: AssetImage(
                                            'assets/car-25-512 (1).png'),
                                        color: parrotColor,

                                        width: 20,
                                      ),
                                    if (songData['promotionType'] == 'rocket')
                                      Image(
                                        image:
                                            AssetImage('assets/rocket-512.png'),
                                        color: parrotColor,

                                        width: 20,
                                      ),
                                  ],
                                ),
                                title: Text(songData['songName'],
                                    style: TextStyle(
                                        color: Colors.white)), // Display song name
                                subtitle: Text(songData['artistName'],
                                    style: TextStyle(
                                        color: yellowColor)), // Display artist name
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/car-25-512 (1).png',
                        height: 50,
                        color: parrotColor,
                      ),
                      SizedBox(height: 10,),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(horizontal:15),
                          decoration: BoxDecoration(
                              border: Border.all(color: yellowColor),
                              borderRadius: BorderRadius.circular(50)),
                          child: ListView.separated(
                            itemCount: songTitles.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => const Divider(
                              height: 0, // or a very small value like 1
                              color: Color(0xFF141118),
                            ),
                            itemBuilder: (context, index) {
                              final songKey = songTitles.keys.elementAt(index);
                              final songData = songTitles[songKey]!;
                              return songData['promotionType'] != 'car'?SizedBox.shrink(): ListTile(
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
                                          imageUrl:songData['albumArtUrl']??
                                              'https://firebasestorage.googleapis.com/v0/b/snapmug-54ade.appspot.com/o/tmpp%2Fwell.jpeg?alt=media&token=1749d61b-734b-4739-b9e1-e5daefcbb500',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                        // Dollar Icon
                                        if (songData['dollorIconVisiblity'] ??
                                            false)
                                          Positioned(
                                            left: -5,
                                            top: -4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(
                                                  6.0), // Adjust the padding as needed
                                              child: Icon(
                                                Icons.attach_money_rounded,
                                                color: Colors.yellow,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  print(songData['promotionType']);
                                  // trackLoading = true;
                                  // playAudio(songData['audioUrl']);
                                  // globals.playingSongIconURL = songData['albumArtUrl'];
                                  // print(globals.playingSongIconURL);
                                  // setState(() {
                                  //   globals.playingSongTitle = songData['songName'];
                                  // });
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (songData['promotionType'] == 'boat')
                                      Image(
                                        image:
                                            AssetImage('assets/boat-9-512.png'),
                                        color: parrotColor,
                                        width: 20,
                                      ),
                                    if (songData['promotionType'] == 'car')
                                      Image(
                                        image: AssetImage(
                                            'assets/car-25-512 (1).png'),
                                        color: parrotColor,

                                        width: 20,
                                      ),
                                    if (songData['promotionType'] == 'rocket')
                                      Image(
                                        image:
                                            AssetImage('assets/rocket-512.png'),
                                        color: parrotColor,

                                        width: 20,
                                      ),
                                  ],
                                ),
                                title: Text(songData['songName'],
                                    style: TextStyle(
                                        color: Colors.white)), // Display song name
                                subtitle: Text(songData['artistName'],
                                    style: TextStyle(
                                        color: yellowColor)), // Display artist name
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/rocket-512.png',
                        height: 50,
                        color: parrotColor,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(horizontal:15),
                          decoration: BoxDecoration(
                              border: Border.all(color: yellowColor),
                              borderRadius: BorderRadius.circular(50)),
                          child: ListView.separated(
                            itemCount: songTitles.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => const Divider(
                              height: 0, // or a very small value like 1
                              color: Color(0xFF141118),
                            ),
                            itemBuilder: (context, index) {
                              final songKey = songTitles.keys.elementAt(index);
                              final songData = songTitles[songKey]!;
                              return songData['promotionType'] != 'rocket'?SizedBox.shrink(): ListTile(
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
                                          imageUrl: songData['albumArtUrl']??
                                          'https://firebasestorage.googleapis.com/v0/b/snapmug-54ade.appspot.com/o/tmpp%2Fwell.jpeg?alt=media&token=1749d61b-734b-4739-b9e1-e5daefcbb500',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Center(
                                              child:
                                              CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                        // Dollar Icon
                                        if (songData['dollorIconVisiblity'] ??
                                            false)
                                          Positioned(
                                            left: -5,
                                            top: -4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(
                                                  6.0), // Adjust the padding as needed
                                              child: Icon(
                                                Icons.attach_money_rounded,
                                                color: Colors.yellow,
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  print(songData['promotionType']);
                                  // trackLoading = true;
                                  // playAudio(songData['audioUrl']);
                                  // globals.playingSongIconURL = songData['albumArtUrl'];
                                  // print(globals.playingSongIconURL);
                                  // setState(() {
                                  //   globals.playingSongTitle = songData['songName'];
                                  // });
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (songData['promotionType'] == 'boat')
                                      Image(
                                        image:
                                        AssetImage('assets/boat-9-512.png'),
                                        color: parrotColor,
                                        width: 20,
                                      ),
                                    if (songData['promotionType'] == 'car')
                                      Image(
                                        image: AssetImage(
                                            'assets/car-25-512 (1).png'),
                                        color: parrotColor,

                                        width: 20,
                                      ),
                                    if (songData['promotionType'] == 'rocket')
                                      Image(
                                        image:
                                        AssetImage('assets/rocket-512.png'),
                                        color: parrotColor,

                                        width: 20,
                                      ),
                                  ],
                                ),
                                title: Text(songData['songName'],
                                    style: TextStyle(
                                        color: Colors.white)), // Display song name
                                subtitle: Text(songData['artistName'],
                                    style: TextStyle(
                                        color: yellowColor)), // Display artist name
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _deleteSong(
      String songId, String artWorkUrl, String musicURL) async {
    try {
      print(songId);
      print(artWorkUrl);
      print(musicURL);
      // Get a reference to the specific song node
      final songRef = _database.ref('AllPromotions').child(songId);

      // Remove the song data from the database
      await songRef.remove();

      deleteFireBaseStorageItem(artWorkUrl);
      deleteFireBaseStorageItem(musicURL);

      print('Song deleted successfully');
    } catch (error) {
      print('Error deleting song: $error');
      // Handle error
    }
  }

  static void deleteFireBaseStorageItem(String fileUrl) {
    String filePath = fileUrl.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/snapmugflutter.appspot.com/o/'),
        '');

    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');

    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

    final storageReferance = FirebaseStorage.instance.ref();

    storageReferance
        .child(filePath)
        .delete()
        .then((_) => print('Successfully deleted $filePath storage item'));
  }
}
