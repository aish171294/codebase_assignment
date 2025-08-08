import 'package:code_base_assignment/features/auth/domain/repository/user_repo.dart';

import '../../domain/entity/user_entity.dart';
import '../data_source/remote/user_remote_data_source.dart';
import '../model/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> registerUser(UserEntity user, String password) async {
    final userCredential = await remoteDataSource.createUser(
      user.email,
      password,
    );

    final uid = userCredential.user!.uid;
    final newUser = UserModel(uid: uid, name: user.name, email: user.email);

    await remoteDataSource.saveUserToFirestore(newUser);
  }

  @override
  Future<UserEntity> loginUser(String email, String password) async {
    final userCredential = await remoteDataSource.loginUser(email, password);

    final user = UserModel(
      uid: userCredential.user!.uid,
      email: userCredential.user!.email!,
      name: "",
    );

    return user;
  }
}
