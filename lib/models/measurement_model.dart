import 'package:folly_fields/crud/abstract_model.dart';

///
///
///
class MeasurementModel extends AbstractModel<int> {
  double measure = 0;
  DateTime? date;
  String user = '';

  ///
  ///
  ///
  MeasurementModel();

  ///
  ///
  ///
  MeasurementModel.fromJson(Map<String, dynamic> map)
      : measure = map['measure'] ?? 0,
        date = map['date'],
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
    if (date != null) {
      map['date'] = date?.millisecondsSinceEpoch;
    }
    return map;
  }

  ///
  ///
  ///
  @override
  String get searchTerm => date.toString();

  ///
  ///
  ///
  @override
  String toString() => measure.toString();
}
