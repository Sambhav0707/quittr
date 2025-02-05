part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStatusChanged extends AuthEvent {
  final User? user;

  const AuthStatusChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInWithGoogle extends AuthEvent {}

class SignInWithEmailPassword extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailPassword({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignUp extends AuthEvent {
  final String email;
  final String password;

  const SignUp({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class ForgotPassword extends AuthEvent {
  final String email;

  const ForgotPassword({required this.email});

  @override
  List<Object> get props => [email];
}

class SignOut extends AuthEvent {}
