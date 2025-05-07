import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'api_connection.dart'; // Update with your actual package name/path

class TimetableUploadScreen extends StatefulWidget {
  const TimetableUploadScreen({super.key});

  @override
  State<TimetableUploadScreen> createState() => _TimetableUploadScreenState();
}

class _TimetableUploadScreenState extends State<TimetableUploadScreen> {
  File? _xlsxFile;
  String? _fileName;
  List<Map<String, dynamic>>? _timetableData; // Store timetable data

  /// Function to pick an XLSX file using file_picker.
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'], // Allow only .xlsx files
    );
    if (result != null) {
      print("FilePicker result: ${result.files.single.name}");
      print("File extension: ${result.files.single.extension}");
      print("File path: ${result.files.single.path}");
      if (result.files.single.path != null) {
        setState(() {
          _fileName = result.files.single.name;
          _xlsxFile = File(result.files.single.path!);
        });
      }
    } else {
      print("No file selected.");
    }
  }

  /// Upload file and get response via the connection helper.
  Future<void> _uploadFile() async {
    if (_xlsxFile != null) {
      try {
        final decoded = await uploadTimetable(_xlsxFile!);
        setState(() {
          _timetableData = List<Map<String, dynamic>>.from(decoded['data']);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Timetable uploaded and processed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload timetable: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an XLSX file to upload.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildTimetableTable() {
    if (_timetableData == null || _timetableData!.isEmpty) {
      return const Text('No timetable data to display.');
    }
    final columns = _timetableData!.first.keys.toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns
            .map((col) => DataColumn(
            label: Text(col,
                style: const TextStyle(fontWeight: FontWeight.bold))))
            .toList(),
        rows: _timetableData!
            .map((row) => DataRow(
          cells: columns
              .map((col) => DataCell(Text('${row[col] ?? ''}')))
              .toList(),
        ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Global DeepPurple theme is assumed to be defined in main.dart.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Timetable'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file, color: Colors.white),
              label: const Text('Select XLSX File',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 54),
              ),
            ),
            const SizedBox(height: 20),
            if (_fileName != null)
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Selected File: $_fileName',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 54),
              ),
              child: const Text('Upload Timetable'),
            ),
            const SizedBox(height: 40),
            const Divider(),
            const Text(
              'Uploaded Timetable:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildTimetableTable()),
          ],
        ),
      ),
    );
  }
}
