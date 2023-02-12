import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helpers/apiHelper.dart';
import '../../models/charts/kpIndexModel.dart';

class RTKpService extends ChangeNotifier {
  List<RTKIndexModel> _rtKpSeries = [];

  List<ShowingTooltipIndicators> _rtkpIndicators = [];
  List<FlSpot> _datartkp = [];

  bool loading = true;

  initData() async {
    loading = true;
    _rtKpSeries = [];
    _rtkpIndicators = [];
    _datartkp = [];
    _rtKpSeries = await ApiHelper.getRTKpSeries();

    for (var item in _rtKpSeries) {
      _datartkp.add(FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.kp));
    }
    loading = false;
    notifyListeners();
  }

  /// xray charts start ******************************************
  LineChartData kpData() {
    return LineChartData(
      showingTooltipIndicators: _rtkpIndicators,
      lineTouchData: _rtkpTouchData(),
      gridData: _gridData,
      titlesData: _rtkpTitlesData,
      borderData: _borderData,
      lineBarsData: [
        _datartkpChartData,
      ],
      // minX: _mh
    );
  }

  LineTouchData _rtkpTouchData() {
    return LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.white, strokeWidth: 0.5),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                      radius: 2,
                      color: Colors.white,
                      strokeWidth: 0.5,
                      strokeColor: Colors.white);
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            tooltipBorder: const BorderSide(color: Colors.black, width: 1),
            tooltipPadding: const EdgeInsets.all(5),
            maxContentWidth: 200,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              Color kPColor = Colors.black;
              int colorCase;
              int kPLast = int.parse(touchedBarSpots[0]
                  .y
                  .toString()
                  .characters
                  .take(1)
                  .toString());

              if (kPLast < 4) {
                kPColor = Colors.green;
                colorCase = 1;
              } else if (kPLast >= 4 && kPLast < 5) {
                kPColor = Colors.yellow;
                colorCase = 2;
              } else if (kPLast >= 5) {
                kPColor = Colors.red;
                colorCase = 3;
              }

              return [
                LineTooltipItem(
                  'RT Kp: ${touchedBarSpots[0].y.toString()} \n',
                  TextStyle(
                    color: kPColor,
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat.Md().add_Hm().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              touchedBarSpots[0].x.toInt())),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ];
            }),
        touchCallback: _drawIndicators);
  }

  FlTitlesData get _rtkpTitlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 3600 * 1000 * 50,
            getTitlesWidget: _bottomTitleWidgets,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
            axisNameSize: 15,
            axisNameWidget: RichText(
              text: const TextSpan(children: [
                TextSpan(
                    text: 'Kp Index', style: TextStyle(color: Colors.orange)),
                TextSpan(text: ' Kp<4', style: TextStyle(color: Colors.green)),
                TextSpan(text: ' Kp=4', style: TextStyle(color: Colors.yellow)),
                TextSpan(text: ' Kp>5', style: TextStyle(color: Colors.red)),
              ]),
            ),
            sideTitles: SideTitles(
              getTitlesWidget: _kpLeftTitleWidgets,
              showTitles: true,
              interval: 1.0,
              reservedSize: 30,
            )),
      );

  Widget _kpLeftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = value.toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartBarData get _datartkpChartData => LineChartBarData(
      isCurved: true,
      preventCurveOverShooting: true,
      isStrokeJoinRound: false,
      color: Colors.blue,
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _datartkp);

  /// xray charts end *********************************************

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontSize: 12,
    );
    Widget text = Text(
        DateFormat.Md()
            .add_H()
            .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
        style: style);

    // if (value >= _datartkp.last.x || value <= _datartkp.first.x) {
    //   text = const Text("");
    // }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  FlGridData get _gridData => FlGridData(
      show: true, drawVerticalLine: false, drawHorizontalLine: false);

  FlBorderData get _borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.blueGrey, width: 1),
          left: BorderSide(color: Colors.blueGrey, width: 1),
          right: BorderSide(color: Colors.blueGrey, width: 1),
          top: BorderSide(color: Colors.blueGrey, width: 1),
        ),
      );

  _drawIndicators(FlTouchEvent event, LineTouchResponse? lineTouch) {
    if (!event.isInterestedForInteractions ||
        lineTouch == null ||
        lineTouch.lineBarSpots == null) {
      _rtkpIndicators = [];
      notifyListeners();
      return;
    }

    final value = lineTouch.lineBarSpots![0].x;

    double rtkp = 0;

    for (var item in _datartkp) {
      if (item.x == value) {
        rtkp = item.y;
        break;
      }
    }

    _rtkpIndicators = [
      ShowingTooltipIndicators([
        LineBarSpot(_datartkpChartData, 0, FlSpot(value, rtkp)),
      ]),
    ];
    
    notifyListeners();
  }
}
