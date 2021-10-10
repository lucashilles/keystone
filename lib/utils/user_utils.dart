import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keystone/config.dart';

class UserUtils {
  static Future<void> addEnterprise(String enterprisePath) async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await Config.getInstance()
            .firebaseFirestore
            .collection('users')
            .doc(Config.getInstance().firebaseAuth.currentUser?.uid)
            .get();

    var enterpriseList = userSnapshot.data()!['enterprises'] as List<dynamic>;
    if (!enterpriseList.contains(enterprisePath)) {
      enterpriseList.add(enterprisePath);
    }

    userSnapshot.reference.update({'enterprises': enterpriseList});
  }
}
