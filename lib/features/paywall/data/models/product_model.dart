import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.localizedPrice,
    required super.currencyCode,
  });

  factory ProductModel.fromIAPItem(IAPItem item) {
    return ProductModel(
      id: item.productId ?? '',
      title: item.title ?? '',
      description: item.description ?? '',
      price: double.tryParse(item.price ?? '0') ?? 0.0,
      localizedPrice: item.localizedPrice ?? '',
      currencyCode: item.currency ?? 'USD',
    );
  }
}
