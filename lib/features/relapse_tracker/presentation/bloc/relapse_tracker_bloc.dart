import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'relapse_tracker_event.dart';
part 'relapse_tracker_state.dart';

class RelapseTrackerBloc
    extends Bloc<RelapseTrackerEvent, RelapseTrackerState> {
  RelapseTrackerBloc() : super(RelapseTrackerInitial()) {
    // on<RelapseTrackerEvent>((_, emit) => RelapseTrackerInitial());
    on<RelapseTrackerPledgeConfirmEvent>(_onRelapseTrackerPledgeConfirmEvent);
    on<RelapseTrackerBottomSheetOpenEvent>(
        _onRelapseTrackerPledgeBottomSheetEvent);
  }

  void _onRelapseTrackerPledgeConfirmEvent(
      RelapseTrackerPledgeConfirmEvent event,
      Emitter<RelapseTrackerState> emit) async {
    emit(RelapseTrackerLoading());
    await Future.delayed(Duration.zero);
    emit(RelapseTrackerPledgeConfirmed());
  }

// this is only so that when we open bottom sheet succes state emits later can remove
  void _onRelapseTrackerPledgeBottomSheetEvent(
      RelapseTrackerBottomSheetOpenEvent event,
      Emitter<RelapseTrackerState> emit) async {
    emit(RelapseTrackerLoading());
    await Future.delayed(Duration.zero);

    emit(RelapseTrackerInitial());
  }
}
