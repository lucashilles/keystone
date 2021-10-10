import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keystone/config.dart';
import 'package:keystone/models/measurement_model.dart';

class MeasurementUtils {
  static Future<void> addMeasure(
      {required String enterpriseId, required MeasurementModel measure}) async {
    measure.user = Config.getInstance().firebaseAuth.currentUser!.uid;
    await Config.getInstance()
        .firebaseFirestore
        .collection('enterprises')
        .doc(enterpriseId)
        .collection('measurements')
        .add(measure.toMap());
  }

  static void removeMeasure(
      QueryDocumentSnapshot<Map<String, dynamic>> measure) async {
    await measure.reference.delete();
  }
}
