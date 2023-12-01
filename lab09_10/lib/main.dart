import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lab09_10/geolocation.dart';
import 'package:lab09_10/geolocation_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {

  List<GeoLocation> locations = [
    GeoLocation("location1", "2000 Simcoe St N, Oshawa", const LatLng(43.9458, -78.8946)),
    GeoLocation("location2", '720 Taunton Rd E', const LatLng(43.9225, -78.9271)),
  ];
  MapController mapController = MapController();
  List<Marker> mapMarkers = [];
  List<LatLng> locationPoints = [];

  void init() {
    for (GeoLocation l in locations) {
      mapMarkers.add(
        Marker(
          point: l.latlng,
          width: 80,
          height: 80,
          child: const Icon(Icons.circle, color: Colors.blue,)
        )
      );
      locationPoints.add(l.latlng);
    }
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab 9-10"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            onMapReady: () {
              mapController.mapEventStream.listen((event) { });
            },
            initialZoom: 12.5,
            minZoom: 10.0,
            maxZoom: 18.0,
            initialCenter: const LatLng(43.9225, -78.9271),
          ),
          children: [
            TileLayer(
              urlTemplate: "https://api.mapbox.com/styles/v1/sethdev/ckhrbzrlt06no19o4kc067jyh/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2V0aGRldiIsImEiOiJja2hyYmZjYTgwOTA4MzVvc2UzbHlrcnM3In0.0qLWJ57FdfSwf25r5hzHgA",
            ),
            MarkerLayer(
              markers: mapMarkers
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: locationPoints,
                  color: Colors.blue,
                  strokeWidth: 4.0,
                )
              ]
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Position? currentPosition = await GeoLocationService.findCurrentPosition();
          if(currentPosition != null) {
            List<Placemark> placemarks = await placemarkFromCoordinates(currentPosition.latitude, currentPosition.longitude);
            locations.add(
              GeoLocation(placemarks[0].name!, placemarks[0].street!, LatLng(currentPosition.latitude, currentPosition.longitude))
            );

            setState(() {
              LatLng center = LatLng(currentPosition.latitude, currentPosition.longitude);
              mapController.move(center, 12.5);
            });
          }
        },

        child: const Icon(Icons.add_location_alt, size: 24,),
      ),
    );
  }
}

