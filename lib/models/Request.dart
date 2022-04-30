class Request {
  String rid;
  String message;
  String bloodType;
  bool isComplete;
  List<String> donorIds;

  Request({
    this.rid,
    this.message,
    this.bloodType,
    this.donorIds,
    this.isComplete
  });
}