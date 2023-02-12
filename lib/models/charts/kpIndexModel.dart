import 'package:intl/intl.dart';

class RTKIndexModel {
  late DateTime time;
  late double kp;

  RTKIndexModel({
    required this.time,
    required this.kp,
  });

  RTKIndexModel.fromList(List listData) {
    time = DateFormat("yyyy-MM-dd HH:mm:ss")
        .parse(listData[0].replaceAll('.000', ''));
    kp = double.parse(listData[1]);
  }
}
