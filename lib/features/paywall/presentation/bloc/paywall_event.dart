part of 'paywall_bloc.dart';

abstract class PaywallEvent extends Equatable {
  const PaywallEvent();

  @override
  List<Object?> get props => [];
}

class InitializePaywall extends PaywallEvent {
  const InitializePaywall();
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
