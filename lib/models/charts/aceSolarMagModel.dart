import 'package:intl/intl.dart';

class AceSolarMagSeries {
  late DateTime particalTime;
  late double bt;
  late double bz;
  late double phi;

  AceSolarMagSeries({
    required this.particalTime,
    required this.phi,
    required this.bt, 
    required this.bz,
  });


  Map toMap(AceSolarMagSeries winddata) {
    var data = <String, dynamic>{};
    data["time_tag"] = winddata.particalTime;
    data["bt"] = winddata.bt;
    data["gsm_bz"] = winddata.bz;
    data["gsm_lon"] = winddata.phi;
    return data;
  }

  AceSolarMagSeries.fromMap(Map<String, dynamic> mapData) {
    particalTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(mapData["time_tag"]);
    phi = mapData["gsm_lon"];
    bt = mapData["bt"];
    bz = mapData["gsm_bz"];
  }
}

