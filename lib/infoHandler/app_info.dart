

import 'package:flutter/cupertino.dart';

import '../models/directions.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation, userDropOffLocation;
  int countTotalTrips = 0;

  // List<String> historyTripsKeysList = [];
  // List<TripsHistoryModel> allTripsHistoryInfoList = [];

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress) {
    userPickUpLocation = dropOffAddress;
    notifyListeners();
  }

}