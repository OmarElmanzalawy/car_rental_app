part of 'date_picker_bloc.dart';

class DatePickerState extends Equatable{
  final int monthIndex;
  final DateTime? startDate;
  final DateTime? endDate;
  // 1 is for next month
  // -1 is for previous month
  final int slideDirection;
  final List<DateTime> months = AppUtils.upcomingMonths(count: 3);
  DatePickerState({required this.monthIndex, this.startDate, this.endDate, this.slideDirection = 0});

  //copywith
  DatePickerState copyWith({
    int? monthIndex,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    int? slideDirection,
  }){
    return DatePickerState(
      monthIndex: monthIndex ?? this.monthIndex,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      slideDirection: slideDirection ?? this.slideDirection,
    );
  }

  @override
  List<Object?> get props => [monthIndex, startDate, endDate, slideDirection];
}
