import 'package:geolocator/geolocator.dart';

class GeoLocationService {
  static Future<Position?> findCurrentPosition() async {
    try{
      LocationPermission locationPermission = await Geolocator.checkPermission();
      if(locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
      }

      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    } catch(e) {
      print('Error: $e');
    }

  }
}