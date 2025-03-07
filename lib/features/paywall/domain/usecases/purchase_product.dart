import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:quittr/core/error/failures.dart';
import 'package:quittr/core/usecases/usecase.dart';
import '../repositories/purchase_repository.dart';

class PurchaseProduct implements UseCase<void, PurchaseProductParams> {
  final PurchaseRepository repository;

  PurchaseProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(PurchaseProductParams params) async {
    return await repository.purchaseProduct(params.productId);
  }
}

class PurchaseProductParams extends Equatable {
  final String productId;

  const PurchaseProductParams({required this.productId});

  @override
  List<Object> get props => [productId];
}





class PurchaseProductUseCase extends UseCase<bool, PurchaseParams> {
  final SubscriptionRepository repository;

  PurchaseProductUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(PurchaseParams params) {
    return repository.purchase(params.productDetails);
  }
}

class PurchaseParams {
  final ProductDetails productDetails;
  PurchaseParams(this.productDetails);
}

