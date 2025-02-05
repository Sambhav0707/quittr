import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quittr/features/profile/domain/entities/profile.dart';
import 'package:quittr/features/profile/domain/repositories/profile_repository.dart';
import 'package:quittr/features/auth/domain/repositories/auth_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;

  ProfileBloc({
    required ProfileRepository profileRepository,
    required AuthRepository authRepository,
  })  : _profileRepository = profileRepository,
        _authRepository = authRepository,
        super(const ProfileState.loading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<SignOut>(_onSignOut);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
    final profile = _profileRepository.currentProfile;
    if (profile != null) {
      emit(ProfileState.loaded(profile));
    } else {
      emit(const ProfileState.error('User not found'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _profileRepository.updateProfile(event.profile);
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (profile) => emit(ProfileState.loaded(profile)),
    );
  }

  Future<void> _onSignOut(SignOut event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _authRepository.signOut();
    result.fold(
      (failure) => emit(ProfileState.error(failure.message)),
      (_) => emit(const ProfileState.initial()),
    );
  }
}
