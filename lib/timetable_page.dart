import 'package:flutter/material.dart';
import 'days_navbar.dart';

class TimetablePage extends StatefulWidget {
  final String section;
  const TimetablePage({super.key, required this.section});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  String _selectedDay = 'Monday'; // Tracks the currently selected day
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>(); // Key for AnimatedList

  // Timetable data for each day
  final Map<String, List<Period>> _timetableData = {
    'Monday': [
      Period('8:05-9:00', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('9:00-9:55', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('10:15-11:10', 'DS', 'VPTF 12', 'Mr. Rajesh Bulla'),
      Period('11:10-12:05', 'ES', 'VPTF 12', 'Dr K Mariyadas'),
      Period('12:05-01:00', 'DLD', 'VPTF 12', 'Mr M Krishna Chennakesava Rao'),
      Period('02:00-02:55', 'MS', 'VPTF 12', 'Dr D Sudheer Babu'),
      Period('02:55-03:50', 'DBMS', 'VPTF 12', 'U. Samson Ebenezar'),
    ],
    'Tuesday': [
      Period('8:05-9:00', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('9:00-9:55', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('10:15-11:10', 'DS', 'VPTF 12', 'Mr. Rajesh Bulla'),
      Period('11:10-12:05', 'ES', 'VPTF 12', 'Dr K Mariyadas'),
      Period('12:05-01:00', 'DLD', 'VPTF 12', 'Mr M Krishna Chennakesava Rao'),
      Period('02:00-02:55', 'MS', 'VPTF 12', 'Dr D Sudheer Babu'),
      Period('02:55-03:50', 'DBMS', 'VPTF 12', 'U. Samson Ebenezar'),
    ],
    'Wednesday': [
      Period('8:05-9:00', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('9:00-9:55', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('10:15-11:10', 'DS', 'VPTF 12', 'Mr. Rajesh Bulla'),
      Period('11:10-12:05', 'ES', 'VPTF 12', 'Dr K Mariyadas'),
      Period('12:05-01:00', 'DLD', 'VPTF 12', 'Mr M Krishna Chennakesava Rao'),
      Period('02:00-02:55', 'MS', 'VPTF 12', 'Dr D Sudheer Babu'),
      Period('02:55-03:50', 'DBMS', 'VPTF 12', 'U. Samson Ebenezar'),
    ],
    'Thursday': [
      Period('8:05-9:00', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('9:00-9:55', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('10:15-11:10', 'DS', 'VPTF 12', 'Mr. Rajesh Bulla'),
      Period('11:10-12:05', 'ES', 'VPTF 12', 'Dr K Mariyadas'),
      Period('12:05-01:00', 'DLD', 'VPTF 12', 'Mr M Krishna Chennakesava Rao'),
      Period('02:00-02:55', 'MS', 'VPTF 12', 'Dr D Sudheer Babu'),
      Period('02:55-03:50', 'DBMS', 'VPTF 12', 'U. Samson Ebenezar'),
    ],
    'Friday': [
      Period('8:05-9:00', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('9:00-9:55', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('10:15-11:10', 'DS', 'VPTF 12', 'Mr. Rajesh Bulla'),
      Period('11:10-12:05', 'ES', 'VPTF 12', 'Dr K Mariyadas'),
      Period('12:05-01:00', 'DLD', 'VPTF 12', 'Mr M Krishna Chennakesava Rao'),
      Period('02:00-02:55', 'MS', 'VPTF 12', 'Dr D Sudheer Babu'),
      Period('02:55-03:50', 'DBMS', 'VPTF 12', 'U. Samson Ebenezar'),
    ],

    'Saturday': [
      Period('8:05-9:00', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('9:00-9:55', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('10:15-11:10', 'DS', 'VPTF 12', 'Mr. Rajesh Bulla'),
      Period('11:10-12:05', 'ES', 'VPTF 12', 'Dr K Mariyadas'),
      Period('12:05-01:00', 'DLD', 'VPTF 12', 'Mr M Krishna Chennakesava Rao'),
      Period('02:00-02:55', 'MS', 'VPTF 12', 'Dr D Sudheer Babu'),
      Period('02:55-03:50', 'DBMS', 'VPTF 12', 'U. Samson Ebenezar'),
    ],
    'Sunday': [
      Period('8:05-9:00', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('9:00-9:55', 'DBMS (T)', 'VPTF-06', 'U. Samson Ebenezar'),
      Period('10:15-11:10', 'DS', 'VPTF 12', 'Mr. Rajesh Bulla'),
      Period('11:10-12:05', 'ES', 'VPTF 12', 'Dr K Mariyadas'),
      Period('12:05-01:00', 'DLD', 'VPTF 12', 'Mr M Krishna Chennakesava Rao'),
      Period('02:00-02:55', 'MS', 'VPTF 12', 'Dr D Sudheer Babu'),
      Period('02:55-03:50', 'DBMS', 'VPTF 12', 'U. Samson Ebenezar'),
    ],

    // Add similar entries for other days...
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable - ${widget.section}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Days Navigation Bar
          DaysNavBar(
            selectedDay: _selectedDay, // Pass the selected day
            onDaySelected: (day) {
              setState(() {
                _selectedDay = day; // Update the selected day
              });
            },
          ),
          // Display the timetable for the selected day
          Expanded(
            child: _buildAnimatedTimetableList(),
          ),
        ],
      ),
    );
  }

  // Builds the animated list of timetable periods
  Widget _buildAnimatedTimetableList() {
    final periods = _timetableData[_selectedDay] ?? [];
    return periods.isEmpty
        ? Center(
      child: const Text('No classes scheduled'),
    )
        : AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.all(16),
      initialItemCount: periods.length,
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuart,
          )),
          child: FadeTransition(
            opacity: animation,
            child: TimetableCard(period: periods[index]),
          ),
        );
      },
    );
  }
}

// Represents a single period in the timetable
class Period {
  final String time;
  final String subject;
  final String className;
  final String faculty;

  Period(this.time, this.subject, this.className, this.faculty);
}

// Displays a single timetable card
class TimetableCard extends StatelessWidget {
  final Period period;

  const TimetableCard({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Time:', period.time),
            const Divider(height: 24),
            _buildRow('Subject:', period.subject),
            const SizedBox(height: 8),
            _buildRow('Class:', period.className),
            const SizedBox(height: 8),
            _buildRow('Faculty:', period.faculty),
          ],
        ),
      ),
    );
  }

  // Helper method to build a row with label and value
  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }
}