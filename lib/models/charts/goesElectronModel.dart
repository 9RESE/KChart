import 'package:intl/intl.dart';

class GoesElectronModel {
  late DateTime time;
  late String satellite;
  late double flux;
  
  GoesElectronModel({
    required this.time,
    required this.satellite,
    required this.flux,
  });

  GoesElectronModel.fromMap(Map<String, dynamic> mapData) {
    time = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(mapData["time_tag"]);
    satellite = mapData["satellite"].toString();
    if(mapData["flux"].runtimeType == int){
    flux = mapData["flux"].toDouble();
    } else {
      flux = mapData["flux"];
    }
  }
}