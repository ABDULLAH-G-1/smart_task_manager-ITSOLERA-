import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for contrast
      appBar: AppBar(
        title: const Text(
          "My Tasks",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black, // Text color black
      ),

      // Floating Action Button (Add Task ke liye)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Open Add Task Screen (Next Milestone)
          // Filhal testing ke liye dummy task add kar rahe hain
          context.read<TaskProvider>().addTask(
            "Test Task ${DateTime.now().second}",
            "This is a description to check long text handling functionality.",
            "High",
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // Body: Consumer Data Sunega
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final tasks = provider.tasks;

          // 1. Empty State (Agar koi task nahi hai)
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_add, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    "No tasks yet!",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const Text(
                    "Click + to add a new task",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // 2. List View (Agar tasks hain)
          return ListView.builder(
            itemCount: tasks.length,
            padding: const EdgeInsets.only(bottom: 80), // FAB ke liye jagah
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskTile(
                task: task,
                onStatusChanged: () {
                  provider.toggleTaskStatus(task);
                },
                onDelete: () {
                  provider.deleteTask(task);
                },
              );
            },
          );
        },
      ),
    );
  }
}
