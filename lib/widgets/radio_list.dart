import 'package:flutter/material.dart';
import 'package:radyo_ikcu/apis/radio_api.dart';
import 'package:radyo_ikcu/apis/shared_prefs_api.dart';
import 'package:radyo_ikcu/models/radio_station.dart';
import 'package:radyo_ikcu/providers/radio_provider.dart';
import 'package:radyo_ikcu/utils/radio_stations.dart';
import 'package:provider/provider.dart';

class RadioList extends StatefulWidget {
  const RadioList({super.key});

  @override
  State<RadioList> createState() => _RadioListState();
}

class _RadioListState extends State<RadioList> {
  late RadioProvider provider;
  late RadioStation selectedStation;
  @override
  void initState() {
    super.initState();
    provider = Provider.of<RadioProvider>(context, listen: false);
    selectedStation = provider.station;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RadioProvider>(context, listen: false);
    return ListView.builder(
      itemCount: RadioStations.allStation.length,
      itemBuilder: (context, index) {
        final station = RadioStations.allStation[index];
        bool isSelected = station.name == provider.station.name;
        return Container(
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [
                      Colors.red,
                      Color.fromARGB(215, 255, 255, 255),
                    ],
                  )
                : null,
          ),
          child: ListTile(
            leading: Image.network(
              station.photoUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            horizontalTitleGap: 50,
            title: Text(
              station.name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () async {
              provider.setRadioStation(station);
              SharedPrefsApi.setStation(station);
              await RadioApi.changeStation(station);
              setState(() {
                selectedStation = station;
              });
            },
          ),
        );
      },
    );
  }
}
