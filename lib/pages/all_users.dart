import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:snapmug_for_admins/EditMusicPage.dart';
import 'package:snapmug_for_admins/EditProfilePage.dart';
import 'package:snapmug_for_admins/edit_specific_profile.dart';
import 'package:snapmug_for_admins/pages/edit_artist_profile.dart';
import 'package:snapmug_for_admins/pages/promotion_begin.dart';

import '../SignIn.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  Map<String, Map<String, dynamic>> songTitles = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  List<UserProfile> usersList = [];
  bool isLoading = false;

  Future<void> getUserData() async {
    try {
      setState(() {
        isLoading = true;
      });
      usersList.clear();
      final database = FirebaseDatabase.instance.ref().child('AllUsers');
      debugPrint("fetching done $database");
      database.once().then((DatabaseEvent event) async {
        final DataSnapshot snapshot = event.snapshot;

        if (snapshot.value != null) {
          final songMap = snapshot.value as Map<dynamic, dynamic>;
          debugPrint('data length ${songMap.length}');
          songMap.forEach((key, value) {
            if (value is Map) {
              UserProfile data = UserProfile.fromMap(value);
              usersList.add(data);
            }
          });
          setState(() {
            isLoading = false;
          });
        } else {
          debugPrint("No data found in the 'AllMusic' node");
          setState(() {
            isLoading = false;
          });
        }
      });
      debugPrint('total length of user $usersList');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('error in users $e');
    }
  }

  Future<void> _deleteUser(String userId, String profileUrl) async {
    print('deleting the artis $userId ::::::: $profileUrl');
    if (userId.isEmpty) {
      appToast('No user id available');
    }

    try {
      final songRef = _database.ref('AllUsers').child(userId);
      print('deleting ref $songRef');
      await songRef.remove();
      deleteFireBaseStorageItem(profileUrl);
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
        getUserData();
      });
    } else {
      getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF141118),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: yellowColor,
                ),
              )
            : usersList.isEmpty
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
                          childAspectRatio: 4,
                        ),
                        itemCount: usersList.length,
                        itemBuilder: (context, index) {
                          UserProfile data = usersList[index];
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
                                    SizedBox(
                                      width: 50,
                                      height: 100,
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: yellowColor,
                                            radius: 100,
                                            backgroundImage: NetworkImage(
                                              data.profilePicture.isEmpty
                                                  ? 'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg'
                                                  // ? 'https://firebasestorage.googleapis.com/v0/b/snapmugflutter.appspot.com/o/users%2F5zZHTX35lwTKQWoVFWrfMCPjxmS2?alt=media&token=c8cb5499-f89a-481b-b4eb-06dd42570bae'
                                                  : data.profilePicture,
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
                                                  child: const Text('Delete'),
                                                  onTap: () {
                                                    _deleteUser(data.userId,
                                                        data.profilePicture);
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
                                                            EditSpecificProfileScreen(
                                                                id: data
                                                                    .userId),
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
                                    Text(data.name,
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

  void _navigateToPromotionBegin(BuildContext context,
      Map<String, dynamic> UsersData, String promotionType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PromotionBegin(
          songName: UsersData['songName'],
          albumArtUrl: UsersData['albumArtUrl'],
          songId: UsersData['songId'],
          artistName: UsersData['UserName'],
          facebookLink: UsersData['facebookLink'],
          instagramLink: UsersData['instagramLink'],
          youtubeLink: UsersData['youtubeLink'],
          tikTokLink: UsersData['tikTokLink'],
          promotionType: promotionType,
        ),
      ),
    );
  }
}

class UserProfile {
  final String name;
  final String email;
  final String earning;
  final String country;
  final String password;
  final String mobileMoneyNumber;
  final String profilePicture;
  final String tikTok;
  final String mobileMoneyName;
  final String mobileNumber;
  final String facebook;
  final String youTube;
  final String instagram;
  final String userId;
  final String userName;
  final Map<String, Challenge>
      challenges; // Each challenge is identified by a unique key

  UserProfile({
    required this.name,
    required this.email,
    required this.earning,
    required this.country,
    required this.mobileMoneyNumber,
    required this.profilePicture,
    required this.password,
    required this.tikTok,
    required this.mobileMoneyName,
    required this.mobileNumber,
    required this.facebook,
    required this.youTube,
    required this.instagram,
    required this.userName,
    required this.userId,
    required this.challenges,
  });

  // Factory method to create a UserProfile instance from a map
  factory UserProfile.fromMap(Map<dynamic, dynamic> map) {
    final challengesMap = map['Challanges'] as Map<dynamic, dynamic>? ?? {};
    final challenges = challengesMap.map((key, value) {
      return MapEntry(
          key as String, Challenge.fromMap(value as Map<dynamic, dynamic>));
    });

    return UserProfile(
      name:
          map['name'] == null || map['name'] == '' ? 'Usre Name' : map['name'],
      email: map['email'] ?? '',
      password: (map['password'] ?? '').toString(),
      userName: map['userName'] ?? 'User Name Here',
      country: map['country'] ?? '',
      earning: map['earning'] ?? '',
      mobileMoneyNumber: map['mobileMoneyNumber'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      tikTok: map['tikTok'] ?? '',
      mobileMoneyName: map['mobileMoneyName'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      facebook: map['facebook'] ?? '',
      youTube: map['youTube'] ?? '',
      instagram: map['instagram'] ?? '',
      userId: map['userId'] ?? '',
      challenges: challenges,
    );
  }

  // Method to convert a UserProfile instance to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'earning': earning,
      'password': password,
      'country': country,
      'mobileMoneyNumber': mobileMoneyNumber,
      'profilePicture': profilePicture,
      'tikTok': tikTok,
      'mobileMoneyName': mobileMoneyName,
      'mobileNumber': mobileNumber,
      'facebook': facebook,
      'youTube': youTube,
      'instagram': instagram,
      'userId': userId,
      'userName': userName,
      'Challanges':
          challenges.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}

class Challenge {
  final String songId;
  final int execTime;
  final String songName;
  final String userProfileUsername;
  final String songUrl;
  final String userId;
  final String platform;
  final String status;

  Challenge({
    required this.songId,
    required this.execTime,
    required this.songName,
    required this.userProfileUsername,
    required this.songUrl,
    required this.userId,
    required this.platform,
    required this.status,
  });

  // Factory method to create a Challenge instance from a map
  factory Challenge.fromMap(Map<dynamic, dynamic> map) {
    return Challenge(
      songId: map['song_id'] ?? '',
      execTime: map['exec_time'] ?? 0,
      songName: map['song_name'] ?? '',
      userProfileUsername: map['user_profile_username'] ?? '',
      songUrl: map['song_url'] ?? '',
      userId: map['userId'] ?? '',
      platform: map['platform'] ?? '',
      status: map['status'] ?? '',
    );
  }

  // Method to convert a Challenge instance to a map
  Map<String, dynamic> toMap() {
    return {
      'song_id': songId,
      'exec_time': execTime,
      'song_name': songName,
      'user_profile_username': userProfileUsername,
      'song_url': songUrl,
      'userId': userId,
      'platform': platform,
      'status': status,
    };
  }
}
