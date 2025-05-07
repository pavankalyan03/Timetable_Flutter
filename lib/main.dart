import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'timetable_page.dart';
import 'package:logger/logger.dart';
import 'teacher_portal.dart';
import 'admin_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VFSTR Timetable',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const IIYearPage(),
    const IIIYearPage(),
    const IVYearPage(),
    const TeacherPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VFSTR Timetable',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.deepPurple,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CurvedNavigationBar(
              index: _selectedIndex,
              backgroundColor: Colors.white,
              color: Colors.deepPurple,
              buttonBackgroundColor: Colors.purpleAccent,
              height: screenHeight * 0.051,
              animationDuration: const Duration(milliseconds: 300),
              items: const [
                Icon(Icons.school, size: 30, color: Colors.white),
                Icon(Icons.school, size: 30, color: Colors.white),
                Icon(Icons.school, size: 30, color: Colors.white),
                Icon(Icons.person, size: 30, color: Colors.white),
              ],
              onTap: _onItemTapped,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('II Year', style: TextStyle(color: Colors.white)),
                Text('III Year', style: TextStyle(color: Colors.white)),
                Text('IV Year', style: TextStyle(color: Colors.white)),
                Text('Teacher', style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String label;

  const CustomDropdown({super.key, required this.items, required this.label});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedItem;
  bool _showDropdown = false;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        TextField(
          focusNode: _focusNode,
          controller: _textController,
          decoration: InputDecoration(
            labelText: widget.label,
            border: const OutlineInputBorder(),
          ),
          onTap: () => setState(() => _showDropdown = true),
          readOnly: true,
        ),
        AnimatedOpacity(
          opacity: _showDropdown ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showDropdown ? screenWidth * 0.5 : 0,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.items[index]),
                  onTap: () {
                    setState(() {
                      _selectedItem = widget.items[index];
                      _textController.text = _selectedItem!;
                      _showDropdown = false;
                    });
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_selectedItem != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimetablePage(section: _selectedItem!),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select an option')),
              );
            }
          },
          child: const Text('View Timetable'),
        ),
      ],
    );
  }
}

class IIYearPage extends StatelessWidget {
  const IIYearPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Hello! II Year Students',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CustomDropdown(
            items: const [
              'II-A',
              'II-B',
              'II-C',
              'II-D',
              'II-E',
              'II-Al-ML',
              'II-CS',
            ],
            label: 'Select Section',
          ),
        ],
      ),
    );
  }
}

class IIIYearPage extends StatelessWidget {
  const IIIYearPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Hello! III Year Students',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CustomDropdown(
            items: const [
              'III-A',
              'III-B',
              'III-C',
              'III-D',
              'III-E',
              'III-Al-ML',
              'III-CS',
            ],
            label: 'Select Section',
          ),
        ],
      ),
    );
  }
}

class IVYearPage extends StatelessWidget {
  const IVYearPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Hello! IV Year Students',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CustomDropdown(
            items: const [
              'IV-A',
              'IV-B',
              'IV-C',
              'IV-D',
              'IV-E',
              'IV-Al-ML',
              'IV-CS',
            ],
            label: 'Select Section',
          ),
        ],
      ),
    );
  }
}

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController employeeNameController = TextEditingController();
  String selectedOption = 'id';
  final Logger logger = Logger();

  void logMessage(String message) {
    if (kDebugMode) {
      debugPrint(message);
    } else {
      logger.d(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: selectedOption == 'id'
                    ? TextField(
                  controller: employeeIdController,
                  decoration: const InputDecoration(
                    labelText: 'Employee ID',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your employee ID',
                  ),
                  keyboardType: TextInputType.text,
                )
                    : TextField(
                  controller: employeeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Employee Name',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your employee name',
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: 'id',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                        employeeIdController.clear();
                        employeeNameController.clear();
                      });
                    },
                  ),
                  const Text('Employee ID'),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'name',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                        employeeIdController.clear();
                        employeeNameController.clear();
                      });
                    },
                  ),
                  const Text('Employee Name'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedOption == 'id') {
                    final String employeeId = employeeIdController.text;
                    logMessage('Employee ID: $employeeId');
                  } else {
                    final String employeeName = employeeNameController.text;
                    logMessage('Employee Name: $employeeName');
                  }

                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const teacher_portal(),
                      transitionsBuilder: (_, a, __, c) => SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeInOut)).animate(a),
                        child: c,
                      ),
                    ),
                  );
                },
                child: const Text('Log in'),
              ),
              const SizedBox(height: 20),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminLoginPage(),

                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.deepPurple,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.admin_panel_settings,
                          color: Colors.deepPurple,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Are you an admin?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// New Admin Login Page (contains the login credentials fields) defined in this file.
// New Admin Login Page (defined in main.dart)
class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _adminIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Hard-coded valid credentials for demonstration purposes.
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
        title: const Text(
          "Admin Login",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Admin ID TextField
            TextField(
              controller: _adminIdController,
              decoration: const InputDecoration(
                labelText: "Admin ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Login Button with grey background, black text, and horizontal radius.
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white70, // Grey background
                foregroundColor: Colors.deepPurple, // Black text
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(35),
                    right: Radius.circular(35),
                  ),
                ),
              ),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}


