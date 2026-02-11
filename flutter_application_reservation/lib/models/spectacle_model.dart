class Spectacle {
  final int id;
  final String titre;
  final String date;
  final double prix;
  final String imageUrl;
  final String? lieu;

  Spectacle({
    required this.id,
    required this.titre,
    required this.date,
    required this.prix,
    required this.imageUrl,
    this.lieu,
  });

  /// Date parsée (dd.MM.yyyy) pour le tri. null si format invalide.
  DateTime? get dateTime {
    final parts = date.split('.');
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    if (m < 1 || m > 12 || d < 1 || d > 31) return null;
    try {
      return DateTime(y, m, d);
    } catch (_) {
      return null;
    }
  }

  factory Spectacle.fromJson(Map<String, dynamic> json) {
    return Spectacle(
      id: json['id'],
      titre: json['titre'],
      date: json['date'],
      prix: (json['prix'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      lieu: json['lieu'] as String?,
    );
  }
}
