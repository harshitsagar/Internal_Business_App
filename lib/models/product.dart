class Product {
  final int id;
  final String name;
  final double dealerPrice;
  final double retailPrice;
  final int moq;
  final String barcode;

  Product({
    required this.id,
    required this.name,
    required this.dealerPrice,
    required this.retailPrice,
    required this.moq,
    required this.barcode,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      dealerPrice: json['dealerPrice'].toDouble(),
      retailPrice: json['retailPrice'].toDouble(),
      moq: json['moq'],
      barcode: json['barcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dealerPrice': dealerPrice,
      'retailPrice': retailPrice,
      'moq': moq,
      'barcode': barcode,
    };
  }
}