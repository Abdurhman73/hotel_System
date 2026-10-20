

class ModelRoom {
  final int id;
  final String titele;
  final String category;
  final String image;
  final double price;
  final double rating;
  final int reviews;
  final bool isFavorite;
  final String description;
  final List<String> features;
  // final VoidCallback onTap;

  const ModelRoom({
    required this.id,
    required this.titele,
    required this.category,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.isFavorite,
    required this.description,
    required this.features,
  });
}
