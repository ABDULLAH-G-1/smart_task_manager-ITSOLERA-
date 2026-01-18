import 'package:hive/hive.dart';


part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;       // Task name

  @HiveField(1)
  String description; // Details (for Long text handling )

  @HiveField(2)
  bool isCompleted;   // Completed or Pending

  @HiveField(3)
  DateTime createdAt; // Sorting  (Newest first)

  @HiveField(4)
  String priority;    // perority: 'Low', 'Medium', 'High'

  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.priority = 'Low',
  });
}