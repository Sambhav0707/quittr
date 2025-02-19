import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/features/motivaton/data/models/motivational_quotes_model.dart';
import 'package:quittr/features/motivaton/domain/entity/motivational_quotes.dart';
import 'package:quittr/features/motivaton/domain/repository/motivation_quotes_repository.dart';

 class MotivationalQuotesRepositoryImpl implements MotivationQuotesRepository {
  @override
  Future<Either<Failure, List<MotivationalQuotes>>> getMotivationalQuotes() {
    
    throw UnimplementedError();
  }
  
}