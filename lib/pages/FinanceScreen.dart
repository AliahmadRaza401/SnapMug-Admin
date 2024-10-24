import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../SignIn.dart';
import '../SignUp.dart';
import '../globals.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  @override
  void initState() {
    getFinanceData();
    super.initState();
  }

  List<FinanceModel> notificationList = [];
  bool isLoading = false;
  Future<void> getFinanceData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final database = FirebaseDatabase.instance.ref().child('WithdrawalAndPayments');
      database.once().then((DatabaseEvent event) async {
        final DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          final songMap = snapshot.value as Map<dynamic, dynamic>;
          songMap.forEach((key, value) {
            print('this is the finance data $value');
            notificationList.add(FinanceModel.fromMap(value));
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
  TextEditingController paidTotalController=TextEditingController();
  TextEditingController requestedTotalController=TextEditingController();
  TextEditingController withdrawalTotalController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(backgroundColor: yellowColor),
          )
        :notificationList.isEmpty
        ? const Center(
            child: Text(
              'No data',
              style: TextStyle(
                  color: Colors.white, fontSize: 10),
            ),
          )
        : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                    itemCount: notificationList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      FinanceModel notData = notificationList[index];
                      return Container(
                        width: Get.width,
                        // margin:
                        //     const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            // color: yellowColor,
                            // border: Border.all(color: const Color(0xff979797)),
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
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
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width:  Get.width/3,
                margin: const EdgeInsets.only(bottom: 20,right: 20,left: 20),
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20,top: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    appTextField(
                        context, 'PAID TOTAL', 'PAID TOTAL', paidTotalController,
                     ),
                    appTextField(context, 'REQUESTED TOTAL', 'REQUESTED TOTAL',
                        requestedTotalController,
                       ),
                    appTextField(context, 'WITHDRAWAL TOTAL', 'WITHDRAWAL TOTAL',
                        requestedTotalController,
                       ),

                  ],
                ),
              ),
            )
          ],
        );
  }
}

class FinanceModel {
  final String albumArtUrl;
  final String app;
  final String id;
  final String notification;
  final String songName;
  final String type;
  final String userId;
  final String userProfilePicture;

  FinanceModel({
    required this.albumArtUrl,
    required this.app,
    required this.id,
    required this.notification,
    required this.songName,
    required this.type,
    required this.userId,
    required this.userProfilePicture,
  });

  // fromMap factory constructor
  factory FinanceModel.fromMap(Map<dynamic, dynamic> map) {
    return FinanceModel(
      albumArtUrl: map['albumArtUrl'] ?? '',
      app: map['app'] ?? '',
      id: (map['id'] ?? '').toString(),
      notification: map['notification'] ?? '',
      songName: map['songName'] ?? '',
      type: map['type'] ?? '',
      userId: (map['userId'] ?? '').toString(),
      userProfilePicture: (map['userProfilePicture'] ?? '').toString(),
    );
  }
}

