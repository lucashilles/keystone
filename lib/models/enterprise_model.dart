import 'package:folly_fields/crud/abstract_model.dart';
import 'package:keystone/models/measurement_model.dart';
import 'package:keystone/models/user_model.dart';

///
///
///
class EnterpriseModel extends AbstractModel<int> {
  String city = '';
  String cpfcnpj = '';
  String equation = '';
  String fantasyName = '';
  String latitude = '';
  String longitude = '';
  List<MeasurementModel>? measures;
  String name = '';
  UserModel? owner;
  UserModel? responsible;
  String state = '';

  ///
  ///
  ///
  EnterpriseModel();

  ///
  ///
  ///
  EnterpriseModel.fromJson(Map<String, dynamic> map)
      : city = map['city'] ?? '',
        cpfcnpj = map['cpfcnpj'] ?? '',
        equation = map['equation'] ?? '',
        fantasyName = map['fantasyName'] ?? '',
        latitude = map['latitude'] ?? '',
        longitude = map['longitude'] ?? '',
        measures = map['measures'] != null
            ? (map['measures'] as List<dynamic>)
                .map((dynamic map) => MeasurementModel.fromJson(map))
                .toList()
            : null,
        name = map['name'] ?? '',
        owner = map['owner'] != null ? UserModel.fromJson(map['owner']) : null,
        responsible = map['responsible'] != null
            ? UserModel.fromJson(map['responsible'])
            : null,
        state = map['state'] ?? '',
        super.fromJson(map);

  ///
  ///
  ///
  @override
  EnterpriseModel fromJson(Map<String, dynamic> map) =>
      EnterpriseModel.fromJson(map);

  ///
  ///
  ///
  @override
  EnterpriseModel fromMulti(Map<String, dynamic> map) =>
      EnterpriseModel.fromJson(AbstractModel.fromMultiMap(map));

  ///
  ///
  ///
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map['city'] = city;
    map['cpfcnpj'] = cpfcnpj;
    map['equation'] = equation;
    map['fantasyName'] = fantasyName;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    if (measures != null) {
      map['measures'] =
          measures?.map((MeasurementModel model) => model.toMap()).toList();
    }
    map['name'] = name;
    if (owner != null) {
      map['owner'] = owner?.toMap();
    }
    if (responsible != null) {
      map['responsible'] = responsible?.toMap();
    }
    map['state'] = state;
    return map;
  }

  ///
  ///
  ///
  @override
  String get searchTerm => cpfcnpj;

  ///
  ///
  ///
  @override
  String toString() => cpfcnpj;
}
