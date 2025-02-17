import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quittr/core/usecases/usecase.dart';
import 'package:quittr/features/meditate/domain/entities/qoutes.dart';
import 'package:quittr/features/meditate/domain/usecases/get_qoutes.dart';

part 'qoutes_event.dart';
part 'qoutes_state.dart';

class QoutesBloc extends Bloc<QoutesEvent, QoutesState> {
  final GetQoutes getQoutes;
  QoutesBloc(this.getQoutes) : super(QoutesInitial()) {
    on<QoutesEvent>((_, emit) => QoutesLoading());
    on<QoutesGetEvent>(_getQoutes);
  }

  void _getQoutes(QoutesGetEvent event, Emitter<QoutesState> emit) async {

     emit(QoutesLoading()); 
    final res = await getQoutes.call(NoParams());

    return res.fold((failure) {
      emit(QoutesFailure(failure.message));
    }, (success) {
      emit(QoutesSuccess(success));
    });
  }
}
