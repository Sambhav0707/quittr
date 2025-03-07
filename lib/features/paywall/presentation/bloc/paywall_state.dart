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

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

//Initialize Subscription

class InitializeSubscriptionFailure extends SubscriptionState {
  final String errorMessage;
  const InitializeSubscriptionFailure({required this.errorMessage});
}

class InitializeSubscriptionSuccess extends SubscriptionState {
  final String response;
  const InitializeSubscriptionSuccess({required this.response});
}

class InitializeSubscriptionInitial extends SubscriptionState {

}

// Get Subscription Products
// States
// abstract class IAPState extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class IAPInitialState extends IAPState {}

// class IAPAvailabilityLoadingState extends IAPState {}
// class IAPAvailableState extends IAPState {
//   final bool isAvailable;

//   IAPAvailableState(this.isAvailable);

//   @override
//   List<Object> get props => [isAvailable];
// }

// class ProductsFetchingState extends IAPState {}
// class ProductsFetchedState extends IAPState {
//   final List<ProductDetails> products;

//   ProductsFetchedState(this.products);

//   @override
//   List<Object> get props => [products];
// }

// class IAPErrorState extends IAPState {
//   final String errorMessage;

//   IAPErrorState(this.errorMessage);

//   @override
//   List<Object> get props => [errorMessage];
// }



abstract class IAPState extends Equatable {
  @override
  List<Object> get props => [];
}

class IAPInitialState extends IAPState {}

class IAPAvailabilityLoadingState extends IAPState {}

class IAPAvailableState extends IAPState {
  final bool isAvailable;

  IAPAvailableState(this.isAvailable);

  @override
  List<Object> get props => [isAvailable];
}

class ProductsFetchingState extends IAPState {}

class ProductsFetchedState extends IAPState {
  final List<ProductDetails> products;

  ProductsFetchedState(this.products);

  @override
  List<Object> get props => [products];
}

class IAPErrorState extends IAPState {
  final String errorMessage;

  IAPErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PurchaseProcessingState extends IAPState {}

class PurchaseSuccessState extends IAPState {
  final bool success;

  PurchaseSuccessState(this.success);

  @override
  List<Object> get props => [success];
}

class RestoringPurchasesState extends IAPState {}

class PurchasesRestoredState extends IAPState {}

class PurchaseUpdatesState extends IAPState {
  final List<PurchaseDetails> purchaseDetails;

  PurchaseUpdatesState(this.purchaseDetails);

  @override
  List<Object> get props => [purchaseDetails];
}
