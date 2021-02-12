import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/series.dart';
import '../data/series_repository.dart';

abstract class SeriesState {
  const SeriesState();
}

class SeriesInitial extends SeriesState {
  const SeriesInitial();
}

class SeriesLoading extends SeriesState {
  const SeriesLoading();
}

class SeriesLoaded extends SeriesState {
  final Series series;

  const SeriesLoaded(
    this.series,
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SeriesLoaded && o.series == series;
  }

  @override
  int get hashCode => series.hashCode;
}

class SeriesError extends SeriesState {
  final String message;

  const SeriesError(
    this.message,
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SeriesError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

//--Application logic

class SeriesNotifier extends StateNotifier<SeriesState> {
  final SeriesRepository _seriesRepository;

  SeriesNotifier(this._seriesRepository) : super(SeriesInitial());

  Future<void> getRatings(String seriesName) async {
    try {
      state = SeriesLoading();
      final series = await _seriesRepository.fetchRatings(seriesName);
      state = SeriesLoaded(series);
    } on NetworkError {
      state =
          SeriesError("Couldn't fetch ratings. Check network connectivity !!");
    }
  }
}
