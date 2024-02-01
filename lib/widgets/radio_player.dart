// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:radyo_ikcu/apis/radio_api.dart';
import 'package:radyo_ikcu/providers/radio_provider.dart';
import 'package:radyo_ikcu/utils/radio_stations.dart';
import 'package:radyo_ikcu/widgets/shimmer_widget.dart';
import 'package:radyo_ikcu/widgets/utils.dart';
import 'package:shimmer/shimmer.dart';
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

    RadioApi.player.stateStream.listen((event) {
      setState(() {
        isPlaying = event;
      });
    });
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

                //Resim kısmı
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

                    //Liste 
                              IconButton(
                      onPressed: () {
                        setState(() {
                          listEnabled = !listEnabled;
                        });

                        if (animationController.status == AnimationStatus.dismissed) {
                          animationController.forward();
                        } else if (animationController.status == AnimationStatus.completed) {
                          animationController.reverse();
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


                    // Yürütme tuşu 
               IconButton(
  onPressed: () async {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      await RadioApi.player.play();
    } else {
      await RadioApi.player.stop();
    }
  },
  color: Colors.white,
  iconSize: 30,
  icon: Icon(
    isPlaying ? Icons.stop : FontAwesomeIcons.circlePlay,
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
            child:  Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Radyo Listesi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
               const  Divider(
                  color: Colors.black,
                  indent: 30,
                  endIndent: 30,
                ),
        

FutureBuilder(
  future: Future.delayed(const Duration(seconds: 3)), // 3 saniye gecikme ekledik
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // Gecikme sona erdiğinde çalışacak widget'ı oluşturun
            return const  Expanded(
                child: RadioList(),
              );
 
    } else {
          //  return SizedBox(
          // width: 200,
          // height: 300,
          //    child: ListView.builder(
          //      itemBuilder: (context,index){
          //       return ListTile(
          //                leading: ShimmerWidget.rectengular(
          //                  height: 16,
          //                ),
          //                title: Column(
          //                  crossAxisAlignment: CrossAxisAlignment.start,
          //                  children: [
          //       ShimmerWidget.rectengular(
          //         height: 16,
          //       ),
          //       SizedBox(
          //         height: context.height * 0.01,
          //       ),
          //                  ],
          //                ),
          //              );
          //      }, 
          //      itemCount: RadioStations.allStation.length,
          //    ),
          //  );

          return const Center(
                  child:  CupertinoActivityIndicator(
                                radius: 20.0, color: Colors.red),
                );
    }
  },
)

              ],
            ),
          ),
        ),
      ],
    );
  }
}
