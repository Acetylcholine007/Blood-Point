class AccountData {
  String uid;
  String fullName;
  String username;
  String accountType;
  String email;
  String address;
  String contactNo;
  double latitude;
  double longitude;
  bool isVerified;
  bool isDonor;
  String bloodType;

  AccountData({
    this.uid,
    this.fullName,
    this.username,
    this.accountType = 'STANDARD',
    this.email,
    this.address,
    this.contactNo,
    this.latitude,
    this.longitude,
    this.isDonor,
    this.bloodType
  });

  AccountData copy() => AccountData(
    uid: this.uid,
    fullName: this.fullName,
    accountType: this.accountType,
    email: this.email,
    address: this.address,
    contactNo: this.contactNo,
    latitude: this.latitude,
    longitude: this.longitude,
    isDonor: this.isDonor,
    bloodType: this.bloodType
  );
}