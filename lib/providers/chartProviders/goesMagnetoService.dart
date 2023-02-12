import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helpers/apiHelper.dart';
import '../../models/charts/goesMagnetoModel.dart';

class GoesMagnetoService extends ChangeNotifier {
  List<GoesMagnetoModel> _goes16Series = [];
  List<GoesMagnetoModel> _goes17Series = [];
  bool loading = true;

  int _arcjetStart16 = 0;
  int _arcjetEnd16 = 0;
  int _arcjetStart17 = 0;
  int _arcjetEnd17 = 0;

  List<FlSpot> _data16 = [];
  List<FlSpot> _data17 = [];
  List<ShowingTooltipIndicators> _magIndicators = [];

  initData() async {
    loading = true;
    _goes16Series = [];
    _goes17Series = [];
    _arcjetStart16 = 0;
    _arcjetEnd16 = 0;
    _arcjetStart17 = 0;
    _arcjetEnd17 = 0;
    _data16 = [];
    _data17 = [];
    _magIndicators = [];
    _goes16Series = await ApiHelper.getMagneto16Series();
    _goes17Series = await ApiHelper.getMagneto17Series();
    _arcjetStart16 = 0;
    _arcjetEnd16 = 0;
    _arcjetStart17 = 0;
    _arcjetEnd17 = 0;

    bool _arcjetStartChecker16 = true;
    bool _arcjetStartChecker17 = true;

    for (var item in _goes16Series) {
      _data16.add(FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.hp));
      if (item.arcjetFlag) {
        if (_arcjetStartChecker16) {
          _arcjetStart16 = item.time.millisecondsSinceEpoch;
          _arcjetStartChecker16 = false;
        }
        _arcjetEnd16 = item.time.millisecondsSinceEpoch;
      }
    }

    for (var item in _goes17Series) {
      _data17.add(FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.hp));
      if (item.arcjetFlag) {
        if (_arcjetStartChecker17) {
          _arcjetStart17 = item.time.millisecondsSinceEpoch;
          _arcjetStartChecker17 = false;
        }
        _arcjetEnd17 = item.time.millisecondsSinceEpoch;
      }
    }
    loading = false;
    notifyListeners();
  }

  /// goes mag charts start ******************************************
  LineChartData magData() {
    return LineChartData(
      showingTooltipIndicators: _magIndicators,
      lineTouchData: _magTouchData(),
      gridData: _gridData,
      titlesData: _magTitlesData,
      borderData: _borderData,
      lineBarsData: [
        _data16ChartData,
        _data17ChartData,
      ],
      // minX: _mh
    );
  }

  LineTouchData _magTouchData() {
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
              bool arcjet16 = false;
              bool arcjet17 = false;

              if (touchedBarSpots[0].x.toInt() >= _arcjetStart16 &&
                  touchedBarSpots[0].x.toInt() <= _arcjetEnd16) {
                arcjet16 = true;
              }

              if (touchedBarSpots[1].x.toInt() >= _arcjetStart17 &&
                  touchedBarSpots[1].x.toInt() <= _arcjetEnd17) {
                arcjet17 = true;
              }

              return [
                LineTooltipItem(
                  'GOES-16 ${arcjet16 ? 'Hp' : 'Hp'}: ${touchedBarSpots[0].y.toStringAsFixed(2)}',
                  TextStyle(
                    color: arcjet16 ? Colors.orange : Colors.red,
                  ),
                ),
                LineTooltipItem(
                  'GOES-17 ${arcjet17 ? 'Hp' : 'Hp'}: ${touchedBarSpots[1].y.toStringAsFixed(2)}\n',
                  TextStyle(
                    color: arcjet17 ? Colors.orange : Colors.blue,
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
                ),
              ];
            }),
        touchCallback: _drawIndicators);
  }

  FlTitlesData get _magTitlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 3600 * 1000 * 12,
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
            axisNameWidget: const Text(
              'NanoTesla (nT)',
              style: TextStyle(color: Colors.orange),
            ),
            sideTitles: SideTitles(
              getTitlesWidget: _magLeftTitleWidgets,
              showTitles: true,
              interval: 25,
              reservedSize: 30,
            )),
      );

  Widget _magLeftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = value.toInt().toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartBarData get _data16ChartData => LineChartBarData(
      isCurved: false,
      color: Colors.red,
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _data16);

  LineChartBarData get _data17ChartData => LineChartBarData(
      isCurved: false,
      color: Colors.blue,
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _data17);

  /// goes mag charts end *********************************************

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

    if (value >= _data16.last.x || value <= _data16.first.x) {
      text = const Text("");
    }

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
      _magIndicators = [];
      notifyListeners();
      return;
    }

    final value = lineTouch.lineBarSpots![0].x;

    double _data16Y = 0;
    double _data17Y = 0;

    for (var item in _data16) {
      if (item.x == value) {
        _data16Y = item.y;
        break;
      }
    }

    for (var item in _data17) {
      if (item.x == value) {
        _data17Y = item.y;
        break;
      }
    }

    _magIndicators = [
      ShowingTooltipIndicators([
        LineBarSpot(_data16ChartData, 0, FlSpot(value, _data16Y)),
        LineBarSpot(_data17ChartData, 0, FlSpot(value, _data17Y)),
      ]),
    ];
    notifyListeners();
  }
}
