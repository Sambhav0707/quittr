import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:quittr/core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_data_source.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseDataSource _dataSource;

  PurchaseRepositoryImpl({
    required PurchaseDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Either<Failure, List<Product>>> getSubscriptions(
      List<String> productIds) async {
    try {
      final products = await _dataSource.getSubscriptions(productIds);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> purchaseProduct(String productId) async {
    try {
      await _dataSource.purchaseProduct(productId);
      return const Right(null);
    } on PlatformException catch (e) {
      return Left(PaywallFailure(
        e.message ?? "Unknown error occurred",
        e.code,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<PurchasedItem?> get purchaseStream => _dataSource.purchaseStream;

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      await _dataSource.initialize();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PurchasedItem>?>> getAvailablePurchases() async {
    try {
      final purchases = await _dataSource.getAvailablePurchases();
      return Right(purchases);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> dispose() async {
    try {
      await _dataSource.dispose();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionDataSource dataSource;

  SubscriptionRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, bool>> isAvailable() async {
    try {
      final result = await dataSource.isAvailable();
      return Right(result);
    } on ConnectionFailedFailure catch (e) {
      return Left(ConnectionFailedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProductDetails>>> fetchProducts(
      Set<String> productIds) async {
    try {
      final response = await dataSource.fetchProducts(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        return Left(ProductNotFoundFailure("products not found"));
      }

      return Right(response.productDetails);
    } on ProductNotFoundFailure catch (e) {
      return Left(ProductNotFoundFailure(e.message));
    }
  }

  @override
  Stream<List<PurchaseDetails>> get purchaseUpdates =>
      dataSource.purchaseUpdates;

  @override
  Future<Either<Failure, bool>> purchase(ProductDetails productDetails) async {
    try {
      final result = await dataSource.purchase(productDetails);
      return Right(result);
    } on PurchaseFailedFailure catch (e) {
      return Left(PurchaseFailedFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> restorePurchases() async {
    try {
      await dataSource.restorePurchases();
      return const Right(null);
    } on PurchaseFailedFailure catch (e) {
      return Left(PurchaseFailedFailure(e.message.toString()));
    }
  }

  @override
  void dispose() {
    dataSource.dispose();
  }
}
