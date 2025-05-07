import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> uploadTimetable(File excelFile) async {
  // For Android emulator, use 10.0.2.2 to access the host machine's localhost.
  final uri = Uri.parse('http://10.0.2.2:5000/upload-timetable');

  // Create a MultipartRequest and attach the Excel file.
  final request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('file', excelFile.path));

  final response = await request.send();

  // Check the response status.
  if (response.statusCode == 200) {
    final respStr = await response.stream.bytesToString();
    // Decode and return the JSON.
    return json.decode(respStr) as Map<String, dynamic>;
  } else {
    throw Exception(
        'Failed to upload timetable. Status code: ${response.statusCode}');
  }
}
