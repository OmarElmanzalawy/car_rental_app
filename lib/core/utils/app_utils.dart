import 'dart:io';

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
}