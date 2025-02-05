import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quittr/core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  @override
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null
          ? null
          : User(
              id: firebaseUser.uid,
              email: firebaseUser.email,
              name: firebaseUser.displayName,
              photoUrl: firebaseUser.photoURL,
            );
    });
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const Left(AuthFailure('Google sign in aborted'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;

      return Right(User(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        name: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
      ));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user!;

      return Right(User(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        name: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
      ));
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return Left(AuthFailure('Invalid email or password'));
      }
      return Left(AuthFailure(e.message ?? 'Sign in failed'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user!;

      return Right(User(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        name: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
      ));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Sign up failed'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Sign out failed'));
    }
  }
}
