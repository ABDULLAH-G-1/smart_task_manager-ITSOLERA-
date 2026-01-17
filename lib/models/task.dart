import 'package:hive/hive.dart';

// Ye line error degi jab tak hum generator command nahi chalayenge.
// Isay filhal ignore karna.
part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String title;       // Task ka naam

  @HiveField(1)
  String description; // Details (Long text handling ke liye)

  @HiveField(2)
  bool isCompleted;   // Completed ya Pending

  @HiveField(3)
  DateTime createdAt; // Sorting ke liye (Newest first)

  @HiveField(4)
  String priority;    // Bonus: 'Low', 'Medium', 'High'

  Task({
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.priority = 'Low',
  });
}