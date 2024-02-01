// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:radyo_ikcu/apis/radio_api.dart';
import 'package:radyo_ikcu/providers/radio_provider.dart';
import 'package:volume_controller/volume_controller.dart';

import 'radio_list.dart';

class RadioPlayer extends StatefulWidget {
  const RadioPlayer({Key? key}) : super(key: key);

  get stateStream => null;

  @override
  State<RadioPlayer> createState() => _RadioPlayerState();

  setChannel({required String Title, required String url}) {}

  stop() {}

  play() {}
}

class _RadioPlayerState extends State<RadioPlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late VolumeController volumeController;

  late Animation<Offset> radioOffset;
  late Animation<Offset> radioListOffset;

  bool listEnabled = false;
  bool isPlaying = true;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );

    radioListOffset = Tween(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );
    radioOffset = Tween(
      begin: const Offset(0, 0.3),
      end: const Offset(0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );

    // RadioApi.player.stateStream.listen((event) {
    //   setState(() {
    //     isPlaying = event;
    //   });
    // });
    volumeController = VolumeController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SlideTransition(
            position: radioOffset,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.transparent,
                  child: Consumer<RadioProvider>(
                      builder: ((context, value, child) {
                    return Image.network(
                      value.station.photoUrl,
                      fit: BoxFit.cover,
                    );
                  })),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          listEnabled = listEnabled;
                        });
                        switch (animationController.status) {
                          case AnimationStatus.dismissed:
                            animationController.forward();
                            break;
                          case AnimationStatus.completed:
                            animationController
                                .removeStatusListener((status) {});
                          default:
                        }
                      },
                      color: listEnabled
                          ? const Color.fromARGB(255, 0, 0, 0)
                          : Colors.white,
                      iconSize: 30,
                      icon: const Icon(
                        Icons.list,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isPlaying ? isPlaying = false : isPlaying = true;
                          isPlaying
                              ? RadioApi.player.stop()
                              : RadioApi.player.play();
                        });
                      },
                      color: Colors.white,
                      iconSize: 30,
                      icon: Icon(
                        isPlaying ? Icons.stop : Icons.play_arrow,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (isMuted) {
                          volumeController.setVolume(0.5);
                        } else {
                          volumeController.muteVolume();
                        }
                        setState(() {
                          isMuted = !isMuted;
                        });
                      },
                      color: Colors.white,
                      iconSize: 30,
                      icon: Icon(
                        isMuted ? Icons.volume_off : Icons.volume_up,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SlideTransition(
          position: radioListOffset,
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 247, 247),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  40,
                ),
              ),
            ),
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Radyo Listesi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black,
                  indent: 30,
                  endIndent: 30,
                ),
                Expanded(
                  child: RadioList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
