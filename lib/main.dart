import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radyo_ikcu/apis/shared_prefs_api.dart';
import 'package:radyo_ikcu/models/radio_station.dart';
import 'package:radyo_ikcu/providers/radio_provider.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final radioStation = await SharedPrefsApi.getInitialRadioStation();
  runApp(MyApp(
    initialStation: radioStation,
  ));
}

class MyApp extends StatelessWidget {
  final RadioStation initialStation;
  const MyApp({required this.initialStation, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: ((context) => RadioProvider(initialStation))),
      ],
      child: MaterialApp(
        title: 'Radyo Uygulaması',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
