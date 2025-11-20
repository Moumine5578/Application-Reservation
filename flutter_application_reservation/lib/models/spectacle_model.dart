class Spectacle {
  final int id;
  final String titre;
  final String date;
  final double prix;
  final String imageUrl;

  Spectacle({
    required this.id,
    required this.titre,
    required this.date,
    required this.prix,
    required this.imageUrl,
  });

  factory Spectacle.fromJson(Map<String, dynamic> json) {
    return Spectacle(
      id: json['id'],
      titre: json['titre'],
      date: json['date'],
      prix: (json['prix'] as num).toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
}
