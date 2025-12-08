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
      final tapped = DateTime(event.selectedDate.year, event.selectedDate.month, event.selectedDate.day);
      final s = state;
      //Start or restart the selection
      if (s.startDate == null) {
        print("clause 1");
        emit(s.copyWith(startDate: tapped, endDate: null));
      }else if(s.startDate != null && s.endDate != null){
        print("clause 5");
        emit(s.copyWith(startDate: null, endDate: tapped));
      }
       else {
        final start = s.startDate!;
        if (tapped.isBefore(start)) {
          print("clause 2");
          emit(s.copyWith(startDate: tapped, endDate: null));
        } else if (tapped.isAfter(start)) {
          print("clause 3");
          emit(s.copyWith(endDate: tapped));
        } else {
          print("clause 4");
          emit(s.copyWith(endDate: null));
        }
      }
    });
  }
}
