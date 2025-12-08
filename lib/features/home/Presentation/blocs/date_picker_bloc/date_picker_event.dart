part of 'date_picker_bloc.dart';

@immutable
sealed class DatePickerEvent {}

class NextMonthEvent extends DatePickerEvent{
  
}

class PreviousMonthEvent extends DatePickerEvent{

  
}

class SelectDateEvent extends DatePickerEvent{
  final DateTime selectedDate;

  SelectDateEvent({required this.selectedDate});
}
