import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:folly_fields/crud/abstract_model.dart';

///
///
///
class UserModel extends AbstractModel<String> {
  String cpfcnpj = '';
  String email = '';
  String name = '';
  String password = '';
  List<String> enterprises = <String>[];

  ///
  ///
  ///
  UserModel();

  ///
  ///
  ///
  UserModel.fromJson(Map<String, dynamic> map)
      : cpfcnpj = map['cpfcnpj'] ?? '',
        email = map['email'] ?? '',
        name = map['name'] ?? '',
        enterprises = map['enterprises'] ?? <String>[],
        super.fromJson(map);

  ///
  ///
  ///
  @override
  UserModel fromJson(Map<String, dynamic> map) => UserModel.fromJson(map);

  ///
  ///
  ///
  @override
  UserModel fromMulti(Map<String, dynamic> map) =>
      UserModel.fromJson(AbstractModel.fromMultiMap(map));

  ///
  ///
  ///
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    map['cpfcnpj'] = cpfcnpj;
    map['email'] = email;
    map['name'] = name;
    map['enterprises'] = enterprises;
    return map;
  }

  ///
  ///
  ///
  @override
  String get searchTerm => name;

  ///
  ///
  ///
  @override
  String toString() => name;
}
