import 'dart:async';

import 'package:carpool/global/global.dart';
import 'package:carpool/screens/ride_details_screen.dart';
import 'package:carpool/screens/ride_tracking_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RidesHistoryScreen extends StatefulWidget {

  const RidesHistoryScreen({super.key});


  @override
  State<RidesHistoryScreen> createState() => _RidesHistoryScreenState();
}


class _RidesHistoryScreenState extends State<RidesHistoryScreen> {
  var userRides = [];
  bool isLoading = true;

  Future<List?> _displayUserRidesHistory() async {
    DatabaseReference thisUserRidesRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentUser!.uid)
        .child("rides_requested");

    await thisUserRidesRef.onValue.listen((DatabaseEvent event) {
      Map<String, dynamic> data = (event.snapshot.value as Map)?.cast<String, dynamic>() ?? {};

      data.forEach((String rideKey, dynamic rideDetails) {
        if (rideDetails is Map<dynamic, dynamic>) {
          print("Ride Key is: $rideKey");
          print("Ride Details is : $rideDetails");

          int existingIndex = userRides.indexWhere((entry) => entry.keys.first == rideKey);

          if (existingIndex != -1) {
            userRides[existingIndex] = {rideKey: rideDetails};
          } else {
            userRides.add({rideKey: rideDetails});
          }
        }
      });

      setState(() {
        isLoading = false;
      });
    });

    try {
      return userRides;
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();

    _displayUserRidesHistory().then((data) {
      setState(() {
        if (data != null) {
          userRides = data;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carpool"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: userRides.length,
          itemBuilder: (BuildContext context, int index) {
            var rideMap = userRides[index];
            String rideKey = rideMap.keys.first; // Use the unique key

            return Column(
              children: rideMap.entries.map<Widget>((entry) {
                var rideDetails = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        '${rideDetails?['start']} To ${rideDetails?['dst']}',
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        '${rideDetails?['status']}\n${rideDetails?['time']}\n${rideDetails?['date']}',
                        style: TextStyle(color: Colors.black45, fontSize: 16),
                      ),
                      trailing: TextButton(
                        child: Text(
                          "${rideDetails?["request_status"]}",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => RideTrackingScreen(
                                ride: rideDetails,
                                rideKey: rideKey,
                              ),
                            ),
                          );
                        },
                      ),
                      tileColor: Colors.deepPurpleAccent.shade100,
                    ),
                    SizedBox(height: 8.0),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
