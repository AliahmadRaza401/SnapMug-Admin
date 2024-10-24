String profileImageURL =
    'https://firebasestorage.googleapis.com/v0/b/snapmugflutter.appspot.com/o/users%2F5zZHTX35lwTKQWoVFWrfMCPjxmS2?alt=media&token=c8cb5499-f89a-481b-b4eb-06dd42570bae';
class UserProfileData {
  // Private constructor
  UserProfileData._privateConstructor();

  // The single instance of AppData
  static final UserProfileData _instance = UserProfileData._privateConstructor();

  // Factory method to return the instance
  factory UserProfileData() {
    return _instance;
  }

  // Late initialization
  late Map<dynamic,dynamic> _data;
  late String _paymentId;

  // Getter and setter for _someData
  String get paymentId => _paymentId;
  Map<dynamic,dynamic> get profileData => _data;
  set setProfileData(Map<dynamic,dynamic> data) {
    _data = data;
  }

  set setPaymentId(String data) {
    _paymentId = data;
  }
}

// class Globals {
//   String paymentId='';
// }