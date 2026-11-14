import 'package:fitness_app/branding/fittrack_logo.dart';
import 'package:fitness_app/data/fill_mock_data.dart';
import 'package:fitness_app/main_screen.dart';
import 'package:fitness_app/onboarding/onboarding_preferences.dart';
import 'package:fitness_app/onboarding/onboarding_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Height reserved above and below the logo, so the logo stays exactly in the
/// middle of the screen, where the native splash showed it.
const _textBlockHeight = 76.0;

/// Shown right after the native splash. Runs startup work, keeps the brand on
/// screen for at least [minimumDuration], then opens onboarding (first launch)
/// or the main screen.
class SplashScreen extends StatefulWidget {
  final Duration minimumDuration;

  /// Startup work. Returns true if onboarding should be shown.
  /// Defaults to [prepareApp]; tests pass their own.
  final Future<bool> Function()? prepare;

  const SplashScreen({
    super.key,
    this.minimumDuration = const Duration(milliseconds: 1500),
    this.prepare,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// Seeds mock data (debug builds only) and checks whether onboarding is done.
Future<bool> prepareApp() async {
  if (kDebugMode) {
    try {
      await fillMockSessionsData();
    } catch (e) {
      debugPrint("Failed to seed mock data: $e");
    }
  }
  return !await OnboardingPreferences.isCompleted();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late final Animation<double> _textOpacity = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
  );

  late final Animation<Offset> _textOffset =
      Tween(
        begin: const Offset(0, 0.4),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
        ),
      );

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _start();
  }

  Future<void> _start() async {
    final results = await Future.wait([
      (widget.prepare ?? prepareApp)(),
      Future.delayed(widget.minimumDuration, () => false),
    ]);
    final showOnboarding = results.first;

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, _, _) =>
            showOnboarding ? const OnboardingScreen() : const MainScreen(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitTrackColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: _textBlockHeight),
            const FitTrackLogo(size: 120),
            SizedBox(
              height: _textBlockHeight,
              child: FadeTransition(
                opacity: _textOpacity,
                child: SlideTransition(
                  position: _textOffset,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "FitTrack",
                        style: TextStyle(
                          color: Color(0xFFF5F6F7),
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Train. Track. Progress.",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
