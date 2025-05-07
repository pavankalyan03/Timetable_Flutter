import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// MODEL CLASSES

class TeacherProfile {
  final String id;
  String name;
  String contact;
  List<String> subjects;
  List<String> qualifications;
  String designation;
  XFile? profileImage;

  TeacherProfile({
    required this.id,
    required this.name,
    required this.contact,
    required this.subjects,
    required this.qualifications,
    required this.designation,
    this.profileImage,
  });
}

class ClassModel {
  final String id;
  String name;
  List<TeacherProfile> assignedTeachers;

  ClassModel({
    required this.id,
    required this.name,
    this.assignedTeachers = const [],
  });
}

// MAIN SCREEN - TeacherManagementScreen

class TeacherManagementScreen extends StatefulWidget {
  const TeacherManagementScreen({super.key});

  @override
  State<TeacherManagementScreen> createState() => _TeacherManagementScreenState();
}

class _TeacherManagementScreenState extends State<TeacherManagementScreen>
    with SingleTickerProviderStateMixin {
  final List<TeacherProfile> _teachers = [];
  final List<ClassModel> _classes = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToProfileForm(BuildContext context, [TeacherProfile? teacher]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherProfileForm(
          teacher: teacher,
          onSave: (updatedTeacher) {
            setState(() {
              if (teacher != null) {
                final index = _teachers.indexWhere((t) => t.id == teacher.id);
                if (index != -1) {
                  _teachers[index] = updatedTeacher;
                }
              } else {
                _teachers.add(updatedTeacher);
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteTeacher(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this teacher?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _teachers.removeWhere((t) => t.id == id);
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

  void _navigateToClassForm(BuildContext context, [ClassModel? classToEdit]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassForm(
          classToEdit: classToEdit,
          teachers: _teachers,
          onSave: (newClass) {
            setState(() {
              if (classToEdit != null) {
                final index = _classes.indexWhere((cl) => cl.id == classToEdit.id);
                if (index != -1) {
                  _classes[index] = newClass;
                }
              } else {
                _classes.add(newClass);
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteClass(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this class?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _classes.removeWhere((cl) => cl.id == id);
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

  @override
  Widget build(BuildContext context) {
    // Scaffold using DeepPurple AppBar (this comes from the global theme as well)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher & Class Management'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Teachers', icon: Icon(Icons.person)),
            Tab(text: 'Classes', icon: Icon(Icons.class_)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTeacherList(),
          _buildClassList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () {
          if (_tabController.index == 0) {
            _navigateToProfileForm(context);
          } else {
            _navigateToClassForm(context);
          }
        },
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.deepPurple.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 18, color: Colors.deepPurple.withOpacity(0.7)),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (_tabController.index == 0) {
                _navigateToProfileForm(context);
              } else {
                _navigateToClassForm(context);
              }
            },
            icon: const Icon(Icons.add),
            label: Text(_tabController.index == 0 ? 'Add Teacher' : 'Add Class'),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherList() {
    if (_teachers.isEmpty) {
      return _buildEmptyState('No teachers added yet', Icons.school);
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _teachers.length,
      itemBuilder: (context, index) {
        final teacher = _teachers[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: Hero(
                    tag: 'teacher-${teacher.id}',
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.deepPurple.shade100,
                      backgroundImage: teacher.profileImage != null
                          ? FileImage(File(teacher.profileImage!.path))
                          : null,
                      child: teacher.profileImage == null
                          ? const Icon(Icons.person, color: Colors.deepPurple, size: 30)
                          : null,
                    ),
                  ),
                  title: Text(
                    teacher.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    teacher.designation,
                    style: TextStyle(color: Colors.deepPurple.shade400, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.deepPurple.shade300),
                      const SizedBox(width: 8),
                      Text(teacher.contact),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Subjects',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    children: teacher.subjects
                        .map((subject) => Chip(
                      label: Text(subject),
                      avatar: const Icon(Icons.book, size: 16),
                    ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _navigateToProfileForm(context, teacher),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        side: const BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _deleteTeacher(teacher.id),
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

  Widget _buildClassList() {
    if (_classes.isEmpty) {
      return _buildEmptyState('No classes added yet', Icons.class_);
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _classes.length,
      itemBuilder: (context, index) {
        final classItem = _classes[index];
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.class_, color: Colors.deepPurple),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        classItem.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Assigned Teachers',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700),
                ),
                const SizedBox(height: 8),
                classItem.assignedTeachers.isEmpty
                    ? const Text('No teachers assigned', style: TextStyle(fontStyle: FontStyle.italic))
                    : Column(
                  children: classItem.assignedTeachers
                      .map((teacher) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.person, color: Colors.deepPurple),
                    title: Text(teacher.name),
                    subtitle: Text(teacher.designation),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _navigateToClassForm(context, classItem),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        side: const BorderSide(color: Colors.deepPurple),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _deleteClass(classItem.id),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// CLASS FORM

class ClassForm extends StatefulWidget {
  final ClassModel? classToEdit;
  final List<TeacherProfile> teachers;
  final Function(ClassModel) onSave;

  const ClassForm({super.key, this.classToEdit, required this.teachers, required this.onSave});

  @override
  State<ClassForm> createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final List<TeacherProfile> _selectedTeachers = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.classToEdit?.name ?? '');
    if (widget.classToEdit != null) {
      _selectedTeachers.addAll(widget.classToEdit!.assignedTeachers);
    }
  }

  void _saveClass() {
    if (_formKey.currentState!.validate()) {
      final newClass = ClassModel(
        id: widget.classToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        assignedTeachers: _selectedTeachers,
      );
      widget.onSave(newClass);
      Navigator.pop(context);
    }
  }

  void _toggleTeacherAssignment(TeacherProfile teacher) {
    setState(() {
      if (_selectedTeachers.contains(teacher)) {
        _selectedTeachers.remove(teacher);
      } else {
        _selectedTeachers.add(teacher);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classToEdit == null ? 'New Class' : 'Edit Class'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.withOpacity(0.05), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Class icon and title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.class_,
                        color: Colors.deepPurple,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Class Name',
                          hintText: 'Enter class name',
                        ),
                        validator: (value) => value!.isEmpty ? 'Please enter a class name' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Assign Teachers:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                widget.teachers.isEmpty
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(Icons.person_off, size: 48, color: Colors.deepPurple.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        const Text(
                          'No teachers available to assign',
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                )
                    : Expanded(
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.deepPurple.shade100, width: 1),
                    ),
                    child: ListView.separated(
                      itemCount: widget.teachers.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.deepPurple.shade50,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final teacher = widget.teachers[index];
                        return CheckboxListTile(
                          title: Text(
                            teacher.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(teacher.designation),
                          secondary: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            backgroundImage: teacher.profileImage != null
                                ? FileImage(File(teacher.profileImage!.path))
                                : null,
                            child: teacher.profileImage == null
                                ? const Icon(Icons.person, color: Colors.deepPurple)
                                : null,
                          ),
                          value: _selectedTeachers.contains(teacher),
                          activeColor: Colors.deepPurple,
                          onChanged: (bool? value) => _toggleTeacherAssignment(teacher),
                        );
                      },
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
                        onPressed: _saveClass,
                        child: Text(widget.classToEdit == null ? 'Create Class' : 'Update Class'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TEACHER PROFILE FORM

class TeacherProfileForm extends StatefulWidget {
  final TeacherProfile? teacher;
  final Function(TeacherProfile) onSave;

  const TeacherProfileForm({super.key, this.teacher, required this.onSave});

  @override
  State<TeacherProfileForm> createState() => _TeacherProfileFormState();
}

class _TeacherProfileFormState extends State<TeacherProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _designationController;
  final TextEditingController _newSubjectController = TextEditingController();
  final TextEditingController _newQualificationController = TextEditingController();
  final List<String> _subjects = [];
  final List<String> _qualifications = [];
  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.teacher?.name ?? '');
    _contactController = TextEditingController(text: widget.teacher?.contact ?? '');
    _designationController = TextEditingController(text: widget.teacher?.designation ?? '');

    if (widget.teacher != null) {
      _subjects.addAll(widget.teacher!.subjects);
      _qualifications.addAll(widget.teacher!.qualifications);
      _profileImage = widget.teacher!.profileImage;
    }
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _profileImage = image);
  }

  void _addSubject() {
    if (_newSubjectController.text.isNotEmpty) {
      setState(() {
        _subjects.add(_newSubjectController.text);
        _newSubjectController.clear();
      });
    }
  }

  void _removeSubject(int index) {
    setState(() {
      _subjects.removeAt(index);
    });
  }

  void _addQualification() {
    if (_newQualificationController.text.isNotEmpty) {
      setState(() {
        _qualifications.add(_newQualificationController.text);
        _newQualificationController.clear();
      });
    }
  }

  void _removeQualification(int index) {
    setState(() {
      _qualifications.removeAt(index);
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final newTeacher = TeacherProfile(
        id: widget.teacher?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        contact: _contactController.text,
        subjects: _subjects,
        qualifications: _qualifications,
        designation: _designationController.text,
        profileImage: _profileImage,
      );
      widget.onSave(newTeacher);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teacher == null ? 'New Teacher' : 'Edit Profile'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.withOpacity(0.05), Colors.white],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Profile Image Section with Edit Icon overlay
              Center(
                child: Stack(
                  children: [
                    Hero(
                      tag: 'teacher-${widget.teacher?.id ?? "new"}',
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple.shade100,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          image: _profileImage != null
                              ? DecorationImage(
                            image: FileImage(File(_profileImage!.path)),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: _profileImage == null
                            ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        )
                            : null,
                      ),
                    ),
                    // Edit Icon Overlay at the bottom-right corner
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: InkWell(
                          onTap: _pickImage,
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Information'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _designationController,
                decoration: const InputDecoration(labelText: 'Designation'),
              ),
              const SizedBox(height: 20),
              // Subjects Section
              Text(
                'Subjects',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newSubjectController,
                      decoration: const InputDecoration(labelText: 'Add subject'),
                    ),
                  ),
                  IconButton(
                    onPressed: _addSubject,
                    icon: const Icon(Icons.add),
                    color: Colors.deepPurple,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: List.generate(
                  _subjects.length,
                      (index) => Chip(
                    label: Text(_subjects[index]),
                    onDeleted: () => _removeSubject(index),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Qualifications Section
              Text(
                'Qualifications',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newQualificationController,
                      decoration: const InputDecoration(labelText: 'Add qualification'),
                    ),
                  ),
                  IconButton(
                    onPressed: _addQualification,
                    icon: const Icon(Icons.add),
                    color: Colors.deepPurple,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: List.generate(
                  _qualifications.length,
                      (index) => Chip(
                    label: Text(_qualifications[index]),
                    onDeleted: () => _removeQualification(index),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
