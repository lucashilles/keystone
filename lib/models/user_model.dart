import 'package:folly_fields/crud/abstract_model.dart';
import 'package:keystone/models/user_type_model.dart';

///
///
///
class UserModel extends AbstractModel<String> {
  String cpfcnpj = '';
  String email = '';
  String name = '';
  String registerNumber = '';
  UserTypeModel type = UserTypeModel(value: UserType.UNKNOWN);

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
        registerNumber = map['registerNumber'] ?? '',
        type = map['type'] != null
            ? UserTypeModel.fromJson(map['type'])
            : UserTypeModel(value: UserType.UNKNOWN),
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
    map['registerNumber'] = registerNumber;
    map['type'] = type.toMap();

    return map;
  }

  ///
  ///
  ///
  @override
  String get searchTerm => '';

  ///
  ///
  ///
  @override
  String toString() => name;
}
