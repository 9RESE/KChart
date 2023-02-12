import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helpers/apiHelper.dart';
import '../../models/charts/goesProtonModel.dart';

class GOESProtonService extends ChangeNotifier {
  List<GOESProtonSeries> _goes16Series = [];
  List<GOESProtonSeries> _goes17Series = [];

  List<ShowingTooltipIndicators> _protonIndicators = [];
  List<FlSpot> _10data16 = [];
  List<FlSpot> _100data16 = [];
  List<FlSpot> _10data17 = [];
  List<FlSpot> _100data17 = [];

  bool loading = true;

  initData() async {
    loading = true;
    _goes16Series = [];
    _goes17Series = [];
    _10data16 = [];
    _100data16 = [];
    _10data17 = [];
    _100data17 = [];
    _goes16Series = await ApiHelper.getGoesProton16Series();
    _goes17Series = await ApiHelper.getGoesProton17Series();

    for (var item in _goes16Series) {
      if (item.energy == '>=100 MeV') {
        _100data16.add(
            FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      } else if (item.energy == '>=10 MeV') {
        _10data16.add(
            FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      }
    }

    for (var item in _goes17Series) {
      if (item.energy == '>=100 MeV') {
        _100data17.add(
            FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      } else if (item.energy == '>=10 MeV') {
        _10data17.add(
            FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      }
    }
    loading = false;
    notifyListeners();
  }

  /// proton charts start ******************************************
  LineChartData protonData() {
    return LineChartData(
      showingTooltipIndicators: _protonIndicators,
      lineTouchData: _protonTouchData(),
      gridData: _gridData,
      titlesData: _protonTitlesData,
      borderData: _borderData,
      lineBarsData: [
        _10data16ChartData,
        _100data16ChartData,
        _10data17ChartData,
        _100data17ChartData,
      ],
      // minX: _mh
    );
  }

  LineTouchData _protonTouchData() {
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
              return [
                LineTooltipItem(
                  '16 >=10 MeV: ${touchedBarSpots[0].y.toStringAsExponential(2)}',
                  const TextStyle(
                    color: Colors.red,
                  ),
                ),
                LineTooltipItem(
                  '16 >=100 MeV: ${touchedBarSpots[1].y.toStringAsExponential(2)}',
                  const TextStyle(
                    color: Colors.blue,
                  ),
                ),
                LineTooltipItem(
                  '17 >=10 MeV: ${touchedBarSpots[2].y.toStringAsExponential(2)}',
                  const TextStyle(
                    color: Colors.orange,
                  ),
                ),
                LineTooltipItem(
                  '17 >=100 MeV: ${touchedBarSpots[3].y.toStringAsExponential(2)} \n',
                  const TextStyle(
                    color: Colors.purple,
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

  FlTitlesData get _protonTitlesData => FlTitlesData(
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
              'Particals cm^-2-s^-1-sr^-1',
              style: TextStyle(color: Colors.orange),
            ),
            sideTitles: SideTitles(
              getTitlesWidget: _protonLeftTitleWidgets,
              showTitles: true,
              interval: .1,
              reservedSize: 30,
            )),
      );

  Widget _protonLeftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = value.toStringAsExponential(0).toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  LineChartBarData get _10data16ChartData => LineChartBarData(
      isCurved: false,
      color: Colors.red,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _10data16);

  LineChartBarData get _100data16ChartData => LineChartBarData(
      isCurved: false,
      color: Colors.blue,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _100data16);

  LineChartBarData get _10data17ChartData => LineChartBarData(
      isCurved: false,
      color: Colors.orange,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _10data17);

  LineChartBarData get _100data17ChartData => LineChartBarData(
      isCurved: false,
      color: Colors.purple,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _100data17);

  /// proton charts end *********************************************

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

    if (value >= _100data16.last.x || value <= _100data16.first.x) {
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
      _protonIndicators = [];
      notifyListeners();
      return;
    }

    final value = lineTouch.lineBarSpots![0].x;

    double _16TenY = 0;
    double _16HundredY = 0;
    double _17TenY = 0;
    double _17HundredY = 0;

    for (var item in _10data16) {
      if (item.x == value) {
        _16TenY = item.y;
        break;
      }
    }

    for (var item in _100data16) {
      if (item.x == value) {
        _16HundredY = item.y;
        break;
      }
    }

    for (var item in _10data17) {
      if (item.x == value) {
        _17TenY = item.y;
        break;
      }
    }

    for (var item in _100data17) {
      if (item.x == value) {
        _17HundredY = item.y;
        break;
      }
    }

    _protonIndicators = [
      ShowingTooltipIndicators([
        LineBarSpot(_10data16ChartData, 0, FlSpot(value, _16TenY)),
        LineBarSpot(_100data16ChartData, 1, FlSpot(value, _16HundredY)),
        LineBarSpot(_10data17ChartData, 2, FlSpot(value, _17TenY)),
        LineBarSpot(_100data17ChartData, 3, FlSpot(value, _17HundredY)),
      ]),
    ];
    notifyListeners();
  }
}
