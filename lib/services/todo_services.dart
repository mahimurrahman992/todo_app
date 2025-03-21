// todo_services.dart
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/todo.dart';

class TodoServices {
  // Function to save tasks to CSV
  static Future<void> saveTasksToCSV(List<Task> tasks) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tasks.csv';
    
    List<List<String>> rows = [];
    rows.add(['ID', 'Title', 'Description', 'Status']); // Column headers
    for (var task in tasks) {
      rows.add([task.id.toString(), task.title, task.description, task.status]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    File file = File(path);
    await file.writeAsString(csvData);
    print('Tasks saved to $path');
  }

  // Function to load tasks from CSV
  static Future<List<Task>> loadTasksFromCSV() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tasks.csv';
    
    List<Task> tasks = [];
    File file = File(path);
    if (await file.exists()) {
      String csvData = await file.readAsString();
      List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);
      
      // Skip the header row
      rows.removeAt(0);
      
      for (var row in rows) {
        tasks.add(Task(
          id: int.parse(row[0].toString()),
          title: row[1].toString(),
          description: row[2].toString(),
          createdAt: DateTime.now().millisecondsSinceEpoch,  // Or use saved createdAt
          status: row[3].toString(),
        ));
      }
    }
    return tasks;
  }

  // Function to add a new task
  static void addTask(List<Task> tasks, String title, String description, String status) {
    tasks.add(Task(
      id: tasks.length + 1,
      title: title,
      description: description,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: status,
    ));
  }

  // Function to update a task status
  static void updateTaskStatus(List<Task> tasks, int id, String newStatus) {
    Task task = tasks.firstWhere((task) => task.id == id);
    task.status = newStatus;
  }

  // Function to remove a task
  static void removeTask(List<Task> tasks, int id) {
    tasks.removeWhere((task) => task.id == id);
  }
}
