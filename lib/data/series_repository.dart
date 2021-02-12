import 'dart:math';

import 'models/series.dart';

abstract class SeriesRepository {
  Future<Series> fetchRatings(String name);
}

///Generate Fake ratings
class FakeRatingsRepository implements SeriesRepository {
  double ratings;

  @override
  Future<Series> fetchRatings(String name) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 1),
      () {
        final random = Random();

        // Simulate some network error
        if (random.nextBool()) {
          throw NetworkError();
        }

        // Since we're inside a fake repository, we need to cache the ratings
        // in order to have the same one returned in for the detailed weather
        ratings = 3 + random.nextInt(6) + random.nextDouble();

        // Return "fetched" weather
        return Series(
          name: name,
          // Temperature between 20 and 35.99
          ratings: ratings,
        );
      },
    );
  }
}

class NetworkError extends Error {}