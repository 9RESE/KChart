import 'package:intl/intl.dart';

class DscovrSolarWindSeries {
  late DateTime windTime;
  double? protonDensity;
  double? protonSpeed;
  double? protonTemp;

  DscovrSolarWindSeries({
    required this.windTime,  
    this.protonDensity, 
    this.protonSpeed,
    this.protonTemp, 
  });


  Map toMap(DscovrSolarWindSeries winddata) {
    var data = <int, dynamic>{};
    data[0] = winddata.windTime;
    data[1] = winddata.protonDensity;
    data[2] = winddata.protonSpeed;
    data[3] = winddata.protonTemp;
    return data;
  }

  DscovrSolarWindSeries.fromMap(Map<int, dynamic> mapData) {
    windTime = DateFormat("yyyy-MM-dd' 'HH:mm:ss").parse(mapData[0]); // 2022-07-20 17:01:00.000
    if(mapData[1] != null) {
      protonDensity = (double.parse(mapData[1])) * 1.0;
    }

    if(mapData[2] != null) {
      protonSpeed = (double.parse(mapData[2])) * 1.0;
    }

    if(mapData[3] != null) {
      protonTemp = (double.parse(mapData[3])) * 1.0;
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