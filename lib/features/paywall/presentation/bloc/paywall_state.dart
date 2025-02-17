part of 'paywall_bloc.dart';

class PaywallState extends Equatable {
  final bool isLoading;
  final bool isPurchasing;
  final bool purchaseCompleted;
  final bool hasValidSubscription;
  final String? errorMessage;
  final List<Product> products;
  final List<String> pendingPurchases;

  const PaywallState._({
    this.isLoading = false,
    this.isPurchasing = false,
    this.products = const [],
    this.errorMessage,
    this.purchaseCompleted = false,
    this.hasValidSubscription = false,
    this.pendingPurchases = const [],
  });

  const PaywallState.initial() : this._();

  PaywallState copyWith({
    bool? isLoading,
    bool? isPurchasing,
    List<Product>? products,
    String? errorMessage,
    bool? purchaseCompleted,
    bool? hasValidSubscription,
    List<String>? pendingPurchases,
  }) {
    return PaywallState._(
      isLoading: isLoading ?? this.isLoading,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      products: products ?? this.products,
      errorMessage: errorMessage,
      purchaseCompleted: purchaseCompleted ?? this.purchaseCompleted,
      hasValidSubscription: hasValidSubscription ?? this.hasValidSubscription,
      pendingPurchases: pendingPurchases ?? this.pendingPurchases,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isPurchasing,
        products,
        errorMessage,
        purchaseCompleted,
        hasValidSubscription,
        pendingPurchases,
      ];
}
