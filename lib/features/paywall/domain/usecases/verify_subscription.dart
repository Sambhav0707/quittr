import 'package:dartz/dartz.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/purchase_repository.dart';

class VerifySubscription implements UseCase<bool, NoParams> {
  final PurchaseRepository repository;

  VerifySubscription(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    final purchases = await repository.getAvailablePurchases();
    purchases.fold(
      (failure) => Left(failure),
      (purchases) {
        final hasSubscription = purchases?.isNotEmpty ?? false;
        return Right(hasSubscription);
      },
    );
    return Right(false);
  }
}
