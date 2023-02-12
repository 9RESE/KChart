import 'package:intl/intl.dart';

class RTSWSolarWindSeries {
  late DateTime windTime;
  late String windSource;
  double? protonDensity;
  double? protonSpeed;
  double? protonTemp;

  RTSWSolarWindSeries({
    required this.windTime, 
    required this.windSource, 
    this.protonDensity, 
    this.protonSpeed,
    this.protonTemp, 
  });


  Map toMap(RTSWSolarWindSeries winddata) {
    var data = <String, dynamic>{};
    data["time_tag"] = winddata.windTime;
    data["source"] = winddata.windSource;
    data["proton_density"] = winddata.protonDensity;
    data["proton_speed"] = winddata.protonSpeed;
    data["proton_temperature"] = winddata.protonTemp;
    return data;
  }

  RTSWSolarWindSeries.fromMap(Map<String, dynamic> mapData) {
    windTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(mapData["time_tag"]);
    windSource = mapData["source"];
    if(mapData["proton_density"] != null) {
      protonDensity = (mapData["proton_density"] ?? 0) * 1.0;
    }

    if(mapData["proton_speed"] != null) {
      protonSpeed = (mapData["proton_speed"] ?? 0) * 1.0;
    }

    if(mapData["proton_temperature"] != null) {
      protonTemp = (mapData["proton_temperature"] ?? 0) * 1.0;
    }
  }
}

// ace 
// "dens":3.2143531e+000,
// "speed":5.5472040e+002,
// "temperature":1.6539114e+005
// rtsw
// "proton_speed":546.9,
// "proton_temperature":138955,
// "proton_density":2.75,