class Product {
  final String id;
  final String gender;
  final String masterCategory;
  final String subCategory;
  final String articleType;
  final String baseColour;
  final String season;
  final String year;
  final String usage;
  final String productDisplayName;
  final String brandName;
  final int price;

  Product({
    required this.id,
    required this.gender,
    required this.masterCategory,
    required this.subCategory,
    required this.articleType,
    required this.baseColour,
    required this.season,
    required this.year,
    required this.usage,
    required this.productDisplayName,
    required this.brandName,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
  return Product(
    id: map['id']?.toString() ?? '',
    gender: map['gender'] ?? 'Unknown',
    masterCategory: map['masterCategory'] ?? 'Unknown',
    subCategory: map['subCategory'] ?? 'Unknown',
    articleType: map['articleType'] ?? 'Unknown',
    baseColour: map['baseColour'] ?? 'Unknown',
    season: map['season'] ?? 'Unknown',
    year: map['year']?.toString() ?? 'Unknown',
    usage: map['usage'] ?? 'Unknown',
    productDisplayName: map['productDisplayName'] ?? 'No Name',
    brandName: map['brandName'] ?? 'No Brand',
    price: map['price'] != null ? int.tryParse(map['price'].toString()) ?? 0 : 0,
  );
}


}