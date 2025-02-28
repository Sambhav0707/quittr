import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/purchase_repository.dart';

class VerifySubscription implements UseCase<bool, NoParams> {
  final PurchaseRepository repository;

  VerifySubscription(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    final purchases = await repository.getAvailablePurchases();
    return purchases.fold(
      (failure) => Left(failure),
      (purchases) {
        final hasSubscription = purchases?.isNotEmpty ?? false;
        return Right(hasSubscription);
      },
    );
  }
}
