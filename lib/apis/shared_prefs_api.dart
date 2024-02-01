import 'package:radyo_ikcu/models/radio_station.dart';
import 'package:radyo_ikcu/utils/radio_stations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsApi {
  static const _key = 'radyo_istasyonu';
  static Future<RadioStation> getInitialRadioStation() async {
    // ignore: non_constant_identifier_names
    final SharedPrefs = await SharedPreferences.getInstance();

    final stationName = SharedPrefs.getString(_key);

    if (stationName == null) return RadioStations.allStation[0];

    return RadioStation.allStations
        .firstWhere((element) => element.name == stationName);
  }

  static Future<void> setStation(RadioStation station) async {
    // ignore: non_constant_identifier_names
    final SharePrefs = await SharedPreferences.getInstance();

    SharePrefs.setString(_key, station.name);
  }
}
