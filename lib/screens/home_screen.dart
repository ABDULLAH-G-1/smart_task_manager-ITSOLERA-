import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for contrast
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Card( 
          elevation: 0,
          color: Colors.grey[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: TextField(
            onChanged: (value) {
              // call provider for search
              context.read<TaskProvider>().searchTasks(value);
            },
            decoration: const InputDecoration(
              hintText: "Search tasks...",
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // Body:
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final tasks = provider.tasks;

          // 1. Empty State
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

          // 2. List View
          return ListView.builder(
            itemCount: tasks.length,
            padding: const EdgeInsets.only(bottom: 80),
            // ListView.builder
            itemBuilder: (context, index) {
              final task = tasks[index];
              return GestureDetector(
                onTap: () {
                  // open screen in edit mode
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskScreen(taskToEdit: task),
                    ),
                  );
                },
                child: TaskTile(
                  task: task,
                  onStatusChanged: () {
                    provider.toggleTaskStatus(task);
                  },
                  onDelete: () {
                    provider.deleteTask(task);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
