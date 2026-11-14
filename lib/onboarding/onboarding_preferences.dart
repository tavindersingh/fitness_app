import 'package:shared_preferences/shared_preferences.dart';

/// Whether the user has finished (or skipped) onboarding.
///
/// Stored in shared preferences, so it's cleared when the app is uninstalled
/// and onboarding shows again on a fresh install.
class OnboardingPreferences {
  static const completedKey = 'onboarding_completed';

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(completedKey) ?? false;
  }

  static Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(completedKey, true);
  }
}
