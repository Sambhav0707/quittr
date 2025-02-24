import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:quittr/core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_subscriptions.dart';
import '../../domain/usecases/initialize_purchases.dart';
import '../../domain/usecases/purchase_product.dart';
import '../../domain/usecases/verify_subscription.dart';
import '../../domain/usecases/get_purchase_updates.dart';

part 'paywall_event.dart';
part 'paywall_state.dart';

class PaywallBloc extends Bloc<PaywallEvent, PaywallState> {
  final InitializePurchases _initializePurchases;
  final GetSubscriptions _getProducts;
  final PurchaseProduct _purchaseProduct;
  final VerifySubscription _verifySubscription;
  final GetPurchaseUpdates _getPurchaseUpdates;
  StreamSubscription? _purchaseSubscription;

  PaywallBloc({
    required InitializePurchases initializePurchases,
    required GetSubscriptions getProducts,
    required PurchaseProduct purchaseProduct,
    required VerifySubscription verifySubscription,
    required GetPurchaseUpdates getPurchaseUpdates,
  })  : _initializePurchases = initializePurchases,
        _getProducts = getProducts,
        _purchaseProduct = purchaseProduct,
        _verifySubscription = verifySubscription,
        _getPurchaseUpdates = getPurchaseUpdates,
        super(const PaywallState.initial()) {
    on<InitializePaywall>(_onInitializePaywall);
    on<LoadProducts>(_onLoadProducts);
    on<PurchaseProductEvent>(_onPurchaseProduct);
    on<PurchaseUpdated>(_onPurchaseUpdated);
    on<VerifySubscriptionEvent>(_onVerifySubscription);
    on<PurchaseError>(
        (event, emit) => emit(state.copyWith(errorMessage: event.message)));

    // Setup purchase subscription
    final purchaseStream = _getPurchaseUpdates(NoParams());
    purchaseStream.fold(
      (failure) => add(PurchaseError(failure.message)),
      (stream) {
        _purchaseSubscription = stream.listen(
          (purchaseDetails) {
            add(PurchaseUpdated(purchaseDetails));
          },
        );
      },
    );
  }

  Future<void> _onInitializePaywall(
    InitializePaywall event,
    Emitter<PaywallState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _initializePurchases(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (_) {
        add(const LoadProducts());
      },
    );
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<PaywallState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getProducts(
      const GetProductsParams(productIds: [
        'monthly',
        'yearly',
      ]),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        isLoading: false,
        products: products,
      )),
    );
  }

  void _onPurchaseUpdated(
    PurchaseUpdated event,
    Emitter<PaywallState> emit,
  ) {
    if (event.purchaseDetails?.purchaseStateAndroid ==
            PurchaseState.purchased ||
        event.purchaseDetails?.transactionStateIOS ==
            TransactionState.purchased) {
      emit(state.copyWith(purchaseCompleted: true));
    }
  }

  Future<void> _onPurchaseProduct(
    PurchaseProductEvent event,
    Emitter<PaywallState> emit,
  ) async {
    emit(state.copyWith(isPurchasing: true));

    final result = await _purchaseProduct(
      PurchaseProductParams(productId: event.productId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isPurchasing: false,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(isPurchasing: false)),
    );
  }

  Future<void> _onVerifySubscription(
    VerifySubscriptionEvent event,
    Emitter<PaywallState> emit,
  ) async {
    final result = await _verifySubscription(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        errorMessage: failure.message,
      )),
      (isValid) => emit(state.copyWith(
        hasValidSubscription: isValid,
        errorMessage: null,
      )),
    );
  }

  @override
  Future<void> close() async {
    await _purchaseSubscription?.cancel();
    return super.close();
  }
}
