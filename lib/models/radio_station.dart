class RadioStation {
  final String name;
  final String streamUrl;
  final String photoUrl;

  // ignore: prefer_typing_uninitialized_variables
  static var allStations;

  RadioStation(
      {required this.name, required this.streamUrl, required this.photoUrl});
}
