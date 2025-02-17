part of 'qoutes_bloc.dart';

@immutable
sealed class QoutesState {}

final class QoutesInitial extends QoutesState {}

final class QoutesLoading extends QoutesState {}

final class QoutesSuccess extends QoutesState {
  final List<Qoutes> qoutes;

  QoutesSuccess(this.qoutes);

}

final class QoutesFailure extends QoutesState {
  final String message;

  QoutesFailure(this.message);
  
}
