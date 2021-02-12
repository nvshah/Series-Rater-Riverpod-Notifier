import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/series_repository.dart';
import 'series_notifier.dart';

final seriesRepositoryProvider = Provider<SeriesRepository>(
  (ref) => FakeRatingsRepository(),
);

//though here repo provider not changes, doc recommends to use watch() instead of read() for injecting repo to our statenotifier provider
final seriesNotifierProvider = StateNotifierProvider(
    (ref) => SeriesNotifier(ref.watch(seriesRepositoryProvider)));
//final seriesNotifierProvider = StateNotifierProvider((ref) => SeriesNotifier(ref.read(provider))
