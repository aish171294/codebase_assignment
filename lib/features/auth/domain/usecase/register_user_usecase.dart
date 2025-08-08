

import 'package:code_base_assignment/features/auth/domain/entity/user_entity.dart';
import 'package:code_base_assignment/features/auth/domain/repository/user_repo.dart';

class RegisterUserUseCase {
  final UserRepository repository;

  RegisterUserUseCase(this.repository);

  Future<void> call(UserEntity user, String password) async {
    await repository.registerUser(user, password);
  }
}
