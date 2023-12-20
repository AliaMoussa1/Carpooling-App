import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';

class RideTrackingScreen extends StatefulWidget {
  final ride;
  final String rideKey;
  const RideTrackingScreen({super.key, required this.ride, required this.rideKey});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {

  Map<String, dynamic>? rideDetails;
  bool isLoading = true;

  Future<void> _displayRideTracking() async {
    DatabaseReference thisDriverRidesRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentUser!.uid)
        .child("rides_requested")
        .child(widget.rideKey);

    await thisDriverRidesRef.onValue.listen((DatabaseEvent event) {
      Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        // Explicitly cast to Map<String, dynamic>
        rideDetails = Map<String, dynamic>.from(data);
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _displayRideTracking();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(padding: const EdgeInsets.all(8.0), child: Text('Carpool')),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    'Ride Tracking',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 25
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text(
                    '${rideDetails?["request_status"]}',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 8.0,
              margin: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.shade100),
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.drive_eta,
                        size: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Date: ' + '${rideDetails?['date']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Time: ' + '${rideDetails?['time']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Status: ' + '${rideDetails?['status']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Gate: ' + '${rideDetails?['gate']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Start: ' + '${rideDetails?['start']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Destination: ' + '${rideDetails?['dst']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Stop 1: ' + '${rideDetails?['stop_1']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Stop 2: ' + '${rideDetails?['stop_2']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Stop 3: ' + '${rideDetails?['stop_3']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Stop 4: ' + '${rideDetails?['stop_4']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Stop 5: ' + '${rideDetails?['stop_5']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Divider(
                        color: Colors.black,
                        thickness: 3,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Price: ' + '${rideDetails?['price']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Divider(
                        color: Colors.black,
                        thickness: 3,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Driver: ' + '${rideDetails?['driver']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Phone: ' + '${rideDetails?['phone']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

