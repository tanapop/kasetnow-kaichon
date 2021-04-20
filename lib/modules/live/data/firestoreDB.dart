import 'package:path/path.dart' as Path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class FireStoreClass {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final liveUserCollection = 'liveuser';
  static final userCollection = 'users';
  static final emailCollection = 'user_email';

  static Future<String> getImage({String userId}) async {
    final snapShot = await _db.collection(userCollection).doc(userId).get();
    return snapShot.data()['photoURL'].toString();
  }

  static Future<String> getName({String userId}) async {
    final snapShot = await _db.collection(userCollection).doc(userId).get();
    return snapShot.data()["fullName"].toString();
  }
}
