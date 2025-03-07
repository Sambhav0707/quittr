import 'package:dartz/dartz.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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

// new class

abstract class SubscriptionRepository {
  /// Check if in-app purchases are available
  Future<Either<Failure, bool>> isAvailable();

  /// Fetch product details
  Future<Either<Failure, List<ProductDetails>>> fetchProducts(
      Set<String> productIds);

  /// Stream of purchase updates
  Stream<List<PurchaseDetails>> get purchaseUpdates;

  /// Initiate a purchase
  Future<Either<Failure, bool>> purchase(ProductDetails productDetails);

  /// Restore previous purchases
  Future<Either<Failure, void>> restorePurchases();

  /// Dispose resources
  void dispose();
}
