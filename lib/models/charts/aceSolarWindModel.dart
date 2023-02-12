import 'package:intl/intl.dart';

class AceSolarWindSeries {
  late DateTime windTime;
  late String windSource;
  double? protonDensity;
  double? protonSpeed;
  double? protonTemp;

  AceSolarWindSeries({
    required this.windTime, 
    required this.windSource, 
    this.protonDensity, 
    this.protonSpeed,
    this.protonTemp, 
  });


  Map toMap(AceSolarWindSeries winddata) {
    var data = <String, dynamic>{};
    data["time_tag"] = winddata.windTime;
    data["source"] = winddata.windSource;
    data["proton_density"] = winddata.protonDensity;
    data["proton_speed"] = winddata.protonSpeed;
    data["proton_temperature"] = winddata.protonTemp;
    return data;
  }

  AceSolarWindSeries.fromMap(Map<String, dynamic> mapData) {
    windTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(mapData["time_tag"]);
    windSource = 'ACE';
    if(mapData["dens"] != null) {
      protonDensity = (mapData["dens"] ?? 0) * 1.0;
    }

    if(mapData["speed"] != null) {
      protonSpeed = (mapData["speed"] ?? 0) * 1.0;
    }

    if(mapData["temperature"] != null) {
      protonTemp = (mapData["temperature"] ?? 0) * 1.0;
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