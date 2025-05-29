import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_task_statistics.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final GetTaskStatistics getStats;

  StatisticsBloc(this.getStats) : super(StatisticsInitial()) {
    on<LoadStatisticsEvent>((e, emit) async {
      emit(StatisticsLoading());
      try {
        final stats = await getStats();
        emit(StatisticsLoaded(stats));
      } catch (err) {
        emit(StatisticsError(err.toString()));
      }
    });
  }
}
