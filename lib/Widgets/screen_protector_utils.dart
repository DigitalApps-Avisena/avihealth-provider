import 'dart:io';
import 'package:flutter/services.dart';
import 'package:screen_protector/screen_protector.dart';

class ScreenProtectorUtils {
  /// Enable screenshot and screen recording protection
  static Future<bool> enableProtection() async {
    try {
      await ScreenProtector.protectDataLeakageOn();
      print('Screen protection enabled successfully');
      return true;
    } on PlatformException catch (e) {
      print('Failed to enable screen protection: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error enabling screen protection: $e');
      return false;
    }
  }

  /// Disable screenshot and screen recording protection
  static Future<bool> disableProtection() async {
    try {
      await ScreenProtector.protectDataLeakageOff();
      print('Screen protection disabled successfully');
      return true;
    } on PlatformException catch (e) {
      print('Failed to disable screen protection: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error disabling screen protection: $e');
      return false;
    }
  }

  /// Prevent screenshots with custom color overlay (Android only)
  static Future<bool> enableProtectionWithColor({required Color color}) async {
    try {
      await ScreenProtector.protectDataLeakageWithColor(color);
      print('Screen protection with color enabled successfully');
      return true;
    } on PlatformException catch (e) {
      print('Failed to enable screen protection with color: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error enabling screen protection with color: $e');
      return false;
    }
  }

  /// Prevent screenshots with blur effect (Android only)
  static Future<bool> enableProtectionWithBlur({int radius = 20}) async {
    try {
      await ScreenProtector.protectDataLeakageWithBlur();
      print('Screen protection with blur enabled successfully');
      return true;
    } on PlatformException catch (e) {
      print('Failed to enable screen protection with blur: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error enabling screen protection with blur: $e');
      return false;
    }
  }

  /// Check if the current platform supports screen protection
  static bool isPlatformSupported() {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Get platform-specific protection info
  static String getProtectionInfo() {
    if (Platform.isAndroid) {
      return 'Android: Screenshots, screen recording, and recent apps preview will be blocked';
    } else if (Platform.isIOS) {
      return 'iOS: Limited protection - prevents app preview in recent apps';
    } else {
      return 'Platform not supported for screen protection';
    }
  }
}