import 'package:flutter/material.dart';
import 'manage_teacher_file.dart';
import 'student_management_file.dart';
import 'timetable_upload_screen.dart';
import 'councelling_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Management System',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
  _AdminDashboardState createState() => _AdminDashboardState();
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
      'title': 'Counseling',
      'icon': Icons.psychology,
      'screen': const CounselingScreen(),
      'color': Colors.pink,
      'screenIndex': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      drawer: _buildAdminDrawer(),
      body: _selectedIndex == 0
          ? _buildDashboardGrid()
          : _gridItems.firstWhere(
              (item) => item['screenIndex'] == _selectedIndex)['screen'],
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
            mainAxisSpacing: 16),
        itemCount: _gridItems.length,
        itemBuilder: (context, index) {
          final item = _gridItems[index];
          return _AnimatedGridTile(
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
                Text('School Management',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Admin Console v1.0',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
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
          const Divider(thickness: 1),
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
      MaterialPageRoute(builder: (context) => const AuthWrapper()),
          (Route<dynamic> route) => false,
    );
  }

  void _navigateToScreen(int index) {
    final selectedScreen = _gridItems
        .firstWhere((item) => item['screenIndex'] == index)['screen'];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => selectedScreen),
    ).then((_) => setState(() => _selectedIndex = 0));
  }
}

class _AnimatedGridTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const _AnimatedGridTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
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
            const SizedBox(height: 12),
            Text(item['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _adminIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String validAdminId = "admin";
  final String validPassword = "admin123";

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_adminIdController.text == validAdminId &&
          _passwordController.text == validPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid credentials!',
                  style: TextStyle(color: Colors.white))),
        );
      }
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FlutterLogo(size: 100),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _adminIdController,
                    decoration: const InputDecoration(
                        labelText: 'Admin ID',
                        prefixIcon: Icon(Icons.person_outline)),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter admin ID' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline)),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter password' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.deepPurple),
                      child: const Text('LOGIN',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}