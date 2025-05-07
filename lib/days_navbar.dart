import 'package:flutter/material.dart';

class DaysNavBar extends StatelessWidget {
  final Function(String) onDaySelected;
  final String selectedDay; // Parent-controlled selected day
  final List<String> days = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  const DaysNavBar({
    super.key,
    required this.onDaySelected,
    required this.selectedDay, // Receive selected day from parent
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.deepPurple[100],
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final isSelected = days[index] == selectedDay; // Use passed selectedDay
          return GestureDetector(
            onTap: () => onDaySelected(days[index]), // Notify parent
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? Colors.deepPurple : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: isSelected ? 20 : 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.deepPurple : Colors.deepPurple[300],
                ),
                child: Text(days[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}