import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class PromotionBegin extends StatefulWidget {
  final String albumArtUrl;
  final String songId;
  final String facebookLink;
  final String instagramLink;
  final String youtubeLink;
  final String tikTokLink;
  final String songName;
  final String promotionType;
  final String artistName;

  const PromotionBegin({
    super.key,
    required this.albumArtUrl,
    required this.songId,
    required this.facebookLink,
    required this.instagramLink,
    required this.youtubeLink,
    required this.tikTokLink,
    required this.promotionType,
    required this.songName,
    required this.artistName,
  });

  @override
  State<PromotionBegin> createState() => _PromotionBeginState();
}

class _PromotionBeginState extends State<PromotionBegin> {
  @override
  void initState() {
    super.initState();
    print('widgets : ${widget.songId}');
    print("globals.profileImageURL:${globals.profileImageURL}");
  }

  @override
  Widget build(BuildContext context) {
    String imageAsset;
    switch (widget.promotionType) {
      case 'rocket':
        imageAsset = 'assets/rocket-512.png';
        break;
      case 'car':
        imageAsset = 'assets/car-25-512 (1).png';
        break;
      case 'boat':
        imageAsset = 'assets/boat-9-512.png';
        break;
      default:
        imageAsset = 'assets/boat-9-512.png'; // Optional default image
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0), // Add 10 pixels of space
          child: Container(
            child: Image.asset('assets/SnapMug For Artists Logo.png'),
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Image(
          //       image: AssetImage('assets/notii.png'),
          //       width: 20,
          //       color: Colors.yellow),
          //   onPressed: () {
          //     if (isLoggedin) {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => SignInActivity(),
          //         ),
          //       );
          //     }
          //     // Add your action here
          //   },
          // ),
          IconButton(
            icon: Container(
              width: 50, // Adjust the width as needed
              height: 50, // Adjust the height as needed
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.yellow, width: 2), // Yellow border
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      globals.profileImageURL,
                      fit: BoxFit.cover,
                    ),
                    // child: ClipOval(
                    // child: Image(
                    // image: NetworkImage(profileImageURL),

                    // AssetImage('assets/musician-svgrepo-com.png'),
                    // width: double.infinity, // Adjust the width as needed
                    // height: double.infinity, // Adjust the height as needed
                    // fit: BoxFit.fill,
                    // ),
                    // ),
                  ),
                  Positioned(
                    right: 7,
                    top: 6,
                    child: Image(
                      image: AssetImage('assets/settings-25-512.png'),
                      width: 15, // Adjust the width as needed
                      height: 15, // Adjust the height as needed
                    ),
                  ),
                ],
              ),
            ),
            color: Colors.yellow,
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imageAsset, width: 50, height: 50),
                const SizedBox(width: 10),
                Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)),
                    child: Image(
                      image: NetworkImage(widget.albumArtUrl),
                      width: 200,
                      height: 200,
                    )),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            _buildPromotionField('assets/tiktok-6338429_1280.png',
                widget.songId, widget.tikTokLink),
            SizedBox(
              height: 20,
            ),
            _buildPromotionField('assets/social-3434840_1280.png',
                widget.songId, widget.youtubeLink),
            SizedBox(
              height: 20,
            ),
            _buildPromotionField(
                'assets/instagram.png', widget.songId, widget.instagramLink),
            SizedBox(
              height: 20,
            ),
            _buildPromotionField('assets/facebook-1924510_1280.png',
                widget.songId, widget.facebookLink),
            SizedBox(
              height: 20,
            ),
            _buildAllPromotionField(widget.songId),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            // boxShadow: [
            // BoxShadow(color: Colors.yellow, spreadRadius: 0, blurRadius: 10),
            // ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: Colors.yellow,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Colors.yellow,
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(bodySmall: new TextStyle(color: Colors.yellow))),
            child: BottomNavigationBar(
              selectedFontSize: 0.0,
              unselectedFontSize: 0.0,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/noun-menu-4748399.png',
                    width: 44,
                    height: 44,
                    color: Colors.black,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/noun-promotion-6769667.png',
                    width: 44,
                    height: 44,
                    color: Colors.black,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/noun-notification-bell-6486567.png',
                    width: 34,
                    height: 34,
                    color: Colors.black,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/noun-upload-6840889.png',
                    width: 34,
                    height: 34,
                    color: Colors.black,
                  ),
                  label: '',
                ),
              ],
              currentIndex: 1,
              selectedItemColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  final _database = FirebaseDatabase.instance;

  Future<void> _addPromotionData(String type, String musicUrl) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    try {
      final ref = _database.ref('AllPromotions').push();
      final data = {
        'songId': widget.songId,
        'paymentID': "dummyid",
        'type': type,
        'timestamp': DateTime.now().toIso8601String(), // Add current time
        'musicUrl': musicUrl,
        'songName': widget.songName,
        'promotionType': widget.promotionType,
        'userId': uid,
        'artistName': widget.artistName,
      };
      await ref.set(data);
      print('Promotion data added successfully: $data');
    } catch (error) {
      print('Error adding promotion data: $error');
    }
  }

  Widget _buildPromotionField(String icon, String type, String musicUrl) {
    return GestureDetector(
      onTap: () => _addPromotionData(type, musicUrl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(width: 25, height: 25, icon),
          Row(
            children: [
              Text('1000', style: TextStyle(color: Colors.white)),
              SizedBox(width: 5),
              Text('5\$', style: TextStyle(color: Colors.white)),
              SizedBox(width: 10),
              Image.asset(
                  width: 25, height: 25, 'assets/mtn-mobile-logo-icon.png'),
              SizedBox(width: 5),
              Image.asset(
                  width: 25,
                  height: 25,
                  'assets/PinClipart.com_clip-art-2010_1162739.png'),
              SizedBox(width: 5),
              Image.asset(
                  width: 25, height: 25, 'assets/paypal-784404_1280.png'),
              SizedBox(width: 5),
              Image.asset(
                  width: 25, height: 25, 'assets/visa-6850402_1280.png'),
              SizedBox(width: 5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllPromotionField(String songID) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Row(
              children: [
                // yt,tk
                Image.asset(
                    width: 10, height: 10, 'assets/social-3434840_1280.png'),
                Image.asset(
                    width: 10, height: 10, 'assets/tiktok-6338429_1280.png'),
              ],
            ),
            SizedBox(
              width: 5,
            ),
            Row(
              children: [
                // ig,fb
                Image.asset(width: 10, height: 10, 'assets/instagram.png'),
                Image.asset(
                    width: 10, height: 10, 'assets/facebook-1924510_1280.png'),
              ],
            )
          ],
        ),
        SizedBox(
          width: 5,
        ),
        Row(
          children: [
            Text(
              '1000',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '5\$',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Image.asset(
                width: 25, height: 25, 'assets/mtn-mobile-logo-icon.png'),
            SizedBox(
              width: 5,
            ),
            Image.asset(
                width: 25,
                height: 25,
                'assets/PinClipart.com_clip-art-2010_1162739.png'),
            SizedBox(
              width: 5,
            ),
            Image.asset(width: 25, height: 25, 'assets/paypal-784404_1280.png'),
            SizedBox(
              width: 5,
            ),
            Image.asset(width: 25, height: 25, 'assets/visa-6850402_1280.png'),
          ],
        ),
      ],
    );
  }
}
