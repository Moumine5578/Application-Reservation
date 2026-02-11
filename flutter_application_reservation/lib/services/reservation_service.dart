import '../models/spectacle_model.dart';

/// Service global des réservations : les billets réservés apparaissent dans l'onglet Tickets.
class ReservationService {
  static final List<Spectacle> _reservations = [];

  static List<Spectacle> get reservations => List.unmodifiable(_reservations);

  static void add(Spectacle spectacle) {
    if (_reservations.any((r) => r.id == spectacle.id)) return;
    _reservations.add(spectacle);
  }

  static void remove(int spectacleId) {
    _reservations.removeWhere((r) => r.id == spectacleId);
  }

  static bool isReserved(int spectacleId) {
    return _reservations.any((r) => r.id == spectacleId);
  }
}
