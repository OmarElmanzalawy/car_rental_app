part of 'date_picker_bloc.dart';

class DatePickerState extends Equatable{
  final int monthIndex;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<DateTime> months = AppUtils.upcomingMonths(count: 3);
  DatePickerState({required this.monthIndex, this.startDate, this.endDate});

  //copywith
  DatePickerState copyWith({
    int? monthIndex,
    DateTime? startDate,
    DateTime? endDate,
  }){
    return DatePickerState(
      monthIndex: monthIndex ?? this.monthIndex,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [monthIndex, startDate, endDate];
}
