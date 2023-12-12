import 'package:carpool/screens/login_screen.dart';
import 'package:carpool/screens/rides_history_screen.dart';
import 'package:flutter/material.dart';
import '../global/global.dart';
import 'find_rides_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // DBHelper mydb = DBHelper();
  List<Map> userData = [];


  Future Reading_Database() async {
    currentUser = firebaseAuth.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser!.uid;
        print(currentUserId);

      List<Map> response = await mydb.read('''SELECT * FROM Users WHERE ID = '$currentUserId' ''');

      userData = [];
      userData.addAll(response);

      setState(() {});
    }
  }

  @override
  void initState() {
    //Reading_Database()
    Reading_Database().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
    mydb.checkdata();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text('Carpool')
            )
          ],
        ),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : userData.isNotEmpty // Add this null check
    ?
    Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Profile',
                    key: ValueKey("edit"),
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 30
                    ),
                  )
                ),

                Card(
                  elevation: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.deepPurpleAccent[50]),
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 100,
                        ),


                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child:Text(
                            '${userData[0]['Name']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${userData[0]['Email']}',
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${userData[0]['Phone']}',
                            style: const TextStyle(fontSize: 17),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ): Center(
              child: Text(
                'No user data available.',
                style: TextStyle(fontSize: 18),
              ),
            ),

          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (i) => {
              if(i == 3) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false)
              }
              else if (i == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RidesHistoryScreen()))
              }
              else if (i == 1) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FindRidesScreen()))
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box),
                label: "Profile",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.manage_search_rounded),
                label: "Find Rides",
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart_rounded),
                label: "Rides History",
              ),
            ],
          ),
    );
  }
}

