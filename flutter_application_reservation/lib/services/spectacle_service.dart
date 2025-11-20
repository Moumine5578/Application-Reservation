import '../models/spectacle_model.dart';

class SpectacleService {
  // Récupération des spectacles (mock pour l'instant)
  Future<List<Spectacle>> getSpectacles() async {
    await Future.delayed(const Duration(seconds: 1)); // Simule une API lente
    return _mockedSpectacles;
  }
}

// ------------------------------
// MOCK DATA (avant API réelle)
// ------------------------------
final List<Spectacle> _mockedSpectacles = [
  Spectacle(
    id: 1,
    titre: "OXMO PUCCINO ~ Atabal Biarritz",
    date: "21.11.2025",
    prix: 39.99,
    imageUrl: "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4",
  ),
  Spectacle(
    id: 2,
    titre: "Concert de Jazz – Nuit Bleue",
    date: "04.12.2025",
    prix: 29.50,
    imageUrl: "https://images.unsplash.com/photo-1485579149621-3123dd979885",
  ),
  Spectacle(
    id: 3,
    titre: "Festival Comédie",
    date: "18.01.2026",
    prix: 19.00,
    imageUrl: "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91",
  ),
  Spectacle(
    id: 4,
    titre: "Show d’Humour – Blanche Neige",
    date: "12.02.2026",
    prix: 24.90,
    imageUrl: "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91",
  ),
  Spectacle(
    id: 5,
    titre: "Grand Ballet Classique",
    date: "04.03.2026",
    prix: 45.00,
    imageUrl: "https://images.unsplash.com/photo-1497032205916-ac775f0649ae",
  ),
  Spectacle(
    id: 6,
    titre: "Pièce de théâtre – Roméo & Juliette",
    date: "29.04.2026",
    prix: 34.99,
    imageUrl: "https://images.unsplash.com/photo-1526045612212-70caf35c14df",
  ),
  Spectacle(
    id: 7,
    titre: "Stand-up – Les Chronicles",
    date: "09.05.2026",
    prix: 22.00,
    imageUrl: "https://images.unsplash.com/photo-1485217988980-11786ced9454",
  ),
  Spectacle(
    id: 8,
    titre: "Gala de Danse Moderne",
    date: "18.06.2026",
    prix: 27.90,
    imageUrl: "https://images.unsplash.com/photo-1491553895911-0055eca6402d",
  ),
];
