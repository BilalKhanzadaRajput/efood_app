class CategoryModel {
  final String id;
  final String name;
  final String iconUrl;
  final String? imageUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconUrl,
    this.imageUrl,
  });
}
