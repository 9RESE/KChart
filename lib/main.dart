import 'package:charts/providers/chartProviders/xRayService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'goesXrayChart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {var themeData = ThemeData(
              scaffoldBackgroundColor: Colors.black,
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.orange,
              ).copyWith(
                secondary: Colors.blueGrey,
              ),
              textTheme:
                  const TextTheme(bodyText2: TextStyle(color: Colors.white)),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.orange,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
    return MultiProvider(
        providers: [
          // ChangeNotifierProvider<SolarWindFlService>(
          //     create: (context) => SolarWindFlService()),
          // ChangeNotifierProvider<AceSolarWindFlService>(
          //     create: (context) => AceSolarWindFlService()),
          // ChangeNotifierProvider<DscovrSolarWindService>(
          //     create: (context) => DscovrSolarWindService()),
          ChangeNotifierProvider<XrayService>(
              create: (context) => XrayService()),
          // ChangeNotifierProvider<GoesMagnetoService>(
          //     create: (context) => GoesMagnetoService()),
          // ChangeNotifierProvider<RTKpService>(
          //     create: (context) => RTKpService()),
          // ChangeNotifierProvider<GOESProtonService>(
          //     create: (context) => GOESProtonService()),
          // ChangeNotifierProvider<GoesElectronService>(
          //     create: (context) => GoesElectronService()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // localizationsDelegates: context.localizationDelegates,
            // supportedLocales: context.supportedLocales,
            // locale: context.locale,
            title: 'Carrington',
            theme: themeData,
            home: const GoesXRayChartPage(),
            routes: {
              GoesXRayChartPage.routeName: (ctx) => const GoesXRayChartPage(),
            }));
  }
}
