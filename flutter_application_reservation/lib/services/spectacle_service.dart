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
    titre: "GEORGIO au Transbordeur",
    date: "18.02.2026",
    prix: 42.00,
    imageUrl: "https://images.unsplash.com/photo-1478720568477-152d9b164e26",
    lieu: "3 Boulevard De La Bataille De Stalingrad, Villeurbanne",
  ),
  Spectacle(
    id: 2,
    titre: "OXMO PUCCINO ~ Atabal Biarritz",
    date: "21.11.2025",
    prix: 39.99,
    imageUrl: "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4",
    lieu: "Biarritz",
  ),
  Spectacle(
    id: 3,
    titre: "Concert de Jazz – Nuit Bleue",
    date: "04.12.2025",
    prix: 29.50,
    imageUrl: "https://images.unsplash.com/photo-1485579149621-3123dd979885",
    lieu: "Paris, New Morning",
  ),
  Spectacle(
    id: 4,
    titre: "Festival Comédie",
    date: "18.01.2026",
    prix: 19.00,
    imageUrl: "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91",
    lieu: "Lyon, Radiant",
  ),
  Spectacle(
    id: 5,
    titre: "Show d'Humour – Blanche Neige",
    date: "12.02.2026",
    prix: 24.90,
    imageUrl: "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91",
    lieu: "Marseille, Dock des Suds",
  ),
  Spectacle(
    id: 6,
    titre: "Grand Ballet Classique",
    date: "04.03.2026",
    prix: 45.00,
    imageUrl: "https://images.unsplash.com/photo-1497032205916-ac775f0649ae",
    lieu: "Opéra de Lyon",
  ),
  Spectacle(
    id: 7,
    titre: "Pièce de théâtre – Roméo & Juliette",
    date: "29.04.2026",
    prix: 34.99,
    imageUrl: "https://images.unsplash.com/photo-1526045612212-70caf35c14df",
    lieu: "Théâtre des Célestins, Lyon",
  ),
  Spectacle(
    id: 8,
    titre: "Stand-up – Les Chronicles",
    date: "09.05.2026",
    prix: 22.00,
    imageUrl: "https://images.unsplash.com/photo-1485217988980-11786ced9454",
    lieu: "Paris, Olympia",
  ),
  Spectacle(
    id: 9,
    titre: "Gala de Danse Moderne",
    date: "18.06.2026",
    prix: 27.90,
    imageUrl: "https://images.unsplash.com/photo-1491553895911-0055eca6402d",
    lieu: "Nantes, Zénith",
  ),
  Spectacle(
    id: 10,
    titre: "Angèle – Nonante-Cinq Tour",
    date: "14.02.2026",
    prix: 65.00,
    imageUrl: "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7",
    lieu: "Accor Arena, Paris",
  ),
  Spectacle(
    id: 11,
    titre: "Stromae – Multitude Tour",
    date: "22.03.2026",
    prix: 78.00,
    imageUrl: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f",
    lieu: "LDLC Arena, Lyon",
  ),
  Spectacle(
    id: 12,
    titre: "Julien Doré – Cœur",
    date: "07.01.2026",
    prix: 49.90,
    imageUrl: "https://images.unsplash.com/photo-1507838153414-b4b713384a76",
    lieu: "Transbordeur, Villeurbanne",
  ),
  Spectacle(
    id: 13,
    titre: "Nuit de l'Électro – We Love Green",
    date: "30.05.2026",
    prix: 55.00,
    imageUrl: "https://images.unsplash.com/photo-1571266028243-d220e8d4a1c4",
    lieu: "Bois de Vincennes, Paris",
  ),
  Spectacle(
    id: 14,
    titre: "Les Enfoirés 2026",
    date: "28.02.2026",
    prix: 95.00,
    imageUrl: "https://images.unsplash.com/photo-1540039155733-5bb30b53aa14",
    lieu: "Halle Tony Garnier, Lyon",
  ),
  Spectacle(
    id: 15,
    titre: "Comédie musicale – Le Roi Lion",
    date: "15.04.2026",
    prix: 72.00,
    imageUrl: "https://images.unsplash.com/photo-1503095396549-807759245b35",
    lieu: "Casino de Paris",
  ),
  Spectacle(
    id: 16,
    titre: "Bigflo & Oli – La Vraie Vie",
    date: "11.03.2026",
    prix: 44.00,
    imageUrl: "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3",
    lieu: "Zénith de Toulouse",
  ),
  Spectacle(
    id: 17,
    titre: "Cyril Hanouna – Touche pas à mon poste Live",
    date: "20.06.2026",
    prix: 38.00,
    imageUrl: "https://images.unsplash.com/photo-1524368535928-5a5e3d23aaaa",
    lieu: "Accor Arena, Paris",
  ),
  Spectacle(
    id: 18,
    titre: "Festival Rock en Seine",
    date: "29.08.2026",
    prix: 89.00,
    imageUrl: "https://images.unsplash.com/photo-1459749411175-04bf5292ceea",
    lieu: "Domaine national de Saint-Cloud",
  ),
];
