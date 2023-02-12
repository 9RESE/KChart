import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/charts/aceSolarMagModel.dart';
import '../models/charts/aceSolarWindModel.dart';
import '../models/charts/dscovrSolarMagModel.dart';
import '../models/charts/dscovrSolarWindModel.dart';
import '../models/charts/goesElectronModel.dart';
import '../models/charts/goesProtonModel.dart';
import '../models/charts/kpIndexModel.dart';
import '../models/charts/goesMagnetoModel.dart';
import '../models/charts/rtswSolarMagModel.dart';
import '../models/charts/rtswSolarWindModel.dart';
import '../models/charts/xRayModel.dart';

class ApiHelper {
  static Future<List<RTSWSolarMagSeries>> getMagSeries() async {
    List<RTSWSolarMagSeries> rtswmagSeries = [];
    final response = await http.get(
        Uri.parse('https://services.swpc.noaa.gov/json/rtsw/rtsw_mag_1m.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        rtswmagSeries.add(RTSWSolarMagSeries.fromMap(item));
      }
    }
    return rtswmagSeries;
  }

  static Future<List<AceSolarMagSeries>> getAceMagSeries() async {
    List<AceSolarMagSeries> aceMagSeries = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/json/ace/mag/ace_mag_1h.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        aceMagSeries.add(AceSolarMagSeries.fromMap(item));
      }
    }
    return aceMagSeries;
  }

  static Future<List<DscovrSolarMagSeries>> getDscovrMagSeries() async {
    List<DscovrSolarMagSeries> dscovrMagSeries = [];
    final response = await http.get(Uri.parse(
        'http://services.swpc.noaa.gov/products/solar-wind/mag-1-day.json'));
    if (response.statusCode == 200) {
      List vlist = jsonDecode(response.body);
      for (int i = 1; i < vlist.length; i++) {
        Map<int, dynamic> newItem = vlist[i].asMap();
        dscovrMagSeries.add(DscovrSolarMagSeries.fromMap(newItem));
      }
    }
    return dscovrMagSeries;
  }

  static Future<List<RTSWSolarWindSeries>> getWindSeries() async {
    List<RTSWSolarWindSeries> windSeries = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/json/rtsw/rtsw_wind_1m.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        windSeries.add(RTSWSolarWindSeries.fromMap(item));
      }
    }
    return windSeries;
  }

  static Future<List<AceSolarWindSeries>> getAceWindSeries() async {
    List<AceSolarWindSeries> aceWindSeries = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/json/ace/swepam/ace_swepam_1h.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        aceWindSeries.add(AceSolarWindSeries.fromMap(item));
      }
    }
    return aceWindSeries;
  }

  static Future<List<DscovrSolarWindSeries>> getDscovrWindSeries() async {
    List<DscovrSolarWindSeries> dscovrWindSeries = [];
    final response = await http.get(Uri.parse(
        'http://services.swpc.noaa.gov/products/solar-wind/plasma-1-day.json'));
    if (response.statusCode == 200) {
      List vlist = jsonDecode(response.body);
      for (int i = 1; i < vlist.length; i++) {
        Map<int, dynamic> newItem = vlist[i].asMap();
        dscovrWindSeries.add(DscovrSolarWindSeries.fromMap(newItem));
      }
    }
    return dscovrWindSeries;
  }

  static Future<List<XRayModel>> getXRay16Series() async {
    List<XRayModel> series = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/json/goes/primary/xrays-1-day.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        series.add(XRayModel.fromMap(item));
      }
    }

    return series;
  }

  static Future<List<XRayModel>> getXRay17Series() async {
    List<XRayModel> series = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/json/goes/secondary/xrays-1-day.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        series.add(XRayModel.fromMap(item));
      }
    }

    return series;
  }

  static Future<List<GoesMagnetoModel>> getMagneto16Series() async {
    List<GoesMagnetoModel> series = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/json/goes/primary/magnetometers-1-day.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        series.add(GoesMagnetoModel.fromMap(item));
      }
    }
    return series;
  }

  static Future<List<GoesMagnetoModel>> getMagneto17Series() async {
    List<GoesMagnetoModel> series = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/json/goes/secondary/magnetometers-1-day.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        series.add(GoesMagnetoModel.fromMap(item));
      }
    }
    return series;
  }

  static Future<List<RTKIndexModel>> getRTKpSeries() async {
    List<RTKIndexModel> series = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/products/noaa-planetary-k-index.json'
        ));
    int i = 0;
    for (var item in jsonDecode(response.body)) {
      if (i > 0) {
        series.add(RTKIndexModel.fromList(item));
      }
      i++;
    }
    return series;
  }

  static Future<List<GOESProtonSeries>> getGoesProton16Series() async {
    List<GOESProtonSeries> series = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/json/goes/primary/integral-protons-1-day.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        if (item['energy'] == '>=10 MeV' || item['energy'] == '>=100 MeV') {
          series.add(GOESProtonSeries.fromMap(item));
        }
      }
    }
    return series;
  }

  static Future<List<GOESProtonSeries>> getGoesProton17Series() async {
    List<GOESProtonSeries> series = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/json/goes/secondary/integral-protons-1-day.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        if (item['energy'] == '>=10 MeV' || item['energy'] == '>=100 MeV') {
          series.add(GOESProtonSeries.fromMap(item));
        }
      }
    }
    return series;
  }

  static Future<List<GoesElectronModel>> getGoesElecton16Series() async {
    List<GoesElectronModel> series = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/json/goes/primary/integral-electrons-1-day.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        series.add(GoesElectronModel.fromMap(item));
      }
    }
    return series;
  }

  static Future<List<GoesElectronModel>> getGoesElecton17Series() async {
    List<GoesElectronModel> series = [];
    final response = await http.get(Uri.parse(
        'https://services.swpc.noaa.gov/json/goes/secondary/integral-electrons-1-day.json'));
    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        series.add(GoesElectronModel.fromMap(item));
      }
    }
    return series;
  }
}
