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

      data.forEach((key, mapB) {
        print("MapB is: ${mapB}");

        // Access the "date" value from mapC
        String date = mapB["date"];

        DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        DateTime rideDate = DateFormat('dd-MM-yyyy').parse(date);

        // Show only the rides that are available today or after today,
        // don't show any rides whose status is No Seats, Completed, or In Progress,
        // and definitely don't show any rides from previous days
        if ((rideDate.isAfter(todayDate) || rideDate.isAtSameMomentAs(todayDate)) && mapB["status"] == "Available") {
          // Create a new map where the key is taken from the outer loop (key) and the value is mapB
          Map<String, dynamic> rideDataWithKey = {key: mapB};

          print("RideDataWithKey is: $rideDataWithKey");

          // Add the new map to rideList
          rideList.add(rideDataWithKey);

          print("RideList: $rideList");

          // Check if the widget is mounted before updating the UI
          if (mounted) {
            setState(() {
              filteredRides = List.from(rideList);
            });
          }
        }
      });
    });

  try {
      return rideList;
    } catch (e) {
      throw e;
    }
  }

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
      setState(() {
        filteredRides = List.from(rideList);
      });
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
            print("FilteredRide[${index}] is: ${filteredRides[index]}");

            return Column(
              children: rideMap.entries.map<Widget>((entry) {
                var rideDetails = entry.value;
                // print("Ride Details type is : ${rideDetails.runtimeType}");

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
