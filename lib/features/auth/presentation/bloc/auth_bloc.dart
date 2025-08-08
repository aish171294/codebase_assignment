
import 'package:code_base_assignment/core/utils/constants/app_constants.dart';
import 'package:code_base_assignment/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:code_base_assignment/features/auth/domain/usecase/register_user_usecase.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RegisterUserUseCase registerUserUseCase;
  final LoginUserUseCase loginUserUseCase;

  AuthBloc({
    required this.registerUserUseCase,
    required this.loginUserUseCase,
    FirebaseAuth? firebaseAuth,
}) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }


  Future<void> _onLoginSubmitted(
      LoginSubmitted event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final email = event.email.trim();
    final password = event.password.trim();
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (!emailRegex.hasMatch(email)) {
      emit(AuthFailure(AppConstants.pleaseEnterAValidEmailAddress));
      return;
    }

    if (password.length < 6) {
      emit(AuthFailure(AppConstants.passwordMustBeAtLeastSixCharactersLong));
      return;
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      if (userId == null) {
        emit(AuthFailure("User data not found."));
      }

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == AppConstants.userNotFound) {
        emit(AuthFailure(AppConstants.userNotRegistered));
      } else if (e.code == AppConstants.wrongPassword) {
        emit(AuthFailure(AppConstants.incorrectPassword));
      } else {
        emit(AuthFailure(e.message ?? AppConstants.loginFailed));
      }
    } catch (e) {
      emit(AuthFailure(AppConstants.somethingWentWrongPleaseTryAgain));
    }
  }




  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final name = event.name.trim();
    final email = event.email.trim();
    final password = event.password.trim();
    final confirmPassword = event.confirmPassword.trim();

    if (name.isEmpty) {
      emit(AuthFailure(AppConstants.nameCannotBeEmpty));
      return;
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      emit(AuthFailure(AppConstants.pleaseEnterAValidEmailAddress));
      return;
    }

    if (password.length < 6) {
      emit(AuthFailure(AppConstants.passwordMustBeAtLeastSixCharactersLong));
      return;
    }

    if (password != confirmPassword) {
      emit(AuthFailure(AppConstants.passwordsDoNotMatch));
      return;
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        emit(AuthFailure(AppConstants.userCreationFailed));
        return;
      }

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == AppConstants.emailAlreadyInUse) {
        emit(AuthFailure(AppConstants.theEmailAddressIsAlreadyInUseByAnotherAccount));
        return;
      }
      emit(AuthFailure('${AppConstants.registrationFailed} ${e.message}'));
      return;
    } catch (e) {
      emit(AuthFailure(AppConstants.somethingWentWrongPleaseTryAgain));
    }
  }
}


