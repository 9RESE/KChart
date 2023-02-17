import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../helpers/apiHelper.dart';
import '../../models/charts/xRayModel.dart';

class XrayService extends ChangeNotifier {
  List<XRayModel> _goes16Series = [];
  List<XRayModel> _goes17Series = [];

  List<ShowingTooltipIndicators> _xrayIndicators = [];
  List<FlSpot> _data16Long = [];
  List<FlSpot> _data16Short = [];
  List<FlSpot> _data17Long = [];
  List<FlSpot> _data17Short = [];

  bool loading = true;

  // @override
  // void dispose() {
  // _goes16Series = [];
  // _goes17Series = [];
  // _data16Long = [];
  // _data16Short = [];
  // _data17Long = [];
  // _data17Short = [];
  // loading = true;
  // super.dispose();
  // }

  initData() async {
    loading = true;
    _goes16Series = [];
    _goes17Series = [];
    _data16Long = [];
    _data16Short = [];
    _data17Long = [];
    _data17Short = [];
    _goes16Series = await ApiHelper.getXRay16Series();
    _goes17Series = await ApiHelper.getXRay17Series();

    for (var item in _goes16Series) {
      if (item.energy == '0.05-0.4nm') {
        _data16Short.add(
            FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      } else if (item.energy == '0.1-0.8nm') {
        _data16Long.add(
            FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      }
    }

    for (var item in _goes17Series) {
      if (item.energy == '0.05-0.4nm') {
        _data17Short.add(
            FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      } else if (item.energy == '0.1-0.8nm') {
        _data17Long.add(
            FlSpot(item.time.millisecondsSinceEpoch.toDouble(), item.flux));
      }
    }
    loading = false;
    notifyListeners();
  }

  /// xray charts start ******************************************
  LineChartData xrayData() {
    return LineChartData(
      showingTooltipIndicators: _xrayIndicators,
      lineTouchData: _xrayTouchData(),
      gridData: _gridData,
      titlesData: _xrayTitlesData,
      borderData: _borderData,
      lineBarsData: [
        _data16LongChartData,
        _data16ShortChartData,
        _data17LongChartData,
        _data17ShortChartData,
      ],
      minY: 0,
      maxY: 7,
      // minX: _mh
    );
  }

  double getRealValueForTooltip(double value) {
    int exponent = 9 - value.toInt() -1;
    double realValue = value - value.toInt();
    realValue = realValue * pow(10, -exponent);
    return realValue;
  }

  LineTouchData _xrayTouchData() {
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
              var xPLevel = '-';
              var xSLevel = '-';
              String xPLast = touchedBarSpots[0]
                  .y
                  .toStringAsExponential(2)
                  .characters
                  .takeLast(1)
                  .toString();
              String xSLast = touchedBarSpots[2]
                  .y
                  .toStringAsExponential(2)
                  .characters
                  .takeLast(1)
                  .toString();

              if (xPLast == '8') {
                xPLevel = 'A';
              } else if (xPLast == '7') {
                xPLevel = 'B';
              } else if (xPLast == '6') {
                xPLevel = 'C';
              } else if (xPLast == '5') {
                xPLevel = 'M';
              } else if (xPLast == '4') {
                xPLevel = 'X';
              } else if (xPLast == '3') {
                xPLevel = 'X2';
              } else if (xPLast == '2') {
                xPLevel = 'X3';
              } else if (xPLast == '1') {
                xPLevel = 'X4';
              } else if (xPLast == '0') {
                xPLevel = 'X5';
              }

              if (xSLast == '8') {
                xSLevel = 'A';
              } else if (xSLast == '7') {
                xSLevel = 'B';
              } else if (xSLast == '6') {
                xSLevel = 'C';
              } else if (xSLast == '5') {
                xSLevel = 'M';
              } else if (xSLast == '4') {
                xSLevel = 'X';
              } else if (xSLast == '3') {
                xSLevel = 'X2';
              } else if (xSLast == '2') {
                xSLevel = 'X3';
              } else if (xSLast == '1') {
                xSLevel = 'X4';
              } else if (xSLast == '0') {
                xSLevel = 'X5';
              }
              return [
                LineTooltipItem(
                  '16 Long: $xPLevel ${getRealValueForTooltip(touchedBarSpots[0].y).toStringAsExponential(2)}',
                  const TextStyle(
                    color: Colors.red,
                  ),
                ),
                LineTooltipItem(
                  '16 Short: ${getRealValueForTooltip(touchedBarSpots[1].y).toStringAsExponential(2)}',
                  const TextStyle(
                    color: Colors.blue,
                  ),
                ),
                LineTooltipItem(
                  '17 Long: $xSLevel ${getRealValueForTooltip(touchedBarSpots[2].y).toStringAsExponential(2)}',
                  const TextStyle(
                    color: Colors.orange,
                  ),
                ),
                LineTooltipItem(
                  '17 Short: ${getRealValueForTooltip(touchedBarSpots[3].y).toStringAsExponential(2)} \n',
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

  FlTitlesData get _xrayTitlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 11000000, //3600 * 1000 * 12,
            getTitlesWidget: _bottomTitleWidgets,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 0.5,
            getTitlesWidget: (value, meta) {
              String text = '';
              // return Text('XRay Flare Class');
              switch (value.toString()) {
                case '1.5':
                  text = 'A';
                  break;
                case '2.5':
                  text = 'B';
                  break;
                case '3.5':
                  text = 'C';
                  break;
                case '4.5':
                  text = 'M';
                  break;
                case '5.5':
                  text = 'X';
                  break;
              }

              return Container(
                padding: const EdgeInsets.only(left: 5),
                child: Text(text, style: const TextStyle(fontSize: 10),),
              );
            },
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
            axisNameSize: 15,
            axisNameWidget: const Text(
              'Watts ∙ (m ^ -2)',
              style: TextStyle(color: Colors.orange),
            ),
            sideTitles: SideTitles(
              getTitlesWidget: _xrayLeftTitleWidgets,
              showTitles: true,
              interval: 1,
              reservedSize: 30,
            )),
      );

  Widget _xrayLeftTitleWidgets(double value, TitleMeta meta) {
    String text = value.toStringAsExponential(0).toString();

    int exponent = value.toInt() - 9;
    return Math.tex(
      '10^{$exponent}',
      textStyle: const TextStyle(fontSize: 11, color: Colors.white),
    );
  }

  LineChartBarData get _data16LongChartData => LineChartBarData(
      isCurved: false,
      color: Colors.red,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _data16Long);

  LineChartBarData get _data16ShortChartData => LineChartBarData(
      isCurved: false,
      color: Colors.blue,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _data16Short);

  LineChartBarData get _data17LongChartData => LineChartBarData(
      isCurved: false,
      color: Colors.orange,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _data17Long);

  LineChartBarData get _data17ShortChartData => LineChartBarData(
      isCurved: false,
      color: Colors.purple,
      barWidth: .5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: _data17Short);

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

    if (value >= _data16Short.last.x || value <= _data16Short.first.x) {
      text = const Text("");
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  FlGridData get _gridData => FlGridData(
      show: true, drawVerticalLine: false, drawHorizontalLine: true);

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
      _xrayIndicators = [];
      notifyListeners();
      return;
    }

    final value = lineTouch.lineBarSpots![0].x;

    double _16LongY = 0;
    double _16ShortY = 0;
    double _17LongY = 0;
    double _17ShortY = 0;

    for (var item in _data16Long) {
      if (item.x == value) {
        _16LongY = item.y;
        break;
      }
    }

    for (var item in _data16Short) {
      if (item.x == value) {
        _16ShortY = item.y;
        break;
      }
    }

    for (var item in _data17Long) {
      if (item.x == value) {
        _17LongY = item.y;
        break;
      }
    }

    for (var item in _data17Short) {
      if (item.x == value) {
        _17ShortY = item.y;
        break;
      }
    }

    _xrayIndicators = [
      ShowingTooltipIndicators([
        LineBarSpot(_data16LongChartData, 0, FlSpot(value, _16LongY)),
        LineBarSpot(_data16ShortChartData, 1, FlSpot(value, _16ShortY)),
        LineBarSpot(_data17LongChartData, 2, FlSpot(value, _17LongY)),
        LineBarSpot(_data17ShortChartData, 3, FlSpot(value, _17ShortY)),
      ]),
    ];
    notifyListeners();
  }
}
