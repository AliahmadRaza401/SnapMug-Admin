import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:snapmug_for_admins/EditMusicv2.dart';
import 'package:snapmug_for_admins/pages/promotion_begin.dart';
import 'package:snapmug_for_admins/splash_screen.dart';

import '../SignIn.dart';

class MyMusicBottom extends StatefulWidget {
  const MyMusicBottom({super.key});

  @override
  State<MyMusicBottom> createState() => _MyMusicBottomState();
}

class _MyMusicBottomState extends State<MyMusicBottom> {
  Map<String, Map<String, dynamic>> songTitles = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  bool isLoading = false;

  Future<void> fetchDataFromFirebase() async {
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
        setState(() {
          isLoading = false;
        });

        // player.play();
        // duration = duration!;
        // isPlaying = true; // Update _isPlaying state to true
      } else {
        // Handle the case where no data is found (optional)
        setState(() {
          isLoading = false;
        });
        print("No data found in the 'AllMusic' node");
      }
      // Update the UI with fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF141118),
        body: isLoading
            ? const AppLoader()
            : Column(
                children: [
                  // Container(
                  //   width: double.infinity,
                  //   alignment: Alignment.topLeft,
                  //   margin: EdgeInsets.all(10),
                  //   height: 100,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(30),
                  //       border: Border.all(color: Colors.white)),
                  //   child: Padding(
                  //       padding: EdgeInsets.all(20),
                  //       child: Text(
                  //         "Uthman Music",
                  //         style: TextStyle(color: Colors.yellow),
                  //       )),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      color: const Color(0xFF141118),
                      child: ListView.separated(
                        itemCount: songTitles.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 0, // or a very small value like 1
                          color: Color(0xFF141118),
                        ),
                        itemBuilder: (context, index) {
                          final songKey = songTitles.keys.elementAt(index);
                          final songData = songTitles[songKey]!;
                          print('image :::::: ${songData['albumArtUrl']}');
                          return ListTile(
                            leading: SizedBox(
                              width: 50,
                              height: 55,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      width: 50,
                                      height: 55,
                                      imageUrl: songData['albumArtUrl'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                              child: Icon(Icons.error)),
                                    ),
                                    // Dollar Icon
                                    if (songData['dollorIconVisiblity'] ??
                                        false)
                                      Positioned(
                                        left: -5,
                                        top: -4,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
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
                            onTap: () {},
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (songData['fireIconVisiblity'] ?? false)
                                  Image.asset(
                                    'assets/fire_icon.png',
                                    height: 20,
                                  ),
                                const SizedBox(
                                  width: 10,
                                ),
                                PopupMenuButton(
                                  child: const Icon(
                                    Icons.more_vert_outlined,
                                    color: Colors.white,
                                  ),
                                  onSelected: (value) {
                                    // if (value == 'delete') {
                                    // } else if (value == 'edit') {
                                    //   // edit song logic here
                                    //   print('Edit song');
                                    // }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: const Text('Delete'),
                                      onTap: () {
                                        _deleteSong(
                                            songData['songId'],
                                            songData['albumArtUrl'],
                                            songData['audioUrl']);
                                      },
                                    ),
                                    // PopupMenuItem(
                                    //   value: 'edit',
                                    //   child: const Text('Edit'),
                                    //   onTap: () {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             EditMusicBottom(
                                    //           artistName:
                                    //               songData['artistName'] ?? '',
                                    //           albumArtUrl:
                                    //               songData['albumArtUrl'] ?? '',
                                    //           audioUrl:
                                    //               songData['audioUrl'] ?? '',
                                    //           dollorIconVisiblity: songData[
                                    //                   'dollorIconVisiblity'] ??
                                    //               false,
                                    //           facebookLink:
                                    //               songData['facebookLink'] ??
                                    //                   '',
                                    //           facebookUshes:
                                    //               songData['facebookUshes'] ??
                                    //                   '',
                                    //           fireIconVisiblity: songData[
                                    //                   'fireIconVisiblity'] ??
                                    //               false,
                                    //           instagramLink:
                                    //               songData['instagramLink'] ??
                                    //                   '',
                                    //           instagramUshes:
                                    //               songData['instagramUshes'] ??
                                    //                   '',
                                    //           producerName:
                                    //               songData['producerName'] ??
                                    //                   '',
                                    //           recordLabel:
                                    //               songData['recordLabel'] ?? '',
                                    //           songId: songData['songId'] ?? '',
                                    //           songName:
                                    //               songData['songName'] ?? '',
                                    //           tikTokLink:
                                    //               songData['tikTokLink'] ?? '',
                                    //           tikTokUshes:
                                    //               songData['tikTokUshes'] ?? '',
                                    //           writer: songData['writer'] ?? '',
                                    //           yearOfProduction: songData[
                                    //                   'yearOfProduction'] ??
                                    //               '',
                                    //           youtubeLink:
                                    //               songData['youtubeLink'] ?? '',
                                    //           youtubeUshes:
                                    //               songData['youtubeUshes'] ??
                                    //                   '',
                                    //         ),
                                    //       ),
                                    //     );
                                    //   },
                                    // ),
                                  ],
                                ),
                              ],
                            ),

                            title: Text(songData['songName'],
                                style: const TextStyle(
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
              ));
  }

  void _navigateToPromotionBegin(BuildContext context,
      Map<String, dynamic> songData, String promotionType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PromotionBegin(
          songName: songData['songName'],
          albumArtUrl: songData['albumArtUrl'],
          songId: songData['songId'],
          artistName: songData['artistName'],
          facebookLink: songData['facebookLink'],
          instagramLink: songData['instagramLink'],
          youtubeLink: songData['youtubeLink'],
          tikTokLink: songData['tikTokLink'],
          promotionType: promotionType,
        ),
      ),
    );
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

  void deleteFireBaseStorageItem(String fileUrl) {
    String filePath = fileUrl.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/snapmugflutter.appspot.com/o/'),
        '');

    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');

    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

    final storageReferance = FirebaseStorage.instance.ref();

    storageReferance.child(filePath).delete().then((_) {
      fetchDataFromFirebase();
      print('Successfully deleted $filePath storage item');
    });
  }
}
