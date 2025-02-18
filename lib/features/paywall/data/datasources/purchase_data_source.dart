import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import '../models/product_model.dart';

abstract class PurchaseDataSource {
  Future<void> initialize();
  Future<List<ProductModel>> getSubscriptions(List<String> productIds);
  Future<void> purchaseProduct(String productId);
  Future<List<PurchasedItem>?> getAvailablePurchases();
  Stream<PurchasedItem?> get purchaseStream;
  Future<void> dispose();
}

class PurchaseDataSourceImpl implements PurchaseDataSource {
  final FlutterInappPurchase _flutterInappPurchase;

  PurchaseDataSourceImpl({
    FlutterInappPurchase? flutterInappPurchase,
  }) : _flutterInappPurchase =
            flutterInappPurchase ?? FlutterInappPurchase.instance;

  @override
  Future<void> initialize() async {
    await _flutterInappPurchase.initialize();
  }

  @override
  Future<List<ProductModel>> getSubscriptions(List<String> productIds) async {
    try {
      final items = await _flutterInappPurchase.getSubscriptions(productIds);
      return items.map((item) => ProductModel.fromIAPItem(item)).toList();
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }

  @override
  Future<void> purchaseProduct(String productId) async {
    await _flutterInappPurchase.requestSubscription(productId);
  }

  @override
  Future<List<PurchasedItem>?> getAvailablePurchases() async {
    return await _flutterInappPurchase.getAvailablePurchases();
  }

  @override
  Stream<PurchasedItem?> get purchaseStream =>
      FlutterInappPurchase.purchaseUpdated;

  @override
  Future<void> dispose() async {
    await _flutterInappPurchase.finalize();
  }
}
