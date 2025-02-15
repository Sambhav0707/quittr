import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quittr/core/presentation/theme/cubit/theme_cubit.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/domain/usecases/update_profile_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quittr/core/services/image_picker_service.dart';
import 'package:quittr/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:quittr/core/database/database_helper.dart';
import 'package:quittr/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:quittr/features/settings/domain/repositories/settings_repository.dart';
import 'package:quittr/features/onboarding/data/datasources/quiz_local_data_source.dart';
import 'package:quittr/features/onboarding/data/repositories/quiz_repository_impl.dart';
import 'package:quittr/features/onboarding/domain/repositories/quiz_repository.dart';
import 'package:quittr/features/onboarding/presentation/bloc/quiz_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseAuth: sl(),
      googleSignIn: sl(),
    ),
  );

  // Features - Profile
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      auth: sl(),
      storage: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  // Services
  sl.registerLazySingleton<ImagePickerService>(
    () => ImagePickerServiceImpl(picker: sl()),
  );
  sl.registerLazySingleton(() => ImagePicker());

  // Use cases
  sl.registerLazySingleton(() => UpdateProfilePhoto(sl()));

  // Blocs
  sl.registerFactory(() => SettingsBloc(repository: sl()));

  // Database
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  // Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );

  // Cubits
  sl.registerFactory(() => ThemeCubit(settingsRepository: sl()));

  // Quiz Feature
  sl.registerFactory(() => QuizBloc(repository: sl()));
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<QuizLocalDataSource>(
    () => QuizLocalDataSourceImpl(),
  );
}
