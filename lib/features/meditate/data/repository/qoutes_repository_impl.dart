import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/meditate/data/datasources/meditate_loacal_data_source.dart';
import 'package:quittr/features/meditate/domain/entities/qoutes.dart';
import 'package:quittr/features/meditate/domain/repository/qoutes_repository.dart';

class QoutesRepositoryImpl implements QoutesRepository {
  final MeditateLoacalDataSource meditateLoacalDataSource;

  QoutesRepositoryImpl(this.meditateLoacalDataSource);
  @override
  Future<Either<Failure, List<Qoutes>>> getQoutes() async {
    try {
      final qoutes = await meditateLoacalDataSource.getQoutes();

      return Right(qoutes);
    } on GeneralFailure catch (e) {
      return Left(GeneralFailure(e.message));
    }
  }
}
