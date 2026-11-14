import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/database/database_provider.dart';
import 'package:fitness_app/database/queries.dart';
import 'package:fitness_app/widgets/weight_line_chart.dart';
import 'package:fitness_app/widgets/workout_frequency_chart.dart';
import 'package:flutter/material.dart';

const _backgroundColor = Color(0xFF0b0d0f);
const _cardColor = Color(0xFF15181C);
const _textColor = Color(0xFFF5F6F7);
const _mutedColor = Color.fromRGBO(255, 255, 255, 0.45);

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool isLoading = true;
  List<WeightData> weights = [];
  List<WeeklyWorkoutCount> workoutsPerWeek = [];

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final database = DatabaseProvider().database;
    final recentWeights = await findRecentWeights(database, count: 10);
    final weekly = await findWorkoutsPerWeek(database, weeks: 8);

    if (!mounted) return;
    setState(() {
      weights = recentWeights;
      workoutsPerWeek = weekly;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text("Progress"),
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadProgress,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                children: [
                  _weightCard(),
                  const SizedBox(height: 14),
                  _frequencyCard(),
                ],
              ),
            ),
    );
  }

  Widget _weightCard() {
    final hasData = weights.isNotEmpty;
    final latest = hasData ? weights.last.value : null;
    final change = weights.length > 1
        ? weights.last.value - weights.first.value
        : null;

    return _ProgressCard(
      title: "Weight History",
      trailing: latest == null
          ? null
          : Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              spacing: 6,
              children: [
                Text(
                  "${latest.toStringAsFixed(1)} kg",
                  style: const TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (change != null)
                  Text(
                    "${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg",
                    style: TextStyle(
                      color: change <= 0
                          ? const Color(0xFF3DBE8E)
                          : _mutedColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
      child: hasData
          ? WeightLineChart(weights: weights)
          : const _EmptyMessage(
              "Log your weight from the Home screen to see it here.",
            ),
    );
  }

  Widget _frequencyCard() {
    final total = workoutsPerWeek.fold(0, (sum, w) => sum + w.count);

    return _ProgressCard(
      title: "Workout Frequency",
      trailing: Text(
        "$total in ${workoutsPerWeek.length} weeks",
        style: const TextStyle(
          color: _mutedColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: total == 0
          ? const _EmptyMessage(
              "Finish a workout session to see your weekly activity.",
            )
          : WorkoutFrequencyChart(weeks: workoutsPerWeek),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;

  const _ProgressCard({
    required this.title,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.08)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  final String message;

  const _EmptyMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _mutedColor, fontSize: 13),
        ),
      ),
    );
  }
}
