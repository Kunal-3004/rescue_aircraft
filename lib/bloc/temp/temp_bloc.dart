// temp_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'temp_event.dart';
part 'temp_state.dart';

class TempBloc extends Bloc<TempEvent, TempState> {
  TempBloc() : super(const TempInitial()) {
    on<UpdateTemperature>(_onUpdateTemperature);
    on<ResetTemperature>(_onResetTemperature);
  }

  void _onUpdateTemperature(
    UpdateTemperature event,
    Emitter<TempState> emit,
  ) async {
    try {
      //^ Emit loading state FIRST
      emit(const TempLoading());

      // Add your temperature update logic here
      final double updatedTemp = event.temperature;

      //^ Emit loaded state after successful update
      emit(TempLoaded(temperature: updatedTemp));
    } catch (e) {
      emit(TempError(message: e.toString()));
    }
  }

  void _onResetTemperature(
    ResetTemperature event,
    Emitter<TempState> emit,
  ) {
    //^ Emit initial state to reset
    emit(const TempInitial());
  }
}
