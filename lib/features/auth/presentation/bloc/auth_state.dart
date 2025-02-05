part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState._({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  const AuthState.authenticated(User user) : this._(user: user);
  const AuthState.unauthenticated() : this._();
  const AuthState.loading() : this._(isLoading: true);
  const AuthState.error(String message) : this._(errorMessage: message);

  @override
  List<Object?> get props => [user, isLoading, errorMessage];
}
