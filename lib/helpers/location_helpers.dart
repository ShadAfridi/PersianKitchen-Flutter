import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:location_permissions/location_permissions.dart';

class LocationHelpers {
  Future<Map<String, dynamic>> getLocation() async {
    try {
      var enabled = await Geolocator().isLocationServiceEnabled();

      PermissionStatus permission =
          await LocationPermissions().checkPermissionStatus();

      if (enabled == true && permission == PermissionStatus.granted) {
        var pos = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        );

        var add = await Geolocator()
            .placemarkFromCoordinates(pos.latitude, pos.longitude);

        if (add.first.thoroughfare.isEmpty) {
          String loc =
              '${add.first.name}, ${add.first.subLocality}, ${add.first.locality}';
          if (loc.length > 32) {
            loc = '${loc.substring(0, 30)}...';
          }
          Map<String, dynamic> location = {'location': loc, 'position': pos};
          return location;
        } else {
          String loc =
              '${add.first.name}, ${add.first.thoroughfare}, ${add.first.subLocality}';
          if (loc.length > 32) {
            loc = '${loc.substring(0, 30)}...';
          }
          Map<String, dynamic> location = {'location': loc, 'position': pos};
          return location;
        }
      } else {
        LocationPermissions().requestPermissions();
        return {'permission': false};
      }
    } catch (err) {
      throw err;
    }
  }

  Future<bool> isNear(Position pos) async {
    try {
      String url =
          'https://api.mapbox.com/directions/v5/mapbox/driving-traffic/88.370071,22.535891;${pos.longitude},${pos.latitude}?alternatives=true&approaches=curb;curb&access_token=pk.eyJ1Ijoic2hhZGFmcmlkaTAzIiwiYSI6ImNrMGplN3I5azA5MXUzaG4xcWJvaWlyaXYifQ.J0RLXrX3B2IvPu4Bi1PWQg';
      var response = await http.get(url);
      int isClose = 0;
      var routes = json.decode(response.body)['routes'];
      routes.forEach((route) {
        if (route['distance'] < 10000) {
          isClose++;
        }
      });
      if (routes.length > 2) {
        if (isClose > 1) {
          return true;
        } else {
          return false;
        }
      } else {
        if (isClose > 0) {
          return true;
        } else {
          return false;
        }
      }
    } catch (err) {
      throw err;
    }
  }
}
