import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:snapmug_for_admins/EditMusicPage.dart';
import 'package:snapmug_for_admins/SignIn.dart';
import 'package:snapmug_for_admins/edit_specific_profile.dart';
import 'package:snapmug_for_admins/pages/edit_artist_profile.dart';
import 'package:snapmug_for_admins/pages/promotion_begin.dart';
import 'package:snapmug_for_admins/splash_screen.dart';

class AllArtists extends StatefulWidget {
  const AllArtists({super.key});

  @override
  State<AllArtists> createState() => _AllArtistsState();
}

class _AllArtistsState extends State<AllArtists> {
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
    setState(() {
      isLoading = true;
    });

    final User? user = _auth.currentUser;
    final String? uid = user?.uid;
    songTitles.clear();
    final database = FirebaseDatabase.instance.ref().child('AllArtists');
    database.once().then((DatabaseEvent event) async {
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final songMap = snapshot.value as Map<dynamic, dynamic>;
        songMap.forEach((key, value) {
          Map<String, dynamic> artistsData = {
            'email': value['email'] ?? '',
            'name': value['name'] ?? '',
            'userId': value['userId'] ?? '',
            'profilePicture': value['profilePicture'] ??
                'https://firebasestorage.googleapis.com/v0/b/snapmugflutter.appspot.com/o/users%2F5zZHTX35lwTKQWoVFWrfMCPjxmS2?alt=media&token=c8cb5499-f89a-481b-b4eb-06dd42570bae',
          };
          songTitles[key] = artistsData;
        });
        print("feeding done $songTitles");
        setState(() {
          isLoading = false;
        });

        // player.play();
        // duration = duration!;
        // isPlaying = true; // Update _isPlaying state to true
      } else {
        setState(() {
          isLoading = false;
        });
        // Handle the case where no data is found (optional)
        print("No data found in the 'AllMusic' node");
      }
      // Update the UI with fetched data
    });
  }

  Future<void> _deleteArtist(String userId, String profileUrl,
      {String key = ''}) async {
    print('deleting the artis $userId ::::::: $profileUrl');

    try {
      final songRef = _database.ref('AllArtists').child(userId);
      print('deleting ref $songRef');

      await songRef.remove();
      deleteFireBaseStorageItem(profileUrl);
      songTitles.remove(key);
      setState(() {});
      debugPrint('Song deleted successfully');
    } catch (error) {
      debugPrint('Error deleting song: $error');
      // Handle error
    }
  }

  void deleteFireBaseStorageItem(String fileUrl) {
    if (fileUrl.isNotEmpty) {
      String filePath = fileUrl.replaceAll(
          new RegExp(
              r'https://firebasestorage.googleapis.com/v0/b/snapmugflutter.appspot.com/o/'),
          '');

      filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');

      filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

      final storageReferance = FirebaseStorage.instance.ref();

      storageReferance.child(filePath).delete().then((_) {
        fetchDataFromFirebase();
      });
    } else {
      fetchDataFromFirebase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF141118),
        body: isLoading
            ? const AppLoader()
            : songTitles.isEmpty
                ? const Center(
                    child: Text(
                      'No data',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      color: const Color(0xFF141118),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5, // Number of columns in the grid
                          crossAxisSpacing: 10, // Space between columns
                          mainAxisSpacing: 10, // Space between rows
                          childAspectRatio:
                              4, // Adjust this to control the height of each tile
                        ),
                        itemCount: songTitles.length,
                        itemBuilder: (context, index) {
                          final songKey = songTitles.keys.elementAt(index);
                          final artistsData = songTitles[songKey]!;
                          return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: yellowColor, // Border color
                                  width: 2, // Border width
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      // color: Colors.yellow,
                                      width: 50,
                                      height: 100,
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: yellowColor,
                                            radius: 100,
                                            backgroundImage: NetworkImage(
                                              artistsData['profilePicture'],
                                            ),
                                          ),
                                          Positioned(
                                            right: 2,
                                            top: 10,
                                            child: PopupMenuButton(
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/settings-25-512.png'),
                                                width: 20,
                                              ),
                                              onSelected: (value) {
                                                // if (value == 'delete') {
                                                //   _deleteArtist(artistsData['userId'],
                                                //       artistsData['profilePicture']);
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
                                                    _deleteArtist(
                                                        artistsData['userId'],
                                                        artistsData[
                                                                'profilePicture'] ??
                                                            '',
                                                        key: songKey);
                                                  },
                                                ),
                                                PopupMenuItem(
                                                  value: 'edit',
                                                  child: const Text('Edit'),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditArtistProfile(
                                                                id: artistsData[
                                                                    'userId']),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                        artistsData['name'] == null ||
                                                artistsData['name'] == ''
                                            ? 'Artist Name'
                                            : artistsData['name'],
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ],
                                )

                                /*ListTile(
                        leading: SizedBox(
                          width: 55,
                          height: 55,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Stack(
                              children: [

                              ],
                            ),
                          ),
                        ),
                        onTap: () {},
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 5),
                            PopupMenuButton(
                              child: Image(
                                image:
                                    AssetImage('assets/settings-25-512.png'),
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
                                    print(artistsData['songId']);
                                    _deleteSong(
                                        artistsData['songId'],
                                        artistsData['albumArtUrl'],
                                        artistsData['audioUrl']);
                                  },
                                ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditSpecificProfileScreen(
                                                email: artistsData['email'],
                                                aidi: songKey),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        title: Text(
                            artistsData['name'] == null ||
                                    artistsData['name'] == ''
                                ? 'Artist Name'
                                : artistsData['name'],
                            style: const TextStyle(
                                color: Colors.white)), // Display song name
                        // subtitle: Text(artistsData['email'] ?? '',
                        //     style: TextStyle(
                        //         color:
                        //             Colors.grey[400])), // Display artist name
                      )*/
                                ,
                              ));
                        },
                      ),
                    ),
                  ));
  }
}
