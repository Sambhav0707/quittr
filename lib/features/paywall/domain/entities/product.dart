import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String localizedPrice;
  final String currencyCode;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.localizedPrice,
    required this.currencyCode,
  });

  @override
  List<Object> get props => [
        id,
        title,
        description,
        price,
        localizedPrice,
        currencyCode,
      ];
}
