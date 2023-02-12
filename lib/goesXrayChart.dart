import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/chartProviders/xRayService.dart';

// ignore: must_be_immutable
class GoesXRayChartPage extends StatefulWidget {
  static const routeName = '/goesXray';

  const GoesXRayChartPage({Key? key}) : super(key: key);

  @override
  State<GoesXRayChartPage> createState() => _GoesXRayChartPageState();
}

class _GoesXRayChartPageState extends State<GoesXRayChartPage> {
  late XrayService? xrayService;
    late Uri _link;
    Future<void>? _linklaunched;
    String url = 'https://services.swpc.noaa.gov/json/goes/primary/xrays-1-day.json';

  @override
  void initState() {
    super.initState();
    _link = Uri.parse(url);
    xrayService = Provider.of<XrayService>(context, listen: false);
    xrayService!.initData();
  }
  @override
  Widget build(BuildContext context) {
    Provider.of<XrayService>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.orange,
          title: const Text("GOES X-Ray Flux (1-minute data)"),
        ),
        body: xrayService!.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 10,
                        right: 10,
                      ),
                      child: LineChart(xrayService!.xrayData()),
                    ),
                  ),
                ],
              ));
  }
}
