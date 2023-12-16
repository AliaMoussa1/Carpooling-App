import 'package:carpool/screens/ride_details_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class FindRidesScreen extends StatefulWidget {
  const FindRidesScreen({super.key});

  @override
  State<FindRidesScreen> createState() => _FindRidesScreenState();
}

class _FindRidesScreenState extends State<FindRidesScreen> {

  final TextEditingController searchFieldController = new TextEditingController();
  String searchText = "";
  var rideList = [];
  List filteredRides = [];
  Widget appBarTitle = const Text('Carpool');
  Icon searchIcon = const Icon(Icons.search, color: Colors.white);




  _FindRidesScreenState() {
    searchFieldController.addListener(() {
      if (searchFieldController.text.isEmpty) {
        setState(() {
          searchText = "";
          filteredRides = rideList;
        });
      } else {
        setState(() {
          searchText = searchFieldController.text;
        });
      }
    });
  }


  Future<List?> _getRideData() async {
    DatabaseReference ridesRef = FirebaseDatabase.instance.ref().child("rides");

    ridesRef.onChildAdded.listen((DatabaseEvent event) {
      Map data = event.snapshot.value as Map;
      print("Data is : ${data}");


      rideList.add(data);
      print("RideList: " "$rideList");

      // Check if the widget is mounted before updating the UI
      if (mounted) {
        setState(() {
          filteredRides = List.from(rideList.reversed);
        });
      }
    });


    try {
      return rideList;
    } catch (e) {
    }
  }




  // DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // Future<List?> _getRideData() async {
  //   DatabaseReference ridesRef = FirebaseDatabase.instance.ref().child("rides");
  //
  //   ridesRef.onChildAdded.listen((DatabaseEvent event) {
  //     String rideKey = event.snapshot.key ?? "";
  //     Map? data = event.snapshot.value as Map?;
  //
  //     if (data != null && data.containsKey('date')) {
  //       // Access the nested "date" key
  //       String dateString = data['date'] as String;
  //       DateTime rideDate = _parseRideDate(dateString);
  //
  //       // Check if the ride date is equal to or after today
  //       if (isTodayOrAfter(rideDate)) {
  //         // Add the ride data along with the rideKey to rideList
  //         rideList.add(data);
  //         print("RideList: " "$rideList");
  //
  //         // Check if the widget is mounted before updating the UI
  //         if (mounted) {
  //           setState(() {
  //             filteredRides = List.from(rideList.reversed);
  //           });
  //         }
  //       }
  //     }
  //   });


  @override
  void initState() {
    _getRideData().then(
          (data) {
        setState(() {
          if (data != null) {
            rideList = data;
            filteredRides = rideList;
          }
        });
      },
    );
    super.initState();
  }

  DateTime _parseRideDate(String dateString) {
    // Parse date in the format dd-MM-yyyy
    List<String> dateParts = dateString.split('-');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    return DateTime(year, month, day);
  }

  bool isTodayOrAfter(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    return date.isAtSameMomentAs(today) || date.isAfter(today);
  }


  @override
  Widget build(BuildContext context) {

    if (!(searchText.isEmpty)) {

      filteredRides = rideList.where((ride) {
        var rideDetails = ride.values.first;
        var startValue = rideDetails['start'].toLowerCase();
        var dstValue = rideDetails['dst'].toLowerCase();
        var searchTextLower = searchText.toLowerCase();

        return startValue.contains(searchTextLower) || dstValue.contains(searchTextLower);
      }).toList();

    } else {
      // Copy all rides when searchText is empty
      filteredRides = List.from(rideList.reversed);
      print("filteredRides is : ${rideList}");

    }


    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        backgroundColor: Colors.deepPurpleAccent,
        actions: <Widget>[
          IconButton(
            icon: searchIcon,

            onPressed: () {
                setState(() {
                  if (searchIcon.icon == Icons.search) {
                    searchIcon = const Icon(Icons.close, color: Colors.white);
                    appBarTitle = TextField(
                      controller: searchFieldController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white),
                        hintText: 'Search for your next ride',
                        fillColor: Colors.white54,
                      ),
                    );
                  } else {
                      searchIcon = const Icon(Icons.search, color: Colors.white);
                      appBarTitle = const Text('Carpool');
                      searchText = "";
                      searchFieldController.clear();
                  }
                });
              },
          ),
        ],
      ),


      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: filteredRides.length,
          itemBuilder: (BuildContext context, int index) {

            var rideMap = filteredRides[index];

            return Column(
              children: rideMap.entries.map<Widget>((entry) {
                var rideDetails = entry.value;
                // DateTime rideDate = _parseRideDate(rideDetails['date']);
                //
                // if (isTodayOrTomorrow(rideDate)) {
                //
                // }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        '${rideDetails['start']} To ${rideDetails['dst']}',
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        '${rideDetails['status']}\n${rideDetails['time']}\n${rideDetails['date']}',
                        style: TextStyle(color: Colors.black45, fontSize: 16),
                      ),
                      trailing: TextButton(
                        child: const Text(
                          'View',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (c) => RideDetailsScreen(ride: rideDetails, rideKey: entry.key), // assuming ride key is stored under 'key'
                            ),
                          );
                        },
                      ),
                      tileColor: Colors.deepPurpleAccent.shade100,
                    ),
                    SizedBox(height: 8.0), // Add vertical space using SizedBox
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
