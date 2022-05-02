class Request {
  String rid;
  String uid;
  String message;
  String bloodType;
  bool isComplete;
  List<String> donorIds;

  Request({
    this.rid,
    this.uid,
    this.message,
    this.bloodType,
    this.donorIds = const [],
    this.isComplete = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'message': this.message,
      'bloodType': this.bloodType,
      'isComplete': this.isComplete,
      'donorIds': this.donorIds
    };
  }
}