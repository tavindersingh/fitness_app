import 'package:fitness_app/main_screen.dart';
import 'package:fitness_app/onboarding/onboarding_preferences.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

const _backgroundColor = Color(0xFF0b0d0f);
const _textColor = Color(0xFFF5F6F7);
const _mutedColor = Color.fromRGBO(255, 255, 255, 0.6);
const _accentColor = Colors.indigoAccent;

/// Shared height for page images, so photos and icon tiles line up.
const _imageHeight = 240.0;

/// First-launch walkthrough. Finishing or skipping it is remembered, so it
/// only shows once per install.
class OnboardingScreen extends StatelessWidget {
  /// The screen shown after onboarding. Defaults to [MainScreen].
  final WidgetBuilder? nextScreenBuilder;

  const OnboardingScreen({super.key, this.nextScreenBuilder});

  Future<void> _finish(BuildContext context) async {
    await OnboardingPreferences.markCompleted();
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: nextScreenBuilder ?? (_) => const MainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const decoration = PageDecoration(
      pageColor: _backgroundColor,
      titleTextStyle: TextStyle(
        color: _textColor,
        fontSize: 26,
        fontWeight: FontWeight.w800,
      ),
      bodyTextStyle: TextStyle(color: _mutedColor, fontSize: 16, height: 1.4),
      imagePadding: EdgeInsets.only(top: 24),
      bodyPadding: EdgeInsets.symmetric(horizontal: 8),
      imageFlex: 3,
      bodyFlex: 2,
    );

    return IntroductionScreen(
      globalBackgroundColor: _backgroundColor,
      pages: [
        PageViewModel(
          title: "Welcome to your fitness tracker",
          body:
              "Plan your workouts, log your progress and build a habit "
              "that sticks.",
          image: const _PhotoImage("assets/images/benchpress.jpg"),
          decoration: decoration,
        ),
        PageViewModel(
          title: "Build your workout plans",
          body:
              "Browse the exercise library, group exercises into sessions "
              "like Leg Day, and start one each day from Home.",
          image: const _PhotoImage("assets/images/squats.jpg"),
          decoration: decoration,
        ),
        PageViewModel(
          title: "Track weight and steps",
          body:
              "Log your weight and daily steps from Home in a couple of "
              "taps, and see how they change over the week.",
          image: const _IconImage(
            icons: [Icons.monitor_weight_outlined, Icons.directions_walk],
            colors: [Color(0xFF7B93F0), Color(0xFF3DBE8E)],
          ),
          decoration: decoration,
        ),
        PageViewModel(
          title: "See your progress",
          body:
              "Charts show your weight trend and workouts per week. "
              "Hit your weekly goal and keep your streak going.",
          image: const _IconImage(
            icons: [Icons.auto_graph_rounded, Icons.local_fire_department],
            colors: [_accentColor, Color(0xFFE0A526)],
          ),
          decoration: decoration,
        ),
      ],
      onDone: () => _finish(context),
      onSkip: () => _finish(context),
      showSkipButton: true,
      skip: const Text("Skip", style: TextStyle(color: _mutedColor)),
      next: const Icon(Icons.arrow_forward_rounded, color: _accentColor),
      done: const Text(
        "Get started",
        style: TextStyle(color: _accentColor, fontWeight: FontWeight.w700),
      ),
      dotsDecorator: DotsDecorator(
        color: const Color.fromRGBO(255, 255, 255, 0.2),
        activeColor: _accentColor,
        size: const Size(8, 8),
        activeSize: const Size(22, 8),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      controlsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
    );
  }
}

class _PhotoImage extends StatelessWidget {
  final String asset;

  const _PhotoImage(this.asset);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          width: double.infinity,
          height: _imageHeight,
        ),
      ),
    );
  }
}

class _IconImage extends StatelessWidget {
  final List<IconData> icons;
  final List<Color> colors;

  const _IconImage({required this.icons, required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _imageHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          for (var i = 0; i < icons.length; i++)
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: colors[i].withAlpha(38),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors[i].withAlpha(70)),
              ),
              child: Icon(icons[i], size: 52, color: colors[i]),
            ),
        ],
      ),
    );
  }
}
