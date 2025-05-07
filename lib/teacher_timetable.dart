import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher Timetable',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const TeacherTimetable(faculty: 'Dr. John Doe'), // Pass faculty name
    );
  }
}

// Teacher Days Navbar
class Teacher_days_navbar extends StatelessWidget {
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

  const Teacher_days_navbar({
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

// Teacher Timetable Page
class TeacherTimetable extends StatefulWidget {
  final String faculty; // Faculty name passed from parent
  const TeacherTimetable({super.key, required this.faculty});

  @override
  State<TeacherTimetable> createState() => _TeacherTimetableState();
}

class _TeacherTimetableState extends State<TeacherTimetable> {
  String _selectedDay = 'Monday'; // Tracks the currently selected day

  // Timetable data for each day
  final Map<String, List<Period>> _timetableData = {
    'Monday': [
      Period(
        time: '8:05-9:00',
        subject: 'DBMS (T)',
        className: 'VPTF-06',
        section: 'CSE-A',
      ),
      Period(
        time: '9:00-9:55',
        subject: 'DBMS (T)',
        className: 'VPTF-06',
        section: 'CSE-A',
      ),
      Period(
        time: '10:15-11:10',
        subject: 'Data Structures',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '11:10-12:05',
        subject: 'Operating Systems',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '12:05-1:00',
        subject: 'Computer Networks',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '2:00-2:55',
        subject: 'Software Engineering',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '2:55-3:50',
        subject: 'DBMS Lab',
        className: 'Lab-1',
        section: 'CSE-A',
      ),
    ],
    'Tuesday': [
      Period(
        time: '8:05-9:00',
        subject: 'Operating Systems',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '9:00-9:55',
        subject: 'Computer Networks',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '10:15-11:10',
        subject: 'Data Structures',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '11:10-12:05',
        subject: 'DBMS (T)',
        className: 'VPTF-06',
        section: 'CSE-A',
      ),
      Period(
        time: '12:05-1:00',
        subject: 'Software Engineering',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '2:00-2:55',
        subject: 'DBMS Lab',
        className: 'Lab-1',
        section: 'CSE-A',
      ),
      Period(
        time: '2:55-3:50',
        subject: 'Operating Systems Lab',
        className: 'Lab-2',
        section: 'CSE-A',
      ),
    ],
    'Wednesday': [
      Period(
        time: '8:05-9:00',
        subject: 'Data Structures',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '9:00-9:55',
        subject: 'DBMS (T)',
        className: 'VPTF-06',
        section: 'CSE-A',
      ),
      Period(
        time: '10:15-11:10',
        subject: 'Operating Systems',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '11:10-12:05',
        subject: 'Computer Networks',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '12:05-1:00',
        subject: 'Software Engineering',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '2:00-2:55',
        subject: 'DBMS Lab',
        className: 'Lab-1',
        section: 'CSE-A',
      ),
      Period(
        time: '2:55-3:50',
        subject: 'Data Structures Lab',
        className: 'Lab-3',
        section: 'CSE-A',
      ),
    ],
    'Thursday': [
      Period(
        time: '8:05-9:00',
        subject: 'Computer Networks',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '9:00-9:55',
        subject: 'Software Engineering',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '10:15-11:10',
        subject: 'DBMS (T)',
        className: 'VPTF-06',
        section: 'CSE-A',
      ),
      Period(
        time: '11:10-12:05',
        subject: 'Data Structures',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '12:05-1:00',
        subject: 'Operating Systems',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '2:00-2:55',
        subject: 'Operating Systems Lab',
        className: 'Lab-2',
        section: 'CSE-A',
      ),
      Period(
        time: '2:55-3:50',
        subject: 'Software Engineering Lab',
        className: 'Lab-4',
        section: 'CSE-A',
      ),
    ],
    'Friday': [
      Period(
        time: '8:05-9:00',
        subject: 'Software Engineering',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '9:00-9:55',
        subject: 'Data Structures',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '10:15-11:10',
        subject: 'DBMS (T)',
        className: 'VPTF-06',
        section: 'CSE-A',
      ),
      Period(
        time: '11:10-12:05',
        subject: 'Operating Systems',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '12:05-1:00',
        subject: 'Computer Networks',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '2:00-2:55',
        subject: 'Data Structures Lab',
        className: 'Lab-3',
        section: 'CSE-A',
      ),
      Period(
        time: '2:55-3:50',
        subject: 'Computer Networks Lab',
        className: 'Lab-5',
        section: 'CSE-A',
      ),
    ],
    'Saturday': [
      Period(
        time: '8:05-9:00',
        subject: 'DBMS (T)',
        className: 'VPTF-06',
        section: 'CSE-A',
      ),
      Period(
        time: '9:00-9:55',
        subject: 'Operating Systems',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '10:15-11:10',
        subject: 'Computer Networks',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '11:10-12:05',
        subject: 'Data Structures',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '12:05-1:00',
        subject: 'Software Engineering',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '2:00-2:55',
        subject: 'DBMS Lab',
        className: 'Lab-1',
        section: 'CSE-A',
      ),
      Period(
        time: '2:55-3:50',
        subject: 'Operating Systems Lab',
        className: 'Lab-2',
        section: 'CSE-A',
      ),
    ],
    'Sunday': [
      Period(
        time: '8:05-9:00',
        subject: 'Data Structures',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '9:00-9:55',
        subject: 'DBMS (T)',
        className: 'VPTF-06',
        section: 'CSE-A',
      ),
      Period(
        time: '10:15-11:10',
        subject: 'Operating Systems',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '11:10-12:05',
        subject: 'Computer Networks',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '12:05-1:00',
        subject: 'Software Engineering',
        className: 'VPTF-12',
        section: 'CSE-A',
      ),
      Period(
        time: '2:00-2:55',
        subject: 'Data Structures Lab',
        className: 'Lab-3',
        section: 'CSE-A',
      ),
      Period(
        time: '2:55-3:50',
        subject: 'Computer Networks Lab',
        className: 'Lab-5',
        section: 'CSE-A',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Timetable - ${widget.faculty}', // Display faculty name in the AppBar
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Updated Teacher Days Navbar
          Teacher_days_navbar(
            selectedDay: _selectedDay, // Pass the selected day
            onDaySelected: (day) {
              setState(() {
                _selectedDay = day; // Update the selected day
              });
            },
          ),
          // Display Timetable for the Selected Day with Animation
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300), // Animation duration
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation, // Fade animation
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.1), // Slide from bottom
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut, // Smooth easing
                    )),
                    child: child,
                  ),
                );
              },
              child: _buildTimetableForDay(_selectedDay),
            ),
          ),
        ],
      ),
    );
  }

  // Builds the timetable for the selected day
  Widget _buildTimetableForDay(String day) {
    final periods = _timetableData[day] ?? [];
    return periods.isEmpty
        ? Center(
      key: ValueKey(day), // Unique key for AnimatedSwitcher
      child: const Text('No classes scheduled'),
    )
        : ListView.builder(
      key: ValueKey(day), // Unique key for AnimatedSwitcher
      padding: const EdgeInsets.all(16),
      itemCount: periods.length,
      itemBuilder: (context, index) {
        return TimetableCard(period: periods[index]);
      },
    );
  }
}

// Represents a single period in the timetable
class Period {
  final String time;
  final String subject;
  final String className;
  final String section;

  Period({
    required this.time,
    required this.subject,
    required this.className,
    required this.section,
  });
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
            const SizedBox(height: 8),
            _buildRow('Subject:', period.subject),
            const SizedBox(height: 8),
            _buildRow('Class:', period.className),
            const SizedBox(height: 8),
            _buildRow('Section:', period.section), // Display section instead of teacherName
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}