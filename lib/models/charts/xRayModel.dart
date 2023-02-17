import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class XRayModel {
  late DateTime time;
  late String satellite;
  late String energy;
  late double flux;

  XRayModel({
    required this.time,
    required this.satellite,
    required this.energy,
    required this.flux,
  });

  Map toMap(XRayModel xRayData) {
    var data = <String, dynamic>{};
    data["time_tag"] = xRayData.time;
    data["satellite"] = xRayData.satellite;
    data["energy"] = xRayData.energy;
    data["flux"] = xRayData.flux;
    return data;
  }

  XRayModel.fromMap(Map<String, dynamic> mapData) {
    try {
      time = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(mapData["time_tag"]);
      satellite = mapData["satellite"].toString();
      energy = mapData["energy"].toString();
      if (mapData["flux"] != null) {
        flux = (mapData["flux"] ?? 0);
        if(flux != 0) {

          int count = int.parse(flux.toStringAsExponential().split('e').toList()[1]) * -1;
          flux = (9 - count) + flux * pow(10, count - 1);
        }

      }
    } catch (e) {
      //print('111111111111111111111111111111111 xray fromMap e $e');
    }
  }
}
