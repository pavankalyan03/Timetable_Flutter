import 'package:flutter/material.dart';
import 'package:timetable/main.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;
    return isLoggedIn ? const AdminDashboard() : const AdminLoginPage();
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _gridItems = [
    {
      'title': 'Manage Teachers',
      'icon': Icons.people,
      'screen': const TeacherManagementScreen(),
      'color': Colors.blueAccent,
      'screenIndex': 1,
    },
    {
      'title': 'Student Management',
      'icon': Icons.school,
      'screen': const StudentManagementScreen(),
      'color': Colors.green,
      'screenIndex': 2,
    },
    {
      'title': 'Timetables',
      'icon': Icons.calendar_today,
      'screen': const TimetableUploadScreen(),
      'color': Colors.orange,
      'screenIndex': 3,
    },
    {
      'title': 'Counselling',
      'icon': Icons.psychology,
      'screen': const CounsellingManagementScreen(),
      'color': Colors.pink,
      'screenIndex': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildAdminDrawer(),
      body: _selectedIndex == 0
          ? _buildDashboardGrid()
          : _gridItems.firstWhere((item) => item['screenIndex'] == _selectedIndex,
          orElse: () => _gridItems[0])['screen'],
    );
  }

  Widget _buildDashboardGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _gridItems.length,
        itemBuilder: (context, index) {
          final item = _gridItems[index];
          return AnimatedGridTile(
            item: item,
            onTap: () => _navigateToScreen(item['screenIndex']),
          );
        },
      ),
    );
  }

  Drawer _buildAdminDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'System Management Console',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ..._gridItems.map((item) => ListTile(
            leading: Icon(item['icon'], color: Colors.deepPurple),
            title: Text(item['title']),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = item['screenIndex']);
            },
          )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.deepPurple),
            title: const Text('Logout'),
            onTap: _logoutAdmin,
          ),
        ],
      ),
    );
  }

  void _logoutAdmin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
    );
  }

  void _navigateToScreen(int index) {
    final selectedScreen = _gridItems
        .firstWhere((item) => item['screenIndex'] == index,
        orElse: () => _gridItems[0])['screen'];

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => selectedScreen),
    ).then((_) => setState(() => _selectedIndex = 0));
  }
}

// Adding the screen implementations directly rather than importing
class TeacherManagementScreen extends StatefulWidget {
  const TeacherManagementScreen({super.key});

  @override
  State<TeacherManagementScreen> createState() => _TeacherManagementScreenState();
}

class _TeacherManagementScreenState extends State<TeacherManagementScreen> {
  final List<Map<String, String>> _teachers = [
    {
      'name': 'Dr. Sarah Williams',
      'subject': 'Psychology',
      'email': 'sarah.williams@school.edu',
    },
    {
      'name': 'Prof. James Chen',
      'subject': 'Mathematics',
      'email': 'james.chen@school.edu',
    },
    {
      'name': 'Ms. Emily Taylor',
      'subject': 'English Literature',
      'email': 'emily.taylor@school.edu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Management', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.people, size: 48, color: Colors.blueAccent),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Faculty Management',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Manage teaching staff information and assignments',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add new teacher
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Teacher'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _teachers.length,
              itemBuilder: (context, index) {
                final teacher = _teachers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        teacher['name']!.substring(0, 1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(teacher['name']!),
                    subtitle: Text('${teacher['subject']} • ${teacher['email']}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // View teacher details
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new teacher
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() => _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  final List<Map<String, dynamic>> _students = [
    {
      'name': 'Alex Johnson',
      'grade': '11th',
      'id': 'S2023-001',
      'status': 'Active',
    },
    {
      'name': 'Maya Patel',
      'grade': '10th',
      'id': 'S2023-042',
      'status': 'Active',
    },
    {
      'name': 'Thomas Brown',
      'grade': '12th',
      'id': 'S2022-118',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.school, size: 48, color: Colors.green),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Directory',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Manage student records and academic information',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add new student
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Student'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        student['name'].substring(0, 1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(student['name']),
                    subtitle: Text('Grade: ${student['grade']} • ID: ${student['id']}'),
                    trailing: Chip(
                      label: Text(
                        student['status'],
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: Colors.green,
                    ),
                    onTap: () {
                      // View student details
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new student
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class TimetableUploadScreen extends StatefulWidget {
  const TimetableUploadScreen({super.key});

  @override
  State<TimetableUploadScreen> createState() => _TimetableUploadScreenState();
}

class _TimetableUploadScreenState extends State<TimetableUploadScreen> {
  final List<String> _grades = ['10th Grade', '11th Grade', '12th Grade'];
  String _selectedGrade = '10th Grade';

  final List<Map<String, String>> _timetables = [
    {
      'grade': '10th Grade',
      'uploadDate': '15 Apr 2025',
      'status': 'Published',
    },
    {
      'grade': '11th Grade',
      'uploadDate': '16 Apr 2025',
      'status': 'Draft',
    },
    {
      'grade': '12th Grade',
      'uploadDate': '14 Apr 2025',
      'status': 'Published',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable Management', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 48, color: Colors.orange),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Class Timetables',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Upload and manage class schedules and timetables',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    DropdownButton<String>(
                      value: _selectedGrade,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedGrade = newValue;
                          });
                        }
                      },
                      items: _grades.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _timetables.length,
              itemBuilder: (context, index) {
                final timetable = _timetables[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month, size: 40, color: Colors.orange),
                    title: Text(timetable['grade']!),
                    subtitle: Text('Uploaded on: ${timetable['uploadDate']}'),
                    trailing: Chip(
                      label: Text(
                        timetable['status']!,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: timetable['status'] == 'Published'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    onTap: () {
                      // View timetable details
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Upload new timetable
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.upload, color: Colors.white),
      ),
    );
  }
}

class CounsellingManagementScreen extends StatefulWidget {
  const CounsellingManagementScreen({super.key});

  @override
  State<CounsellingManagementScreen> createState() => _CounsellingManagementScreenState();
}

class _CounsellingManagementScreenState extends State<CounsellingManagementScreen> {
  final List<Map<String, dynamic>> _counsellingSessions = [
    {
      'id': '001',
      'student': 'Alex Johnson',
      'date': '27 Apr 2025',
      'counsellor': 'Dr. Sarah Williams',
      'status': 'Scheduled'
    },
    {
      'id': '002',
      'student': 'Maya Patel',
      'date': '28 Apr 2025',
      'counsellor': 'Dr. James Chen',
      'status': 'Confirmed'
    },
    {
      'id': '003',
      'student': 'Thomas Brown',
      'date': '26 Apr 2025',
      'counsellor': 'Dr. Sarah Williams',
      'status': 'Completed'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counselling Management', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.psychology, size: 48, color: Colors.pink),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Counselling Services',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Manage counselling sessions and appointments for students',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add new counselling session
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Session'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _counsellingSessions.length,
              itemBuilder: (context, index) {
                final session = _counsellingSessions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: session['status'] == 'Completed'
                          ? Colors.green
                          : session['status'] == 'Scheduled'
                          ? Colors.orange
                          : Colors.blue,
                      child: Text(
                        session['student'].substring(0, 1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(session['student']),
                    subtitle: Text('${session['date']} with ${session['counsellor']}'),
                    trailing: Chip(
                      label: Text(
                        session['status'],
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: session['status'] == 'Completed'
                          ? Colors.green
                          : session['status'] == 'Scheduled'
                          ? Colors.orange
                          : Colors.blue,
                    ),
                    onTap: () {
                      // View session details
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new counselling session
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AnimatedGridTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const AnimatedGridTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [item['color'].withOpacity(0.8), item['color']],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item['icon'], size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                item['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _adminIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String validAdminId = "admin";
  final String validPassword = "admin123";

  void _login() {
    if (_adminIdController.text == validAdminId &&
        _passwordController.text == validPassword) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboard()),
            (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid admin credentials!")),
      );
    }
  }

  @override
  void dispose() {
    _adminIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Login", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _adminIdController,
              decoration: const InputDecoration(
                labelText: "Admin ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Login", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}