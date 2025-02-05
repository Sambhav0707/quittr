part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final Profile? profile;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState._({
    this.profile,
    this.isLoading = false,
    this.errorMessage,
  });

  const ProfileState.initial() : this._();
  const ProfileState.loading() : this._(isLoading: true);
  const ProfileState.loaded(Profile profile) : this._(profile: profile);
  const ProfileState.error(String message) : this._(errorMessage: message);

  ProfileState copyWith({
    Profile? profile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState._(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [profile, isLoading, errorMessage];
}
