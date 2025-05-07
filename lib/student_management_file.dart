// File: lib/screens/manage_students.dart
import 'package:flutter/material.dart';
import 'dart:math'; // For the min() function
import 'manage_teacher_file.dart'; // Import TeacherProfile

// Define the Student model.
class Student {
  final String id;
  String name;
  String rollNumber;
  String phoneNumber;
  String department;
  String course;
  String year;
  String section;
  TeacherProfile? counselingTeacher;

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.phoneNumber,
    required this.department,
    required this.course,
    required this.year,
    required this.section,
    this.counselingTeacher,
  });
}

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() => _ManageStudentsState();
}

class _ManageStudentsState extends State<StudentManagementScreen> {
  final List<Student> _students = [];
  final TextEditingController _searchController = TextEditingController();
  final List<TeacherProfile> _teachers = []; // List of teachers for counselor assignment

  void _navigateToStudentForm(BuildContext context, [Student? student]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentForm(
          student: student,
          onSave: (updatedStudent) => _handleSaveStudent(updatedStudent, student),
          teachers: _teachers,
        ),
      ),
    );
  }

  void _handleSaveStudent(Student updatedStudent, Student? original) {
    setState(() {
      if (original != null) {
        final index = _students.indexWhere((s) => s.id == original.id);
        _students[index] = updatedStudent;
      } else {
        _students.add(updatedStudent);
      }
    });
  }

  void _deleteStudent(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this student?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _students.removeWhere((s) => s.id == id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 80, color: Colors.deepPurple.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No students added yet',
            style: TextStyle(fontSize: 18, color: Colors.deepPurple.withOpacity(0.7)),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToStudentForm(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Student'),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    final filteredStudents = _students.where((student) {
      final query = _searchController.text.toLowerCase();
      return student.name.toLowerCase().contains(query) ||
          student.rollNumber.toLowerCase().contains(query) ||
          student.phoneNumber.toLowerCase().contains(query) ||
          student.department.toLowerCase().contains(query) ||
          student.course.toLowerCase().contains(query);
    }).toList();

    if (filteredStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 70, color: Colors.deepPurple.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'No matching students found',
              style: TextStyle(fontSize: 18, color: Colors.deepPurple.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        final student = filteredStudents[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: Text(
                      student.rollNumber.substring(0, min(2, student.rollNumber.length)),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ),
                  title: Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    'Roll Number: ${student.rollNumber}',
                    style: TextStyle(color: Colors.deepPurple.shade400, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.deepPurple.shade300),
                      const SizedBox(width: 8),
                      Text(student.phoneNumber),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          student.department,
                          style: TextStyle(color: Colors.deepPurple.shade700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          student.course,
                          style: TextStyle(color: Colors.deepPurple.shade700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Year: ${student.year}',
                          style: TextStyle(color: Colors.deepPurple.shade700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Section: ${student.section}',
                          style: TextStyle(color: Colors.deepPurple.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.deepPurple.shade300),
                      const SizedBox(width: 8),
                      Text(
                        'Counselor: ${student.counselingTeacher?.name ?? 'Not assigned'}',
                        style: TextStyle(color: Colors.deepPurple.shade600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _navigateToStudentForm(context, student),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        side: const BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _deleteStudent(student.id),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This is the concrete build implementation for the StudentManagementScreen.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Students',
                hintText: 'Search by name, roll number, department...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.deepPurple.shade700, width: 2),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: _students.isEmpty ? _buildEmptyState() : _buildStudentList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () => _navigateToStudentForm(context),
      ),
    );
  }
}

// StudentForm for Adding/Editing a Student

class StudentForm extends StatefulWidget {
  final Student? student;
  final Function(Student) onSave;
  final List<TeacherProfile> teachers;

  const StudentForm({
    super.key,
    this.student,
    required this.onSave,
    required this.teachers,
  });

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _rollController;
  late final TextEditingController _phoneController;
  late final TextEditingController _yearController;
  late final TextEditingController _sectionController;
  late TeacherProfile? _selectedCounselor;
  String _selectedDepartment = 'CSE';
  String _selectedCourse = 'B.Tech';

  final List<String> _departments = ['ACSE', 'CSE', 'ECE', 'MECH', 'CIVIL'];
  final List<String> _courses = ['B.Tech', 'M.Tech', 'PhD'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _rollController = TextEditingController(text: widget.student?.rollNumber ?? '');
    _phoneController = TextEditingController(text: widget.student?.phoneNumber ?? '');
    _yearController = TextEditingController(text: widget.student?.year ?? '');
    _sectionController = TextEditingController(text: widget.student?.section ?? '');
    _selectedDepartment = widget.student?.department ?? 'CSE';
    _selectedCourse = widget.student?.course ?? 'B.Tech';
    _selectedCounselor = widget.student?.counselingTeacher;
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final newStudent = Student(
        id: widget.student?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        rollNumber: _rollController.text,
        phoneNumber: _phoneController.text,
        department: _selectedDepartment,
        course: _selectedCourse,
        year: _yearController.text,
        section: _sectionController.text,
        counselingTeacher: _selectedCounselor,
      );
      widget.onSave(newStudent);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Student Information Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, color: Colors.deepPurple, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: Colors.deepPurple.shade900),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: _rollController,
                decoration: InputDecoration(
                  labelText: 'Roll Number',
                  labelStyle: TextStyle(color: Colors.deepPurple.shade900),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter roll number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.deepPurple.shade900),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                items: _departments.map((dept) {
                  return DropdownMenuItem(
                    value: dept,
                    child: Text(dept),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedDepartment = value!);
                },
                decoration: InputDecoration(
                  labelText: 'Department',
                  labelStyle: TextStyle(color: Colors.deepPurple.shade900),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCourse,
                items: _courses.map((course) {
                  return DropdownMenuItem(
                    value: course,
                    child: Text(course),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCourse = value!);
                },
                decoration: InputDecoration(
                  labelText: 'Course',
                  labelStyle: TextStyle(color: Colors.deepPurple.shade900),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Year',
                  labelStyle: TextStyle(color: Colors.deepPurple.shade900),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter the year' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sectionController,
                decoration: InputDecoration(
                  labelText: 'Section',
                  labelStyle: TextStyle(color: Colors.deepPurple.shade900),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter the section' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TeacherProfile>(
                value: _selectedCounselor,
                items: widget.teachers.map((teacher) {
                  return DropdownMenuItem(
                    value: teacher,
                    child: Text(teacher.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCounselor = value);
                },
                decoration: InputDecoration(
                  labelText: 'Counseling Teacher',
                  labelStyle: TextStyle(color: Colors.deepPurple.shade900),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveStudent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(widget.student == null ? 'Create Student' : 'Update Student'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
