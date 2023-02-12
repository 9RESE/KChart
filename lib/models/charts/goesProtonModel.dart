import 'package:intl/intl.dart';

class GOESProtonSeries {
  late DateTime time;
  late String protonSource;
  late String energy;
  late double flux;

  GOESProtonSeries({
    required this.time,
    required this.protonSource,
    required this.flux,
    required this.energy,
  });

  Map toMap(GOESProtonSeries winddata) {
    var data = <String, dynamic>{};
    data["time_tag"] = winddata.time;
    data["satellite"] = winddata.protonSource;
    data["energy"] = winddata.energy;
    data["flux"] = winddata.flux;
    return data;
  }

  GOESProtonSeries.fromMap(Map<String, dynamic> mapData) {
    try {
      time = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(mapData["time_tag"]);
      protonSource = (mapData["satellite"].toString());
      if (mapData["energy"] != null) {
        energy = (mapData["energy"] ?? '');
      }
      if (mapData["flux"] != null) {
        flux = (mapData["flux"] ?? 0);
      }
    } catch (e) {
      //print('55555555555555555555555555555 proton modle error $e');
    }
  }
}
