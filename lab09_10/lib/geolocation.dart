import 'package:latlong2/latlong.dart';

class GeoLocation {
  GeoLocation(this.name, this.address, this.latlng);

  String name;
  String address;
  LatLng latlng;
}