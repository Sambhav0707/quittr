part of 'paywall_bloc.dart';

abstract class PaywallEvent extends Equatable {
  const PaywallEvent();

  @override
  List<Object?> get props => [];
}

class InitializePaywall extends PaywallEvent {
  const InitializePaywall();
}

// new class

// class InitializeSubscriptionEvent extends PaywallEvent {}

// class GetSubscriptionProductsEvent extends PaywallEvent {
//   final List<String> productIds;

//   const GetSubscriptionProductsEvent({
//     required this.productIds,
//   });
// }


class CheckIAPAvailabilityEvent extends PaywallEvent {}

class FetchProductsEvent extends PaywallEvent {
  final Set<String> productIds;

 const FetchProductsEvent(this.productIds);

  @override
  List<Object> get props => [productIds];
}

class LoadProducts extends PaywallEvent {
  const LoadProducts();
}

class PurchaseProductEvent extends PaywallEvent {
  final String productId;

  const PurchaseProductEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class PurchaseUpdated extends PaywallEvent {
  final PurchasedItem? purchaseDetails;

  const PurchaseUpdated(this.purchaseDetails);

  @override
  List<Object?> get props => [purchaseDetails];
}

class VerifySubscriptionEvent extends PaywallEvent {
  const VerifySubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class PurchaseError extends PaywallEvent {
  final String message;

  const PurchaseError(this.message);
}


class PurchaseProductEventNew extends PaywallEvent {
  final ProductDetails productDetails;

  const PurchaseProductEventNew(this.productDetails);

  @override
  List<Object> get props => [productDetails];
}

class StartListeningToPurchaseUpdatesEvent extends PaywallEvent {}

class RestorePurchasesEvent extends PaywallEvent {}

class DisposeSubscriptionEvent extends PaywallEvent {}



class PurchaseUpdatedNew extends PaywallEvent {
  final List<PurchaseDetails> purchaseDetails;

  const PurchaseUpdatedNew(this.purchaseDetails);

  @override
  List<Object> get props => [purchaseDetails];
}