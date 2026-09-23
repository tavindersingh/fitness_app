import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  final bool isSelected;
  final ValueChanged<bool> onClick;

  const new({
    super.key,
    this.isSelected = false,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          onClick(false);
        } else {
          onClick(true);
        }
      },
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: Icon(
                  Icons.check_rounded,
                  color: Color(0xFF15181c),
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
}
