// import 'dart:async';
//
// import 'package:carpool/global/global.dart';
// import 'package:carpool/screens/ride_details_screen.dart';
// import 'package:carpool/screens/ride_tracking_screen.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
//
// class RidesHistoryScreen extends StatefulWidget {
//
//   const RidesHistoryScreen({super.key});
//
//
//   @override
//   State<RidesHistoryScreen> createState() => _RidesHistoryScreenState();
// }
//
// class _RidesHistoryScreenState extends State<RidesHistoryScreen> {
//
//   var userRides = [];
//   bool isLoading = true;
//
//   Future<List?> _displpayUserRidesHistory() async {
//     DatabaseReference thisUserRidesRef = FirebaseDatabase.instance
//         .ref()
//         .child("users")
//         .child(currentUser!.uid)
//         .child("rides_requested");
//
//     await thisUserRidesRef.onChildAdded.listen((DatabaseEvent event) {
//       Map data = event.snapshot.value as Map;
//       String rideKey = event.snapshot.key ?? "";
//
//       print("Data is ${data}");
//
//       data["rideKey"] = rideKey;
//
//
//       userRides.add(data);
//       setState(() {
//         isLoading = false;
//       });
//     });
//
//     try{
//       return userRides;
//     } catch(e){
//       throw e;
//     }
//   }
//
//
//
//   // var updatedStatus;
//   // Future<String?> _getUpdatedStatus()  {
//   //   DatabaseReference thisUserRidesRef = FirebaseDatabase.instance
//   //       .ref()
//   //       .child("users")
//   //       .child(currentUser!.uid)
//   //       .child("rides_requested").child("request_status");
//   //
//   //   thisUserRidesRef.onValue.listen((DatabaseEvent event) {
//   //     final data = event.snapshot.value;
//   //
//   //
//   //     setState(() {
//   //       updatedStatus = data;
//   //     });
//   //   });
//   //
//   //   return updatedStatus;
//   // }
//
//   // late String updatedStatus; // Initialize it with an empty string or null
//   //
//   // late Completer<String?> statusCompleter = Completer<String?>();
//   //
//   // Future<String?> _getUpdatedStatus() {
//   //   DatabaseReference thisUserRidesRef = FirebaseDatabase.instance
//   //       .ref()
//   //       .child("users")
//   //       .child(currentUser!.uid)
//   //       .child("rides_requested")
//   //       .child("request_status");
//   //
//   //   thisUserRidesRef.onValue.listen((DatabaseEvent event) {
//   //     final data = event.snapshot.value;
//   //     print("Data is: ${data}");
//   //
//   //     setState(() {
//   //       updatedStatus = data as String;
//   //     });
//   //
//   //     // Complete the Future when the value is available
//   //     statusCompleter.complete(updatedStatus);
//   //   });
//   //
//   //   return statusCompleter.future;
//   // }
//
//
//
//
//   @override
//   void initState() {
//     //
//     super.initState();
//
//     _displpayUserRidesHistory().then(
//             (data) {
//               setState(() {
//                 if(data != null){
//                   userRides = data;
//                 }
//               });
//             });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Carpool"),
//       ),
//
//       body: isLoading
//       ?
//       Center(child: CircularProgressIndicator())
//       :
//       Center(
//         child: ListView.builder(
//           padding: const EdgeInsets.all(8),
//           itemCount: userRides.length,
//           itemBuilder: (BuildContext context, int index) {
//
//             var rideMap = userRides[index];
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ListTile(
//                   title: Text(
//                     '${rideMap['start']} To ${rideMap['dst']}',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   subtitle: Text(
//                     '${rideMap['status']}\n${rideMap['time']}\n ${rideMap['date']}',
//                     style: TextStyle(color: Colors.black45, fontSize: 16),
//                   ),
//                   trailing: TextButton(
//                     child: Text(
//                       "${rideMap["request_status"]}",
//                       // '${rideMap["request_status"]}',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (c) => RideTrackingScreen(ride : rideMap ,rideKey: rideMap['rideKey']), // assuming ride key is stored under 'key'
//                         ),
//                       );
//                     },
//                   ),
//                   tileColor: Colors.deepPurpleAccent.shade100,
//                 ),
//                 SizedBox(height: 8.0,),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


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

// class _RidesHistoryScreenState extends State<RidesHistoryScreen> {
//
//   var userRides = [];
//   bool isLoading = true;
//   Set<String> existingRideKeys = Set<String>();
//
//   Future<List?> _displpayUserRidesHistory() async {
//     DatabaseReference thisUserRidesRef = FirebaseDatabase.instance
//         .ref()
//         .child("users")
//         .child(currentUser!.uid)
//         .child("rides_requested");
//
//     thisUserRidesRef.onValue.listen((DatabaseEvent event) {
//       Map data = event.snapshot.value as Map;
//
//       print("Data is ${data}");
//
//       // data["rideKey"] = rideKey;
//
//       userRides.add(data);
//       print("UserRides is : ${userRides}");
//
//       setState(() {
//         isLoading = false;
//       });
//     });
//
//     try{
//       return userRides;
//     } catch(e){
//       throw e;
//     }
//   }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     _displpayUserRidesHistory().then(
//             (data) {
//           setState(() {
//             if(data != null){
//               userRides = data;
//             }
//           });
//         });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Carpool"),
//       ),
//
//       body: isLoading
//           ?
//       Center(child: CircularProgressIndicator())
//           :
      // Center(
        // child: ListView.builder(
        //   padding: const EdgeInsets.all(8),
        //   itemCount: userRides.length,
        //   itemBuilder: (BuildContext context, int index) {
        //
        //     var rideMap = userRides[index];
        //     print("UserRides[${index}] is ${userRides[index]}");
        //     print("RideMap is : ${rideMap}");
        //
        //     if(rideMap is Map){
        //       print("is map!!");
        //       return Column(
        //         children: rideMap.entries.map<Widget>((entry) {
        //           var rideDetails = entry.value;
        //           print("Ride Details is : ${rideDetails}");
        //           print("Ride Details type is : ${rideDetails.runtimeType}");
        //
        //           return Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               ListTile(
        //                 title: Text(
        //                   '${rideDetails?['start']} To ${rideDetails?['dst']}',
        //                   style: TextStyle(color: Colors.black),
        //                 ),
        //                 subtitle: Text(
        //                   '${rideDetails?['status']}\n${rideDetails?['time']}\n${rideDetails?['date']}',
        //                   style: TextStyle(color: Colors.black45, fontSize: 16),
        //                 ),
        //                 trailing: TextButton(
        //                   child: Text(
        //                     "${rideDetails?["request_status"]}",
        //                     style: TextStyle(color: Colors.white, fontSize: 16),
        //                   ),
        //                   onPressed: () {
        //                     Navigator.push(
        //                       context,
        //                       MaterialPageRoute(builder: (c) => RideTrackingScreen(ride : rideMap ,rideKey: rideMap['rideKey']), // assuming ride key is stored under 'key'
        //                       ),
        //                     );
        //                   },
        //                 ),
        //                 tileColor: Colors.deepPurpleAccent.shade100,
        //               ),
        //               SizedBox(height: 8.0), // Add vertical space using SizedBox
        //             ],
        //           );
        //         }).toList(),
        //       );
        //
        //     }
        //
        //   },
        // ),
      // ),

//       Center(
//         child: ListView.builder(
//           padding: const EdgeInsets.all(8),
//           itemCount: userRides.length,
//           itemBuilder: (BuildContext context, int index) {
//             var rideMap = userRides[index];
//             print("UserRides[${index}] is ${userRides[index]}");
//             print("RideMap is : ${rideMap}");
//
//             if (rideMap is Map) {
//               print("is map!!");
//               String rideKey = rideMap.keys.first; // Use the unique key
//
//               // Check if the key already exists in userRides
//               int existingIndex = userRides.indexWhere((entry) => entry.keys.first == rideKey);
//
//               // If the key exists, update the existing entry
//               if (existingIndex != -1) {
//                 userRides[existingIndex] = rideMap;
//               }
//
//               return Column(
//                 children: rideMap.entries.map<Widget>((entry) {
//                   var rideDetails = entry.value;
//                   print("Ride Details is : ${rideDetails}");
//                   print("Ride Details type is : ${rideDetails.runtimeType}");
//
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ListTile(
//                         title: Text(
//                           '${rideDetails?['start']} To ${rideDetails?['dst']}',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         subtitle: Text(
//                           '${rideDetails?['status']}\n${rideDetails?['time']}\n${rideDetails?['date']}',
//                           style: TextStyle(color: Colors.black45, fontSize: 16),
//                         ),
//                         trailing: TextButton(
//                           child: Text(
//                             "${rideDetails?["request_status"]}",
//                             style: TextStyle(color: Colors.white, fontSize: 16),
//                           ),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (c) => RideTrackingScreen(
//                                   ride: rideDetails,
//                                   rideKey: rideKey,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         tileColor: Colors.deepPurpleAccent.shade100,
//                       ),
//                       SizedBox(height: 8.0),
//                     ],
//                   );
//                 }).toList(),
//               );
//             } else {
//               return Container();
//             }
//           },
//         ),
//       ),
//
//     );
//   }
// }


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
