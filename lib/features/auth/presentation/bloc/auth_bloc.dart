
import 'package:code_base_assignment/core/utils/constants/app_constants.dart';
import 'package:code_base_assignment/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:code_base_assignment/features/auth/domain/usecase/register_user_usecase.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_event.dart';
import 'package:code_base_assignment/features/auth/presentation/bloc/auth_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }


  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    await Future.delayed(const Duration(seconds: 1)); // simulate loading

    final isLoggedIn = await isUserLoggedIn();

    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }


  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('isLoggedIn', true);
  }

  Future<void> setUserLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    emit(Unauthenticated()); // so UI knows user is logged out
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
      emit(AuthFailure(AppConstants.pleaseEnterAValidEmailAddress.tr()));
      return;
    }

    if (password.length < 6) {
      emit(AuthFailure(AppConstants.passwordMustBeAtLeastSixCharactersLong.tr()));
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
        emit(AuthFailure(AppConstants.userNotRegistered.tr()));
      } else if (e.code == AppConstants.wrongPassword) {
        emit(AuthFailure(AppConstants.incorrectPassword.tr()));
      } else {
        emit(AuthFailure(e.message ?? AppConstants.loginFailed.tr()));
      }
    } catch (e) {
      emit(AuthFailure(AppConstants.somethingWentWrongPleaseTryAgain.tr()));
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
      emit(AuthFailure(AppConstants.nameCannotBeEmpty.tr()));
      return;
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      emit(AuthFailure(AppConstants.pleaseEnterAValidEmailAddress.tr()));
      return;
    }

    if (password.length < 6) {
      emit(AuthFailure(AppConstants.passwordMustBeAtLeastSixCharactersLong.tr()));
      return;
    }

    if (password != confirmPassword) {
      emit(AuthFailure(AppConstants.passwordsDoNotMatch.tr()));
      return;
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        emit(AuthFailure(AppConstants.userCreationFailed.tr()));
        return;
      }

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == AppConstants.emailAlreadyInUse) {
        emit(AuthFailure(AppConstants.theEmailAddressIsAlreadyInUseByAnotherAccount.tr()));
        return;
      }
      emit(AuthFailure('${AppConstants.registrationFailed.tr()} ${e.message}'));
      return;
    } catch (e) {
      emit(AuthFailure(AppConstants.somethingWentWrongPleaseTryAgain.tr()));
    }
  }
}


