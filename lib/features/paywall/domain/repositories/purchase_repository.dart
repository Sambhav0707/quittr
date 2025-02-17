import 'package:dartz/dartz.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:quittr/core/error/failures.dart';
import '../entities/product.dart';

abstract class PurchaseRepository {
  Future<Either<Failure, void>> initialize();
  Future<Either<Failure, List<Product>>> getSubscriptions(
      List<String> productIds);
  Future<Either<Failure, void>> purchaseProduct(String productId);
  Stream<PurchasedItem?> get purchaseStream;
  Future<Either<Failure, List<PurchasedItem>?>> getAvailablePurchases();
  Future<Either<Failure, void>> dispose();
}
