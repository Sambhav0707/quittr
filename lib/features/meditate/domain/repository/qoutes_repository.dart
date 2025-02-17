import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/meditate/domain/entities/qoutes.dart';

abstract interface class QoutesRepository {

  Future<Either<Failure , List<Qoutes>>> getQoutes();
}