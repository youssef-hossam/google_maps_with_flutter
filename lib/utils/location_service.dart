import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<bool> checkAndRequestLocationService() async {
    bool isLocationEnabled = await location.serviceEnabled();
    if (!isLocationEnabled) {
      isLocationEnabled = await location.requestService();
      if (!isLocationEnabled) {
        //ErrorBar
        //You will not be able to use the location as long as the location service is not activated.
        return false;
      }
    }
    return true;
  }

// first we should check if the  location service is enabled or not then we should check the permission (allowing the app to get the location) of the user to get the location
  Future<bool> checkAndRequestPermssion() async {
    PermissionStatus hasPermission = await location.hasPermission();
    if (hasPermission == PermissionStatus.deniedForever) {
      return false;
    }
    if (hasPermission == PermissionStatus.denied) {
      hasPermission = await location.requestPermission();
      return hasPermission ==
          PermissionStatus
              .granted; //  if the user didn't allow the app to get the location we will return false
    }

    return true;
  }

  changeDistancesetting(double? distanceFilter) {
    location.changeSettings(distanceFilter: distanceFilter);
  }

  getRealTimeLocation(void Function(LocationData)? onData) {
    location.onLocationChanged.listen(onData);
  }
}
