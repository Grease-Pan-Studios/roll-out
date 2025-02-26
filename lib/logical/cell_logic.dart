
class CellLogic {

  late List<bool> neighbourConnections;

  // int x, y;

  CellLogic({
    topConnection = false,
    rightConnection = false,
    bottomConnection = false,
    leftConnection = false
  }){
    neighbourConnections = [
      topConnection,
      rightConnection,
      bottomConnection,
      leftConnection
    ];
  }

  /* Top Connection */
  bool get topConnection => neighbourConnections[0];
  set topConnection(bool value) => neighbourConnections[0] = value;

  /* Right Connection */
  bool get rightConnection => neighbourConnections[1];
  set rightConnection(bool value) => neighbourConnections[1] = value;

  /* Bottom Connection */
  bool get bottomConnection => neighbourConnections[2];
  set bottomConnection(bool value) => neighbourConnections[2] = value;

  /* Left Connection */
  bool get leftConnection => neighbourConnections[3];
  set leftConnection(bool value) => neighbourConnections[3] = value;


  Map<String, dynamic> toJson() {
    return {
      "topConnection": topConnection,
      "rightConnection": rightConnection,
      "bottomConnection": bottomConnection,
      "leftConnection": leftConnection
    };
  }

  factory CellLogic.fromJson(Map<String, dynamic> json) {
    return CellLogic(
      topConnection: json['topConnection'],
      rightConnection: json['rightConnection'],
      bottomConnection: json['bottomConnection'],
      leftConnection: json['leftConnection']
    );
  }


}