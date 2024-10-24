import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../SignIn.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  List<NotificationModel> notificationList = [];
  bool isLoading = false;
  Future<void> getNotifications() async {
    try {
      setState(() {
        isLoading = true;
      });
      final database = FirebaseDatabase.instance.ref().child('AllNotification');
      database.once().then((DatabaseEvent event) async {
        final DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          final songMap = snapshot.value as Map<dynamic, dynamic>;
          songMap.forEach((key, value) {
            print('this is the data $value');
            notificationList.add(NotificationModel.fromMap(value));
          });

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

      // Update the UI with fetched data
    } catch (e) {
      debugPrint('error gettuing nitification $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(backgroundColor: yellowColor),
          )
        : notificationList.isEmpty
            ? const Center(
                child: Text(
                  'No data',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
            : Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                    itemCount: notificationList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      NotificationModel notData = notificationList[index];
                      return Container(
                        width: Get.width,
                        // margin:
                        //     const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            // color: yellowColor,
                            // border: Border.all(color: const Color(0xff979797)),
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Colors.grey),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        notData.userProfilePicture,
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notData.app,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  notData.notification,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      );
                    }),
              );
  }
}

class NotificationModel {
  final String albumArtUrl;
  final String app;
  final String artistName;
  final String audioUrl;
  final String facebookLink;
  final String instagramLink;
  final String notification;
  final String producerName;
  final String recordLabel;
  final String songId;
  final String songName;
  final String tikTokLink;
  final String userId;
  final String userProfilePicture;
  final String writer;
  final String yearOfProduction;
  final String youtubeLink;

  NotificationModel({
    required this.albumArtUrl,
    required this.app,
    required this.artistName,
    required this.audioUrl,
    required this.facebookLink,
    required this.instagramLink,
    required this.notification,
    required this.producerName,
    required this.recordLabel,
    required this.songId,
    required this.songName,
    required this.tikTokLink,
    required this.userId,
    required this.userProfilePicture,
    required this.writer,
    required this.yearOfProduction,
    required this.youtubeLink,
  });

  // Factory method to create a Song instance from a map
  factory NotificationModel.fromMap(Map<dynamic, dynamic> map) {
    return NotificationModel(
      albumArtUrl: map['albumArtUrl'] ??
          'https://firebasestorage.googleapis.com/v0/b/snapmug-54ade.appspot.com/o/tmpp%2Fwell.jpeg?alt=media&token=1749d61b-734b-4739-b9e1-e5daefcbb500',
      app: map['app'] ?? '',
      artistName: map['artistName'] ?? '',
      audioUrl: map['audioUrl'] ?? '',
      facebookLink: map['facebookLink'] ?? '',
      instagramLink: map['instagramLink'] ?? '',
      notification: map['notification'] ?? '',
      producerName: map['producerName'] ?? '',
      recordLabel: map['recordLabel'] ?? '',
      songId: map['songId'] ?? '',
      songName: map['songName'] ?? '',
      tikTokLink: map['tikTokLink'] ?? '',
      userId: map['userId'] ?? '',
      userProfilePicture: map['userProfilePicture'] ?? '',
      writer: map['writer'] ?? '',
      yearOfProduction: (map['yearOfProduction'] ?? '').toString(),
      youtubeLink: map['youtubeLink'] ?? '',
    );
  }

  // Method to convert a Song instance to a map
  Map<String, dynamic> toMap() {
    return {
      'albumArtUrl': albumArtUrl,
      'app': app,
      'artistName': artistName,
      'audioUrl': audioUrl,
      'facebookLink': facebookLink,
      'instagramLink': instagramLink,
      'notification': notification,
      'producerName': producerName,
      'recordLabel': recordLabel,
      'songId': songId,
      'songName': songName,
      'tikTokLink': tikTokLink,
      'userId': userId,
      'userProfilePicture': userProfilePicture,
      'writer': writer,
      'yearOfProduction': yearOfProduction,
      'youtubeLink': youtubeLink,
    };
  }
}
