import 'package:carpool/assistants/request_assistant.dart';
import 'package:carpool/global/global.dart';
import 'package:carpool/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import '../global/map_key.dart';



class AssistantMethods{

  static void readCurrentOnlineUserInfo() async{
    currentUser = firebaseAuth.currentUser;
    // DBHelper mydb =DBHelper();

    DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child("users")
      .child(currentUser!.uid);

    userRef.once().then( (snap) async {
      if(snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);

        // Convert UserModel to a map
        Map<String, dynamic> userMap = {
          "id": userModelCurrentInfo!.id,
          "name": userModelCurrentInfo!.name,
          "email": userModelCurrentInfo!.email,
          "phone": userModelCurrentInfo!.phone,
        };

        // await mydb.write('''INSERT INTO Users
        //     (ID, Name, Email, Phone) VALUES ('${userModelCurrentInfo!.id}', '${userModelCurrentInfo!.name}', '${userModelCurrentInfo!.email}', '${userModelCurrentInfo!.phone}')''');
      }
    });
  }





}

