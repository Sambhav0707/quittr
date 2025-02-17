import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
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
