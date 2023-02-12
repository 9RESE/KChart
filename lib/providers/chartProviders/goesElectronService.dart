import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helpers/apiHelper.dart';
import '../../models/charts/goesElectronModel.dart';

class GoesElectronService extends ChangeNotifier {
  List<GoesElectronModel> _goes16Series = [];
  List<GoesElectronModel> _goes17Series = [];
  bool loading = true;

  List<FlSpot> _data16 = [];
  List<FlSpot> _data17 = [];
  List<ShowingTooltipIndicators> _elecIndicators = [];

  initData() async {
    loading = true;
    _goes16Series = [];
    _goes17Series = [];
    _data16 = [];
    _data17 = [];
    _elecIndicators = [];
    _goes16Series = await ApiHelper.getGoesElecton16Series();
    _goes17Series = await ApiHelper.getGoesElecton17Series();

    for (var item in _goes16Series) {
      _data16
          .add(FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
    }

    for (var item in _goes17Series) {
      _data17
          .add(FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
    }
    loading = false;
    notifyListeners();
  }

  /// goes elec charts start ******************************************
  LineChartData electronData() {
    return LineChartData(
      showingTooltipIndicators: _elecIndicators,
      lineTouchData: _elecTouchData(),
      gridData: _gridData,
      titlesData: _elecTitlesData,
      borderData: _borderData,
      lineBarsData: [
        _data16ChartData,
        _data17ChartData,
      ],
      // minX: _mh
    );
  }

  LineTouchData _elecTouchData() {
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
                  'GOES-16 Flux: ${touchedBarSpots[0].y.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Colors.red,
                  ),
                ),
                LineTooltipItem(
                  'GOES-17 Flux: ${touchedBarSpots[1].y.toStringAsFixed(2)} \n',
                  const TextStyle(
                    color: Colors.blue,
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

  FlTitlesData get _elecTitlesData => FlTitlesData(
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
              'Electrons cm^-2-s^-1-sr^-1',
              style: TextStyle(color: Colors.orange),
            ),
            sideTitles: SideTitles(
              getTitlesWidget: _elecLeftTitleWidgets,
              showTitles: true,
              interval: 1000,
              reservedSize: 30,
            )),
      );

  Widget _elecLeftTitleWidgets(double value, TitleMeta meta) {
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

  /// goes elec charts end *********************************************

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
      _elecIndicators = [];
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

    _elecIndicators = [
      ShowingTooltipIndicators([
        LineBarSpot(_data16ChartData, 0, FlSpot(value, _data16Y)),
        LineBarSpot(_data17ChartData, 0, FlSpot(value, _data17Y)),
      ]),
    ];
    notifyListeners();
  }
}
