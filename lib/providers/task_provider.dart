import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  Box<Task>? _taskBox;

  TaskProvider() {
    _init();
  }

  // Database Access
  Future<void> _init() async {
    if (Hive.isBoxOpen('tasks')) {
      _taskBox = Hive.box<Task>('tasks');
    } else {
      _taskBox = await Hive.openBox<Task>('tasks');
    }
    notifyListeners();
  }

  // 1. Get All Tasks
  List<Task> get tasks {
    if (_taskBox == null) return [];
    // Tasks List (Newest first)
    final taskList = _taskBox!.values.toList();
    taskList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return taskList;
  }

  // 2. Add Task
  Future<void> addTask(String title, String desc, String priority) async {
    final newTask = Task(
      title: title,
      description: desc,
      priority: priority,
      createdAt: DateTime.now(),
      isCompleted: false,
    );
    await _taskBox?.add(newTask);
    notifyListeners(); // UI update
  }

  // 3. Delete Task
  Future<void> deleteTask(Task task) async {
    await task.delete(); // Hive built-in delete function
    notifyListeners();
  }

  // 4. Update Status (For Tick mark )
  Future<void> toggleTaskStatus(Task task) async {
    task.isCompleted = !task.isCompleted;
    await task.save(); // Save changes
    notifyListeners();
  }
}
