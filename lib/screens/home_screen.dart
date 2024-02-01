import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:radyo_ikcu/apis/radio_api.dart';

import 'package:radyo_ikcu/widgets/gradient_background.dart';
import 'package:radyo_ikcu/widgets/radio_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10))
        .then((value) => {FlutterNativeSplash.remove()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: FutureBuilder(
            future: RadioApi.initPlayer(context),
            builder: (context, snapahot) {
              if (snapahot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child:  CupertinoActivityIndicator(
                                radius: 20.0, color: CupertinoColors.white),
                );
              }
              return const RadioPlayer();
            }),
      ),
    );
  }
}
