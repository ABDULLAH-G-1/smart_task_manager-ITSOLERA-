import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart'; // Model import
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  final Task?
  taskToEdit; //if it is not null :means we are in editing mode

  const AddTaskScreen({super.key, this.taskToEdit});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    //if edit mode pick the previous data other wise empty
    _titleController = TextEditingController(
      text: widget.taskToEdit?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.taskToEdit?.description ?? '',
    );
    _selectedPriority = widget.taskToEdit?.priority ?? 'Low';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final desc = _descController.text.trim();

      if (widget.taskToEdit != null) {
        // --- EDIT MODE ---
        //In Provider call update function
        context.read<TaskProvider>().updateTask(
          widget.taskToEdit!,
          title,
          desc,
          _selectedPriority,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task Updated Successfully')),
        );
      } else {
        // --- ADD MODE ---
        context.read<TaskProvider>().addTask(title, desc, _selectedPriority);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task Added Successfully')),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Change the Title  based on mode
    final isEdit = widget.taskToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Task" : "Add New Task"),
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
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Task Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.task_alt),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Please enter a title"
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.flag_outlined),
                ),
                items: ['High', 'Medium', 'Low']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedPriority = val!),
              ),
              const SizedBox(height: 16),
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
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: isEdit
                      ? Colors.orange
                      : Colors.blue, // In Edit  Orange color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isEdit ? "Update Task" : "Save Task",
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
