import 'package:flutter/cupertino.dart';
import 'package:folly_fields/crud/abstract_model.dart';
import 'package:folly_fields/util/decimal.dart';

///
///
///
class EnterpriseModel extends AbstractModel<String> {
  String basin = '';
  String city = '';
  String clientCpfCnpj = '';
  String clientName = '';
  double distance = 0;
  String engineer = '';
  String engineerCpfCnpj = '';
  String engineerRegistry = '';
  String equation = '';
  String latitude = '';
  String longitude = '';
  String owner = '';
  String password = '';
  String river = '';
  String state = '';
  String subBasin = '';
  bool active = true;

  ///
  ///
  ///
  EnterpriseModel();

  ///
  ///
  ///
  EnterpriseModel.fromJson(Map<String, dynamic> map)
      : basin = map['basin'] ?? '',
        city = map['city'] ?? '',
        clientCpfCnpj = map['clientCpfCnpj'] ?? '',
        clientName = map['clientName'] ?? '',
        distance = map['distance'],
        engineer = map['engineer'] ?? '',
        engineerCpfCnpj = map['engineerCpfCnpj'] ?? '',
        engineerRegistry = map['engineerRegistry'] ?? '',
        equation = map['equation'] ?? '',
        latitude = map['latitude'] ?? '',
        longitude = map['longitude'] ?? '',
        owner = map['owner'] ?? '',
        password = map['password'] ?? '',
        river = map['river'] ?? '',
        state = map['state'] ?? '',
        subBasin = map['subBasin'] ?? '',
        active = map['active'] ?? true,
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
    map['basin'] = basin;
    map['city'] = city;
    map['clientCpfCnpj'] = clientCpfCnpj;
    map['clientName'] = clientName;
    map['distance'] = distance;
    map['engineer'] = engineer;
    map['engineerCpfCnpj'] = engineerCpfCnpj;
    map['engineerRegistry'] = engineerRegistry;
    map['equation'] = equation;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['owner'] = owner;
    map['password'] = password;
    map['river'] = river;
    map['state'] = state;
    map['subBasin'] = subBasin;
    map['active'] = active;
    return map;
  }

  ///
  ///
  ///
  @override
  String get searchTerm => clientName;

  ///
  ///
  ///
  @override
  String toString() => clientName;
}
