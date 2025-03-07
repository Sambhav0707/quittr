import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/paywall/domain/repositories/purchase_repository.dart';
import 'package:quittr/features/paywall/domain/usecases/dispose_subscription.dart';
import 'package:quittr/features/paywall/domain/usecases/restore_purchaces.dart';
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
        'gold_plan',
      ]),
    );
    log(result.toString());

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

//new bloc

// class SubscriptionBloc extends Bloc<PaywallEvent, IAPState> {
//   final SubscriptionRepository _subscriptionRepository;

//   SubscriptionBloc({required SubscriptionRepository subscriptionRepository})
//       : _subscriptionRepository = subscriptionRepository,
//         super(IAPInitialState()) {
//     on<CheckIAPAvailabilityEvent>(_onCheckAvailability);
//     on<FetchProductsEvent>(_onFetchProducts);
//   }

//   Future<void> _onCheckAvailability(
//       CheckIAPAvailabilityEvent event, Emitter<IAPState> emit) async {
//     emit(IAPAvailabilityLoadingState());
//     final result = await _subscriptionRepository.isAvailable();

//     result.fold((failure) => emit(IAPErrorState('IAP not available')),
//         (isAvailable) => emit(IAPAvailableState(isAvailable)));
//   }

//   Future<void> _onFetchProducts(
//       FetchProductsEvent event, Emitter<IAPState> emit) async {
//     emit(ProductsFetchingState());
//     final result =
//         await _subscriptionRepository.fetchProducts(event.productIds);

//     log(result.toString());

//     result.fold((failure) => emit(IAPErrorState('Failed to fetch products')),
//         (products) {
//       emit(ProductsFetchedState(products));
//       log(products.last.title.toString());
//     });
//   }
// }




class SubscriptionBloc extends Bloc<PaywallEvent, IAPState> {
  final CheckSubscriptionAvailabilityUseCase _checkAvailabilityUseCase;
  final FetchProductsUseCase _fetchProductsUseCase;
  final PurchaseProductUseCase _purchaseProductUseCase;
  final ListenToPurchaseUpdatesUseCase _listenToPurchaseUpdatesUseCase;
  final RestorePurchasesUseCase _restorePurchasesUseCase;
  final DisposeSubscriptionUseCase _disposeSubscriptionUseCase;

  StreamSubscription<List<PurchaseDetails>>? _purchaseUpdatesSubscription;

  SubscriptionBloc({
    required CheckSubscriptionAvailabilityUseCase checkAvailabilityUseCase,
    required FetchProductsUseCase fetchProductsUseCase,
    required PurchaseProductUseCase purchaseProductUseCase,
    required ListenToPurchaseUpdatesUseCase listenToPurchaseUpdatesUseCase,
    required RestorePurchasesUseCase restorePurchasesUseCase,
    required DisposeSubscriptionUseCase disposeSubscriptionUseCase,
  })  : _checkAvailabilityUseCase = checkAvailabilityUseCase,
        _fetchProductsUseCase = fetchProductsUseCase,
        _purchaseProductUseCase = purchaseProductUseCase,
        _listenToPurchaseUpdatesUseCase = listenToPurchaseUpdatesUseCase,
        _restorePurchasesUseCase = restorePurchasesUseCase,
        _disposeSubscriptionUseCase = disposeSubscriptionUseCase,
        super(IAPInitialState()) {
    on<CheckIAPAvailabilityEvent>(_onCheckAvailability);
    on<FetchProductsEvent>(_onFetchProducts);
    on<PurchaseProductEventNew>(_onPurchaseProduct);
    on<StartListeningToPurchaseUpdatesEvent>(_onStartListeningToPurchaseUpdates);
    on<RestorePurchasesEvent>(_onRestorePurchases);
    on<DisposeSubscriptionEvent>(_onDisposeSubscription);
  }

  Future<void> _onCheckAvailability(
      CheckIAPAvailabilityEvent event, Emitter<IAPState> emit) async {
    emit(IAPAvailabilityLoadingState());
    final result = await _checkAvailabilityUseCase(NoParams());

    result.fold(
      (failure) => emit(IAPErrorState('IAP not available')),
      (isAvailable) => emit(IAPAvailableState(isAvailable)),
    );
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<IAPState> emit) async {
    emit(ProductsFetchingState());
    final result = await _fetchProductsUseCase(FetchProductsParams(event.productIds));

    result.fold(
      (failure) => emit(IAPErrorState('Failed to fetch products')),
      (products) => emit(ProductsFetchedState(products)),
    );
  }

  Future<void> _onPurchaseProduct(
      PurchaseProductEventNew event, Emitter<IAPState> emit) async {
    emit(PurchaseProcessingState());
    final result = await _purchaseProductUseCase(PurchaseParams(event.productDetails));

    result.fold(
      (failure) => emit(IAPErrorState('Purchase failed')),
      (success) => emit(PurchaseSuccessState(success)),
    );
  }

  void _onStartListeningToPurchaseUpdates(
      StartListeningToPurchaseUpdatesEvent event, Emitter<IAPState> emit)async {
    final result = await _listenToPurchaseUpdatesUseCase(NoParams());

    result.fold(
      (failure) => emit(IAPErrorState('Failed to listen for purchases')),
      (stream) {
        _purchaseUpdatesSubscription = stream.listen((purchaseDetails) {
          add(PurchaseUpdatedNew(purchaseDetails));
        });
      },
    );
  }

  Future<void> _onRestorePurchases(
      RestorePurchasesEvent event, Emitter<IAPState> emit) async {
    emit(RestoringPurchasesState());
    final result = await _restorePurchasesUseCase(NoParams());

    result.fold(
      (failure) => emit(IAPErrorState('Failed to restore purchases')),
      (_) => emit(PurchasesRestoredState()),
    );
  }

  Future<void> _onDisposeSubscription(
      DisposeSubscriptionEvent event, Emitter<IAPState> emit) async {
    _purchaseUpdatesSubscription?.cancel();
    await _disposeSubscriptionUseCase(NoParams());
  }

  @override
  Future<void> close() {
    _purchaseUpdatesSubscription?.cancel();
    return super.close();
  }
}
