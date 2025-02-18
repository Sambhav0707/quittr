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
        if (purchases == null) return Right(false);
        return Right(
          purchases.any(
            (r) {
              if (r.purchaseStateAndroid == PurchaseState.purchased) {
                return true;
              }
              if (r.transactionStateIOS == TransactionState.restored) {
                return true;
              }
              return false;
            },
          ),
        );
      },
    );
    return Right(false);
  }
}
