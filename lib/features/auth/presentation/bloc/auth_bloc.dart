import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unauthenticated()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignInWithEmailPassword>(_onSignInWithEmailPassword);
    on<SignUp>(_onSignUp);
    on<ForgotPassword>(_onForgotPassword);
    on<SignOut>(_onSignOut);

    _authRepository.authStateChanges.listen(
      (user) => add(AuthStatusChanged(user)),
    );
  }

  void _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) {
    event.user != null
        ? emit(AuthState.authenticated(event.user!))
        : emit(const AuthState.unauthenticated());
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.signInWithGoogle();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onSignInWithEmailPassword(
    SignInWithEmailPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.signInWithEmailAndPassword(
      event.email,
      event.password,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onSignUp(
    SignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.signUp(
      event.email,
      event.password,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onForgotPassword(
    ForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.forgotPassword(event.email);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onSignOut(
    SignOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _authRepository.signOut();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }
}
