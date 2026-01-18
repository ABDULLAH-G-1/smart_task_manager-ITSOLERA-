import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Form  key
  final _formKey = GlobalKey<FormState>();

  // Input Controllers
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedPriority = 'Low'; // Default value

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Save Function
  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      context.read<TaskProvider>().addTask(
        _titleController.text.trim(),
        _descController.text.trim(),
        _selectedPriority,
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task Added Successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Task"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Title Input
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Task Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.task_alt),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a title"; // Validation Error
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Priority Dropdown
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.flag_outlined),
                ),
                items: ['High', 'Medium', 'Low'].map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // 3. Description Input (Big Box)
              TextFormField(
                controller: _descController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Description (Optional)",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Icon(Icons.description),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Save Button
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Task",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
