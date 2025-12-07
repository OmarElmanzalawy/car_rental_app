import 'package:bloc/bloc.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'date_picker_event.dart';
part 'date_picker_state.dart';

class DatePickerBloc extends Bloc<DatePickerEvent, DatePickerState> {
  DatePickerBloc() : super(DatePickerState(monthIndex: 0)) {
    on<NextMonthEvent>((event, emit) {
      
      if(state.monthIndex < state.months.length - 1){
        emit(state.copyWith(monthIndex: state.monthIndex + 1));
      }
    });
    on<PreviousMonthEvent>((event, emit) {
      if(state.monthIndex > 0){
        emit(state.copyWith(monthIndex: state.monthIndex - 1));
      }
    });

    on<SelectDateEvent>((event,emit){
      emit(state.copyWith(selectedDate: event.selectedDate));
    });
  }
}
