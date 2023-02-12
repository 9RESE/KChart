import 'package:intl/intl.dart';

class RTSWSolarMagSeries {
  late DateTime particalTime;
  late String particalSource;
  late double bt;
  late double bz;
  late double phi;

  RTSWSolarMagSeries({
    required this.particalTime,
    required this.particalSource,
    required this.bt, 
    required this.bz,
    required this.phi, 
  });


  Map toMap(RTSWSolarMagSeries winddata) {
    var data = <String, dynamic>{};
    data["time_tag"] = winddata.particalTime;
    data["source"] = winddata.particalSource;
    data["bt"] = winddata.bt;
    data["bz_gsm"] = winddata.bz;
    data["phi_gsm"] = winddata.phi;
    return data;
  }

  RTSWSolarMagSeries.fromMap(Map<String, dynamic> mapData) {
    particalTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(mapData["time_tag"]);
    particalSource = mapData["source"];
    bt = mapData["bt"];
    bz = mapData["bz_gsm"];
    phi = mapData["phi_gsm"];
  }
}
