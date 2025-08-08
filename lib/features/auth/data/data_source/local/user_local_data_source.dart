import 'package:hive/hive.dart';

import '../../model/user_model.dart';

class UserLocalDataSource {
  final Box<UserModel> userBox;

  UserLocalDataSource(this.userBox);

  Future<void> saveUserLocally(UserModel user) async {
    print("save user locally ${user.uid}");
    await userBox.put(user.uid, user);
  }


  Future<UserModel?> getUserFromHive() async {
    return userBox.get('user');
  }

  Future<void> clearUserFromHive() async {
    await userBox.clear();
  }
}


