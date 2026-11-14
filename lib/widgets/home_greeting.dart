import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// "Good Morning", "Good Afternoon" or "Good Evening" for [time], followed by
/// the first word of [name] if there is one.
String greetingFor(DateTime time, String? name) {
  final String partOfDay;
  if (time.hour >= 5 && time.hour < 12) {
    partOfDay = "Good Morning";
  } else if (time.hour >= 12 && time.hour < 17) {
    partOfDay = "Good Afternoon";
  } else {
    partOfDay = "Good Evening";
  }

  final firstName = name?.trim().split(RegExp(r'\s+')).first ?? '';
  return firstName.isEmpty ? partOfDay : "$partOfDay, $firstName";
}

/// Today's date and a greeting, shown at the top of Home.
class HomeGreeting extends StatelessWidget {
  final DateTime now;
  final String? name;

  const HomeGreeting({super.key, required this.now, this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('EEEE, MMM d').format(now),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          greetingFor(now, name),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
