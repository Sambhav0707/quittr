part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

class NotificationScheduled extends NotificationState {}
class NotificationError extends NotificationState {
  final String error;
  NotificationError({required this.error});
}
