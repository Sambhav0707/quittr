import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import '../repositories/purchase_repository.dart';

class GetPurchaseUpdates implements UseCase<Stream<PurchasedItem?>, NoParams> {
  final PurchaseRepository repository;

  GetPurchaseUpdates(this.repository);

  @override
  Either<Failure, Stream<PurchasedItem?>> call(NoParams params) {
    try {
      return Right(repository.purchaseStream);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

// abstract class StreamUseCase<Type, Params> {
//   Stream<Type> call(Params params);
// }

class ListenToPurchaseUpdatesUseCase
    extends UseCase<Stream<List<PurchaseDetails>>, NoParams> {
  final SubscriptionRepository repository;

  ListenToPurchaseUpdatesUseCase(this.repository);

  @override
  FutureOr<Either<Failure, Stream<List<PurchaseDetails>>>> call(
      NoParams params) {
    try {
      return Right(repository.purchaseUpdates);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
