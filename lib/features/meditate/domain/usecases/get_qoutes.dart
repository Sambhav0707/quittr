import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/meditate/domain/entities/qoutes.dart';
import 'package:quittr/features/meditate/domain/repository/qoutes_repository.dart';

class GetQoutes extends UseCase<List<Qoutes>, NoParams> {
  final QoutesRepository qoutesRepository;
  GetQoutes(this.qoutesRepository);
  @override
  FutureOr<Either<Failure, List<Qoutes>>> call(NoParams params)async {
    return await qoutesRepository.getQoutes();
  }
}
