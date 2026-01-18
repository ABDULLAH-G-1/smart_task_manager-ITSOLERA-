import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  Box<Task>? _taskBox;
  String _searchQuery = '';

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

    // List the all tasks
    final allTasks = _taskBox!.values.toList();

    // Sort tha tasks (Newest First)
    allTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // if search bar is empty :show all the tasks
    if (_searchQuery.isEmpty) {
      return allTasks;
    } else {
      //other wise show the searched tasks
      return allTasks.where((task) {
        final query = _searchQuery.toLowerCase();
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList();
    }
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
  // 5. Update Task Details (Edit)
  Future<void> updateTask(Task task, String newTitle, String newDesc, String newPriority) async {
    task.title = newTitle;
    task.description = newDesc;
    task.priority = newPriority;
    await task.save();
    notifyListeners();
  }

  // 4. Update Status (For Tick mark )
  Future<void> toggleTaskStatus(Task task) async {
    task.isCompleted = !task.isCompleted;
    await task.save(); // Save changes
    notifyListeners();
  }
  // 5. Search Function
  void searchTasks(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
