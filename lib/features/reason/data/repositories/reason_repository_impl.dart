import 'package:dartz/dartz.dart';
import 'package:quittr/core/database/database_helper.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/reason/domain/repositories/reason_repository.dart';
import 'package:quittr/features/reason/domain/entities/reason.dart';
import '../models/reason_model.dart';

class ReasonRepositoryImpl implements ReasonRepository {
  final DatabaseHelper _databaseHelper;

  ReasonRepositoryImpl({
    required DatabaseHelper databaseHelper,
  }) : _databaseHelper = databaseHelper;

  @override
  Future<Either<Failure, List<Reason>>> getReasons() async {
    try {
      final reasons = await _databaseHelper.getAllReasons();
      return Right(reasons);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reason>> addReason(String reasonText) async {
    try {
      final reason = ReasonModel(
        reason: reasonText,
        createdAt: DateTime.now(),
      );
      final savedReason = await _databaseHelper.createReason(reason);
      return Right(savedReason);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReason(int id) async {
    try {
      await _databaseHelper.deleteReason(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
