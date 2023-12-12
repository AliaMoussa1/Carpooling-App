import 'package:carpool/screens/rides_history_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';


class RideDetailsScreen extends StatefulWidget {
  final ride;
  final String rideKey;

  const RideDetailsScreen({Key? key, required this.ride, required this.rideKey}) : super(key: key);

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}


class _RideDetailsScreenState extends State<RideDetailsScreen> {

  DateTime tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);


  Future<void>  _requestRide(String rideKey) async{

    if(DateTime.now().hour > 22 && widget.ride['time'] == "Morning Ride: 7:30 am" && widget.ride['date'] == DateFormat('dd-MM-yyyy').format(tomorrow)){
      Fluttertoast.showToast(msg: "Can't request morning ride after 10 pm");
      return;
    }

    if(DateTime.now().hour > 13 && widget.ride['time'] == "Afternoon Ride: 5:30 pm" && widget.ride['date'] == DateFormat('dd-MM-yyyy').format(today)){
      Fluttertoast.showToast(msg: "Can't request afternoon ride after 1 pm");
      return;
    }

    // Check if the ride's date is before today
    DateTime rideDate = DateFormat('dd-MM-yyyy').parse(widget.ride['date']);
    if (rideDate.isBefore(today)) {
      Fluttertoast.showToast(msg: "Can't request ride because it is expired!");
      return;
    }

    if(widget.ride['status'] == "In Progress" ||
        widget.ride['status'] == "No Seats" ||
        widget.ride['status'] == "Completed"){
      Fluttertoast.showToast(msg: "Ride is expired!");
      return;
    }

    DatabaseReference rideRequestsRef = FirebaseDatabase.instance.ref().child("rideRequests");

    Map<String, dynamic> requestMap = {
      currentUser!.uid: {
        "request_status": "pending",
      },
    };

    await rideRequestsRef.child(rideKey).set(requestMap);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(8.0), child: Text('Carpool'))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Ride Detail',
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 25
                ),
              ),
            ),

            Card(
              elevation: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.deepPurpleAccent.shade100),
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 100,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Date: ' + '${widget.ride['date']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Time: ' + '${widget.ride['time']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Status: ' + '${widget.ride['status']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Gate: ' + '${widget.ride['gate']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Start: ' + '${widget.ride['start']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Destination: ' + '${widget.ride['dst']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Stop 1: ' + '${widget.ride['stop_1']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Stop 2: ' + '${widget.ride['stop_2']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Stop 3: ' + '${widget.ride['stop_3']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Stop 4: ' + '${widget.ride['stop_4']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Stop 5: ' + '${widget.ride['stop_5']}',
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
                          'Price: ' + '${widget.ride['price']}',
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
                          'Driver: ' + '${widget.ride['driver']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Phone: ' + '${widget.ride['phone']}',
                          style: const TextStyle(fontSize: 17,),
                        ),
                      ),



                    ],
                  ),
                ),
              ),
            ),


            ElevatedButton(
              onPressed: () {

                //Send request to driver and check time and date conditions
                _requestRide(widget.rideKey);

                Navigator.push(context, MaterialPageRoute(builder: (c) => RidesHistoryScreen()));

              },
              child: const Text(
                'Request',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            )


          ],
        ),


      ),
    );
  }
}
