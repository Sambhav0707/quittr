part of 'relapse_tracker_bloc.dart';

@immutable
sealed class RelapseTrackerEvent {}

final class RelapseTrackerPledgeConfirmEvent extends RelapseTrackerEvent {}

final class RelapseTrackerBottomSheetOpenEvent extends RelapseTrackerEvent {}
