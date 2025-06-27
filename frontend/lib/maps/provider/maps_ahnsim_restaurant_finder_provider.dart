import 'dart:math';

class MapsAhnsimRestaurantFinderProvider {
  double calculateDistance(
      double lat1, double lng1,
      double lat2, double lng2,
      ) {
    const double earthRadius = 6371;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLng = _degreesToRadians(lng2 - lng1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLng / 2) * sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  List<Map<String, dynamic>> findNearbyRestaurants({
    required double currentLat,
    required double currentLng,
    required List<dynamic> restaurants,
    double radiusKm = 2.0,
    int maxResults = 20,
  }) {
    List<Map<String, dynamic>> nearbyRestaurants = [];

    print(restaurants);

    for (var restaurant in restaurants) {
      // if (restaurant['useYn'] != 'Y') continue;

      double restaurantLat = restaurant['latitude']?.toDouble() ?? 0.0;
      double restaurantLng = restaurant['longitude']?.toDouble() ?? 0.0;
      if (restaurantLat == 0.0 || restaurantLng == 0.0) continue;

      double distance = calculateDistance(
        currentLat,
        currentLng,
        restaurantLat,
        restaurantLng,
      );

      if (distance <= radiusKm) {
        final r = Map<String, dynamic>.from(restaurant);
        r['distance'] = distance;
        nearbyRestaurants.add(r);
      }
    }

    nearbyRestaurants.sort((a, b) =>
        (a['distance'] as double).compareTo(b['distance'] as double));

    return nearbyRestaurants.take(maxResults).toList();
  }
}