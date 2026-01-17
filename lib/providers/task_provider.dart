import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  // Database ka dabba (Box)
  Box<Task>? _taskBox;

  // Constructor: Jaise hi Provider banega, ye box open karega
  TaskProvider() {
    _init();
  }

  // Database Access Karna
  Future<void> _init() async {
    // Agar box pehle se khula hai to wahi use karo, warna kholo
    if (Hive.isBoxOpen('tasks')) {
      _taskBox = Hive.box<Task>('tasks');
    } else {
      _taskBox = await Hive.openBox<Task>('tasks');
    }
    notifyListeners(); // UI ko batao ke main ready hoon
  }

  // 1. Get All Tasks (List lene ke liye)
  List<Task> get tasks {
    if (_taskBox == null) return [];
    // Tasks ko list mein convert karo aur sort karo (Newest first)
    final taskList = _taskBox!.values.toList();
    taskList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return taskList;
  }

  // 2. Add Task (Naya task dalne ke liye)
  Future<void> addTask(String title, String desc, String priority) async {
    final newTask = Task(
      title: title,
      description: desc,
      priority: priority,
      createdAt: DateTime.now(),
      isCompleted: false,
    );
    await _taskBox?.add(newTask);
    notifyListeners(); // UI update karo
  }

  // 3. Delete Task
  Future<void> deleteTask(Task task) async {
    await task.delete(); // Hive ka built-in delete function
    notifyListeners();
  }

  // 4. Update Status (Tick mark lagane ke liye)
  Future<void> toggleTaskStatus(Task task) async {
    task.isCompleted = !task.isCompleted;
    await task.save(); // Save changes
    notifyListeners();
  }
}