import 'dart:convert';
import 'dart:io';

import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppUtils {

  static bool isiOS26OrAbove() {
    if (!Platform.isIOS) return false;

    final osString = Platform.operatingSystemVersion;

    // Extract the first number (major iOS version) using regex
    final match = RegExp(r'(\d+)(?:\.\d+)?').firstMatch(osString);
    print("reg ex ios version: ${match.toString()}");
    if (match == null) return false;

    final majorVersion = double.tryParse(match.group(1) ?? '0') ?? 0;

    return majorVersion >= 26;
  }

  static DateTime currentDate() {
    return DateTime.now();
  }

  static List<DateTime> upcomingMonths({int count = 3}) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return List.generate(count, (i) {
      final m = start.month + i;
      final y = start.year + ((m - 1) ~/ 12);
      final realM = ((m - 1) % 12) + 1;
      return DateTime(y, realM, 1);
    });
  }

  static List<DateTime> first30DaysOfMonth(DateTime month) {
    final nextMonthStart = DateTime(
      month.month == 12 ? month.year + 1 : month.year,
      month.month == 12 ? 1 : month.month + 1,
      1,
    );
    final lastDay = nextMonthStart.subtract(const Duration(days: 1)).day;
    final count = lastDay >= 30 ? 30 : lastDay;
    return List.generate(count, (i) => DateTime(month.year, month.month, i + 1));
  }

  static String monthYearLabel(DateTime month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${names[month.month - 1]} ${month.year}';
  }

  static String shortWeekday(DateTime date) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[date.weekday - 1];
  }

  static List<String> availableCarBrands(List<CarModel> cars){
    //fetch brands from testcars
    final brands = cars.map((e) => e.brand).toSet().toList();
    return brands;
  }

  static String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}

  static String toDayMonth(DateTime date) {
    return "${date.day}/${date.month}";
  }

  static String toReadableTime(DateTime date) {
    final h12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final mm = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'am' : 'pm';
    return "$h12:$mm $period";
  }

  static String latLngToWkt(LatLng latLng) {
  return 'POINT(${latLng.longitude} ${latLng.latitude})';
  }

static LatLng latLngFromSupabase(String geoJson) {
  final decoded = jsonDecode(geoJson);
  final coords = decoded['coordinates'];
  return LatLng(coords[1], coords[0]); // lat, lng
}

  static List<String> fetchUniqueBrands(List<String> values){
    final seen = <String>{};
      final unique = <String>[];
      for (final value in values) {
        if (seen.add(value.toLowerCase())) {
          unique.add(value);
        }
      }
      return unique;
  }

  static String timeLeftForPickup(DateTime pickupDate) {
    final now = DateTime.now();
    final diff = pickupDate.difference(now);
    if (diff.isNegative) {
      return "0h left for pickup";
    }
    if (diff.inHours < 24) {
      var hours = diff.inHours;
      if (diff.inMinutes % 60 != 0) {
        hours += 1;
      }
      if (hours == 0) {
        hours = 1;
      }
      return "${hours}h left for pickup";
    }
    final days = diff.inDays;
    return "${days}d left for pickup";
  }

  static Color getStatusChipColor(RentalStatus status) {
    switch (status) {
      case RentalStatus.pending:
        return Colors.lightBlue;
      case RentalStatus.active || RentalStatus.approved:
        return Colors.green;
      case RentalStatus.canceled:
        return Colors.red;
      case RentalStatus.completed:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  static bool isWithin2Hours(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);
    return diff.inHours.abs() <= 3;
  }


}
