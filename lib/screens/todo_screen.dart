import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/widgets/custom_button.dart';
import 'package:todo_app/widgets/custom_textfield.dart';
import 'package:todo_app/services/todo_services.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Task> tasks = [];  // List to store tasks
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String taskStatus = 'pending';  // Initial status for the task

  // Function to load tasks when the app starts
  Future<void> loadTasks() async {
    tasks = await TodoServices.loadTasksFromCSV();
    setState(() {});
  }

  // Function to add a new task
  void addTask(String title, String description, String status) {
    setState(() {
      TodoServices.addTask(tasks, title, description, status);
      TodoServices.saveTasksToCSV(tasks);  // Save tasks to CSV after adding
    });
  }

  // Function to update a task status
  void updateTaskStatus(int id, String newStatus) {
    setState(() {
      TodoServices.updateTaskStatus(tasks, id, newStatus);
      TodoServices.saveTasksToCSV(tasks);  // Save tasks to CSV after updating
    });
  }

  // Function to delete a task
  void removeTask(int id) {
    setState(() {
      TodoServices.removeTask(tasks, id);
      TodoServices.saveTasksToCSV(tasks);  // Save tasks to CSV after removing
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks();  // Load tasks from CSV on app start
  }

  // Show modal bottom sheet for adding or updating task
  void showTaskModal(BuildContext context, {Task? task}) {
    if (task != null) {
      titleController.text = task.title;
      descriptionController.text = task.description;
      taskStatus = task.status;
    } else {
      titleController.clear();
      descriptionController.clear();
      taskStatus = 'pending';
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: titleController,
                labelText: 'Task Title', hintText: 'Task',
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: descriptionController,
                labelText: 'Task Description', hintText: 'Description',
              ),
              Row(
                children: [
                  Text('Status:'),
                  Radio<String>(
                    value: 'pending',
                    groupValue: taskStatus,
                    onChanged: (String? value) {
                      setState(() {
                        taskStatus = value!;
                      });
                    },
                  ),
                  Text('Pending'),
                  Radio<String>(
                    value: 'completed',
                    groupValue: taskStatus,
                    onChanged: (String? value) {
                      setState(() {
                        taskStatus = value!;
                      });
                    },
                  ),
                  Text('Completed'),
                ],
              ),
              CustomButton(
                text: task != null ? 'Update Task' : 'Add Task',
                onPressed: () {
                  if (task != null) {
                    updateTaskStatus(task.id, taskStatus);
                  } else {
                    addTask(
                      titleController.text,
                      descriptionController.text,
                      taskStatus,
                    );
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Task list UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        backgroundColor: const Color.fromARGB(255, 108, 181, 174),  // Beautiful color combination
      ),
      body: Column(
        children: [
          CustomButton(
            text: 'Add Task',
            onPressed: () => showTaskModal(context),
          
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: ListTile(
                    title: Text(task.title, style: TextStyle(color: Colors.teal)),
                    subtitle: Text(task.description),
                    trailing: Text(task.status, style: TextStyle(color: Colors.teal)),
                    onTap: () => showTaskModal(context, task: task),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete Task'),
                            content: Text('Are you sure you want to delete this task?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  removeTask(task.id);
                                  Navigator.pop(context);
                                },
                                child: Text('Delete'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
