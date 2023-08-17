import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as MyLocation;
import 'package:geocoding/geocoding.dart';


class LocationService {
  final MyLocation.Location location = MyLocation.Location();

  Future<void> enableLocation() async {
    bool _service = await location.serviceEnabled();
    MyLocation.PermissionStatus? _permission;
    try{
      _permission = await location.hasPermission();

      print('location:::::::::::::::::::::::: $_service, $_permission');
      if (!_service ||
          _permission == MyLocation.PermissionStatus.denied ||
          _permission == MyLocation.PermissionStatus.deniedForever) {
        await location.requestPermission();
        await location.requestService();
      }
    }catch(e) {
      log(e.toString());
    }
    return;
  }

  Future<Position> getLatitudeLongitude() async {
    await enableLocation();
    try {
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

      Position position = await geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      getCurrentLocation();
      return Future.value(position);
    }catch(e) {
      log("Location error $e");
      throw e.toString();
    }
  }

  Future<Placemark> getAddressFromLatLng(Position position) async {
    await enableLocation();
    try {

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      // List<Placemark> placemarks = await placemarkFromCoordinates(18.4529, 73.8652);
      return placemarks[0];
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Placemark> getCurrentLocation() async {
    await enableLocation();
    try {
      final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

      Position pos = await geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      print('pos:: ${pos.latitude} ..... lng:: ${pos.longitude}');
      Placemark location = await LocationService().getAddressFromLatLng(pos);

      return Future.value(location);
    } catch (e) {
      log("Location error $e");
      throw e.toString();
    }
  }
}
