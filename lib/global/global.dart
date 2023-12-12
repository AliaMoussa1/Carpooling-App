import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'db_helper.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;
DBHelper mydb = DBHelper();

