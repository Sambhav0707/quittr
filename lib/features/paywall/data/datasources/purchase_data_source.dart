import 'dart:async';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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

//new

abstract class SubscriptionDataSource {
  Stream<List<PurchaseDetails>> get purchaseUpdates;
  Future<bool> isAvailable();
  Future<ProductDetailsResponse> fetchProducts(Set<String> productIds);
  void listenToPurchaseUpdates();
  Future<void> restorePurchases();
  Future<bool> purchase(ProductDetails productDetails); // New purchase method
  void dispose();
}

class SubscriptionDataSourceImpl implements SubscriptionDataSource {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  SubscriptionDataSourceImpl() {
    listenToPurchaseUpdates();
  }

  @override
  Stream<List<PurchaseDetails>> get purchaseUpdates =>
      _inAppPurchase.purchaseStream;

  @override
  Future<bool> isAvailable() => _inAppPurchase.isAvailable();

  @override
  Future<ProductDetailsResponse> fetchProducts(Set<String> productIds) async {
    // final ProductDetailsResponse response;
    // return response = await _inAppPurchase.queryProductDetails(productIds);
    final response = await _inAppPurchase.queryProductDetails(productIds);
    if (response.notFoundIDs.isNotEmpty) {
      throw Exception("Products not found: ${response.notFoundIDs}");
    }
    return response;
  }

  @override
  void listenToPurchaseUpdates() {
    _purchaseSubscription = purchaseUpdates.listen(
      (purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () => _purchaseSubscription?.cancel(),
      onError: (error) {
        print("Purchase Stream Error: $error");
      },
    );
  }

  @override
  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  @override
  Future<bool> purchase(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    return _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _showPendingUI();
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        
        _handleError(purchaseDetails.error!);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          _deliverProduct(purchaseDetails);
        } else {
          _handleInvalidPurchase(purchaseDetails);
        }
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void _showPendingUI() {
    print("Purchase pending...");
  }

  void _handleError(IAPError error) {
    print("Purchase Error: ${error.message}");
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    return true;
  }

  void _deliverProduct(PurchaseDetails purchaseDetails) {
    print("Delivering product: ${purchaseDetails.productID}");
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    print("Invalid purchase detected: ${purchaseDetails.productID}");
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
  }
}
