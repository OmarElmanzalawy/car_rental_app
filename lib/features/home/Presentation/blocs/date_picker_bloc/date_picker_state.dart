part of 'date_picker_bloc.dart';

class DatePickerState extends Equatable{
  final int monthIndex;
  final DateTime? selectedDate;
  final List<DateTime> months = AppUtils.upcomingMonths(count: 3);
  DatePickerState({required this.monthIndex, this.selectedDate});

  //copywith
  DatePickerState copyWith({
    int? monthIndex,
    DateTime? selectedDate,
  }){
    return DatePickerState(
      monthIndex: monthIndex ?? this.monthIndex,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [monthIndex, selectedDate];
}
