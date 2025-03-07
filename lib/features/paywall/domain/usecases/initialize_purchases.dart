import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import '../repositories/purchase_repository.dart';

class InitializePurchases implements UseCase<void, NoParams> {
  final PurchaseRepository repository;

  InitializePurchases(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.initialize();
  }
}




class CheckSubscriptionAvailabilityUseCase extends UseCase<bool, NoParams> {
  final SubscriptionRepository repository;

  CheckSubscriptionAvailabilityUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.isAvailable();
  }
} 






