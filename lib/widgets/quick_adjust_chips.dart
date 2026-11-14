import 'package:flutter/material.dart';

/// A row of pill buttons that add or subtract fixed amounts, e.g. −1, −0.5,
/// +0.5, +1. Styled like the filter chips in the mockup.
class QuickAdjustChips<T extends num> extends StatelessWidget {
  /// The amounts to offer, negative and positive.
  final List<T> amounts;

  /// Formats an amount without its sign, e.g. `0.5` or `1,000`.
  final String Function(T amount) format;

  final ValueChanged<T> onAdjust;

  const QuickAdjustChips({
    super.key,
    required this.amounts,
    required this.format,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        for (final amount in amounts)
          Expanded(
            child: _Chip(
              label: "${amount < 0 ? '−' : '+'}${format(amount.abs() as T)}",
              isPositive: amount > 0,
              onTap: () => onAdjust(amount),
            ),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isPositive;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isPositive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive
        ? Colors.indigoAccent
        : const Color.fromRGBO(255, 255, 255, 0.7);

    return Material(
      color: isPositive
          ? Colors.indigoAccent.withAlpha(30)
          : const Color.fromRGBO(255, 255, 255, 0.04),
      shape: StadiumBorder(
        side: BorderSide(
          color: isPositive
              ? Colors.indigoAccent.withAlpha(90)
              : const Color.fromRGBO(255, 255, 255, 0.12),
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: FittedBox(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
