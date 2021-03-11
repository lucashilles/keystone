enum UserType {
  ENGINEER,
  EMPLOYEE,
  ENTREPRENEUR,
  UNKNOWN,
}

///
///
///
class UserTypeModel {
  UserType value;

  ///
  ///
  ///
  UserTypeModel({this.value = UserType.UNKNOWN});

  ///
  ///
  ///
  static Map<UserType, String> getItems() =>
      Map<UserType, String>.unmodifiable(<UserType, String>{
        UserType.UNKNOWN: 'Não selecionado',
        UserType.ENTREPRENEUR: 'Empreendedor',
        UserType.ENGINEER: 'Engenheiro',
        UserType.EMPLOYEE: 'Funcionário',
      });

  ///
  ///
  ///
  static UserTypeModel fromJson(String value) {
    switch (value) {
      case 'ENGINEER':
        return UserTypeModel(value: UserType.ENGINEER);
      case 'EMPLOYEE':
        return UserTypeModel(value: UserType.EMPLOYEE);
      case 'ENTREPRENEUR':
        return UserTypeModel(value: UserType.ENTREPRENEUR);
    }
    return UserTypeModel(value: UserType.UNKNOWN);
  }

  ///
  ///
  ///
  String toMap() {
    switch (value) {
      case UserType.ENGINEER:
        return 'ENGINEER';
      case UserType.EMPLOYEE:
        return 'EMPLOYEE';
      case UserType.ENTREPRENEUR:
        return 'ENTREPRENEUR';
      default:
        return 'UNKNOWN';
    }
  }

  ///
  ///
  ///
  @override
  int get hashCode => value.hashCode;

  ///
  ///
  ///
  @override
  bool operator ==(Object other) => value == (other as UserTypeModel).value;
}
