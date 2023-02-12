import 'package:intl/intl.dart';

class DscovrSolarMagSeries {
  late DateTime particalTime;
  late double bt;
  late double bz;
  late double phi;

  DscovrSolarMagSeries({
    required this.particalTime,
    required this.bt, 
    required this.bz,
    required this.phi,
  });


  Map toMap(DscovrSolarMagSeries winddata) {
    var data = <int, dynamic>{};
    data[0] = winddata.particalTime;
    data[6] = winddata.bt;
    data[3] = winddata.bz;
    data[4] = winddata.phi;
    return data;
  }

  DscovrSolarMagSeries.fromMap(Map<int, dynamic> mapData) {
    particalTime = DateFormat("yyyy-MM-dd' 'HH:mm:ss").parse(mapData[0]);
    bt = double.parse(mapData[6]);
    bz = double.parse(mapData[3]);
    phi = double.parse(mapData[4]);
  }
}

