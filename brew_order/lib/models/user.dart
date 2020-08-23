class User {      //whatt instances we want for firebase authentication

  final String uid;

  User({this.uid});
}


class UserData{
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({this.uid, this.name, this.sugars, this.strength});
}