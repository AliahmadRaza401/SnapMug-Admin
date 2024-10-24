import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapmug_for_admins/pages/verification_widget.dart';

import '../SignIn.dart';
import '../globals.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<Map<dynamic,dynamic>> artistList = [];
  bool isLoading = false;
  Future<void> getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final database = FirebaseDatabase.instance.ref().child('AllArtists');
      database.once().then((DatabaseEvent event) async {
        final DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          final songMap = snapshot.value as Map<dynamic, dynamic>;
          artistList.clear();
          songMap.forEach((key, value) {
            if(value['isVerified']==false && value['isRejected']==false){
            artistList.add(value);
            }
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
        : artistList.isEmpty
            ? const Center(
                child: Text(
                  'No data',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
            : Container(
                color: Colors.transparent,
                alignment: Alignment.topLeft,
                width: Get.width ,
                height: Get.height ,
                   padding: const EdgeInsets.only(left: 10,right: 10),
                child: ListView.builder(
                    itemCount: artistList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Map<dynamic,dynamic> artData = artistList[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 10,bottom: 10,top: 10),
                        width: Get.width/4,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(40),
                         border: Border.all( color: Colors.yellow,)
                       ),
                        padding: const EdgeInsets.all(20),
                        child: VerificationWidget(data: artData,updated: (v){
                          if(v){
                            getData();
                          }
                        },),
                      );
                    }),
              );
  }
}


