
import 'package:code_base_assignment/features/auth/domain/entity/user_entity.dart';
import 'package:code_base_assignment/features/auth/domain/repository/user_repo.dart';

class LoginUserUseCase {
  final UserRepository repository;

  LoginUserUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.loginUser(email, password);
  }
}
