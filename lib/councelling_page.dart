import 'package:flutter/material.dart';

class CounselingScreen extends StatefulWidget {
  const CounselingScreen({Key? key}) : super(key: key);

  @override
  State<CounselingScreen> createState() => _CounselingScreenState();
}

class _CounselingScreenState extends State<CounselingScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  List<Counsellor> _counsellors = [];

  // Dropdown filters
  String? _selectedYear; // Nullable to allow placeholder
  String? _selectedSection; // Nullable to allow placeholder

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // Mock counsellors
    _counsellors = [
      Counsellor(
        id: "C001",
        name: "Dr. Sateesh Kumar",
        department: "CS",
        contact: "+91-9876543210",
      ),
      Counsellor(
        id: "C002",
        name: "Dr. Amarendra",
        department: "ECE",
        contact: "+91-9876543211",
      ),
      Counsellor(
        id: "C003",
        name: "Dr. Priya Sharma",
        department: "AIML",
        contact: "+91-9876543212",
      ),
      Counsellor(
        id: "C004",
        name: "Dr. Rakesh Verma",
        department: "DS",
        contact: "+91-9876543213",
      ),
    ];

    // Mock students with counsellor assignments
    _allStudents = [
      Student(
        id: "S001",
        name: "Rahul Sharma",
        year: "II",
        section: "AIML",
        phoneNumber: "+91-9876543214",
        counsellorId: "C003",
      ),
      Student(
        id: "S002",
        name: "Priya Singh",
        year: "III",
        section: "CS",
        phoneNumber: "+91-9876543215",
        counsellorId: "C001",
      ),
      Student(
        id: "S003",
        name: "Amit Kumar",
        year: "IV",
        section: "CSBS",
        phoneNumber: "+91-9876543216",
        counsellorId: "C002",
      ),
      Student(
        id: "S004",
        name: "Anjali Verma",
        year: "III",
        section: "DS",
        phoneNumber: "+91-9876543217",
        counsellorId: "C004",
      ),
      Student(
        id: "S005",
        name: "Vikas Yadav",
        year: "II",
        section: "CS",
        phoneNumber: "+91-9876543218",
        counsellorId: "C001",
      ),
      Student(
        id: "S006",
        name: "Neha Gupta",
        year: "IV",
        section: "AIML",
        phoneNumber: "+91-9876543219",
        counsellorId: "C003",
      ),
      Student(
        id: "S007",
        name: "Rajat Mishra",
        year: "III",
        section: "CSBS",
        phoneNumber: "+91-9876543220",
        counsellorId: "C002",
      ),
      Student(
        id: "S008",
        name: "Shreya Jain",
        year: "II",
        section: "DS",
        phoneNumber: "+91-9876543221",
        counsellorId: "C004",
      ),
    ];

    // Validate counsellor assignments
    for (final student in _allStudents) {
      if (!_counsellors.any((c) => c.id == student.counsellorId)) {
        throw Exception("Invalid counsellorId for student: ${student.name}");
      }
    }

    _filteredStudents = List.from(_allStudents);
  }

  Counsellor _getCounsellorForStudent(String counsellorId) {
    return _counsellors.firstWhere(
          (c) => c.id == counsellorId,
      orElse: () => Counsellor(
        id: "",
        name: "Unknown",
        department: "Not Assigned",
        contact: "Not Available",
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      _filteredStudents = _allStudents.where((student) {
        bool matchesYear =
            _selectedYear == null || student.year.toLowerCase() == _selectedYear!.toLowerCase();
        bool matchesSection =
            _selectedSection == null || student.section.toLowerCase() == _selectedSection!.toLowerCase();

        return matchesYear && matchesSection;
      }).toList();
    });
  }

  void _searchStudents(String query) {
    setState(() {
      _filteredStudents = _allStudents.where((student) {
        final searchLower = query.toLowerCase();
        return student.name.toLowerCase().contains(searchLower) ||
            student.id.toLowerCase().contains(searchLower) ||
            student.year.toLowerCase().contains(searchLower) ||
            student.section.toLowerCase().contains(searchLower) ||
            student.phoneNumber.contains(searchLower);
      }).toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filteredStudents = List.from(_allStudents);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Counselling',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Students',
                hintText: 'Enter name, ID, year, section, or phone number',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _searchStudents,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String?>(
                  value: _selectedYear,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null, // Placeholder value
                      child: Text("Year", style: TextStyle(color: Colors.grey)),
                    ),
                    ...["II", "III", "IV"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedYear = newValue;
                      _applyFilters();
                    });
                  },
                  hint: Text("Year", style: TextStyle(color: Colors.grey)), // Placeholder text
                ),
                DropdownButton<String?>(
                  value: _selectedSection,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null, // Placeholder value
                      child: Text("Section", style: TextStyle(color: Colors.grey)),
                    ),
                    ...["AIML", "CS", "CSBS", "DS"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSection = newValue;
                      _applyFilters();
                    });
                  },
                  hint: Text("Section", style: TextStyle(color: Colors.grey)), // Placeholder text
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                final counsellor = _getCounsellorForStudent(student.counsellorId);
                return _StudentCounsellorCard(
                  student: student,
                  counsellor: counsellor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentCounsellorCard extends StatelessWidget {
  final Student student;
  final Counsellor counsellor;

  const _StudentCounsellorCard({
    required this.student,
    required this.counsellor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student.name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoItem("Student ID:", student.id),
                _buildInfoItem("Year:", student.year),
                _buildInfoItem("Section:", student.section),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoItem("Phone:", student.phoneNumber),
              ],
            ),
            const Divider(),
            Text("Assigned Counsellor",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(counsellor.name,
                style: const TextStyle(fontSize: 16)),
            Text(counsellor.department,
                style: TextStyle(color: Colors.grey[600])),
            Text(counsellor.contact,
                style: TextStyle(
                    color: Colors.blue[600],
                    decoration: TextDecoration.underline)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12)),
          Text(value,
              style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class Student {
  final String id;
  final String name;
  final String year;
  final String section;
  final String phoneNumber;
  final String counsellorId;

  Student({
    required this.id,
    required this.name,
    required this.year,
    required this.section,
    required this.phoneNumber,
    required this.counsellorId,
  });
}

class Counsellor {
  final String id;
  final String name;
  final String department;
  final String contact;

  Counsellor({
    required this.id,
    required this.name,
    required this.department,
    required this.contact,
  });
}