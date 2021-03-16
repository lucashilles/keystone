import 'package:folly_fields/crud/abstract_model.dart';

///
///
///
class MeasurementModel extends AbstractModel<int> {
  double measure = 0;
  DateTime? measureDate;

  ///
  ///
  ///
  MeasurementModel();

  ///
  ///
  ///
  MeasurementModel.fromJson(Map<String, dynamic> map)
      : measure = map['measure'] ?? 0,
        measureDate = map['measureDate'] != null && map['measureDate'] >= 0
            ? DateTime.fromMillisecondsSinceEpoch(map['measureDate'])
            : DateTime.now(),
        super.fromJson(map);

  ///
  ///
  ///
  @override
  MeasurementModel fromJson(Map<String, dynamic> map) =>
      MeasurementModel.fromJson(map);

  ///
  ///
  ///
  @override
  MeasurementModel fromMulti(Map<String, dynamic> map) =>
      MeasurementModel.fromJson(AbstractModel.fromMultiMap(map));

  ///
  ///
  ///
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map['measure'] = measure;
    if (measureDate != null) {
      map['measureDate'] = measureDate?.millisecondsSinceEpoch;
    }
    return map;
  }

  ///
  ///
  ///
  @override
  String get searchTerm => measureDate.toString();

  ///
  ///
  ///
  @override
  String toString() => measure.toString();
}
