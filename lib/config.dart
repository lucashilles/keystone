import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:folly_fields/folly_fields.dart';

class Config extends AbstractConfig {
  static final Config _singleton = Config._internal();

  late FirebaseAuth _firebaseAuth;
  late FirebaseFirestore _firebaseFirestore;

  Config._internal();

  factory Config([FirebaseAuth? auth, FirebaseFirestore? firestore]) {
    _singleton._firebaseAuth = auth ?? FirebaseAuth.instance;
    _singleton._firebaseFirestore = firestore ?? FirebaseFirestore.instance;
    return _singleton;
  }

  static Config getInstance() {
    return _singleton;
  }

  FirebaseFirestore get firebaseFirestore => _firebaseFirestore;

  FirebaseAuth get firebaseAuth => _firebaseAuth;
}
