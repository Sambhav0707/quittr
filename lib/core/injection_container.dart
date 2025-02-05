import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';

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
}
