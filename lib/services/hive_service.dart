// lib/services/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoo_app/models/task.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; // Make sure this is imported

part 'hive_service.g.dart';

class HiveService {
  late Box<Task> _taskBox; // declare the box
  late Box _appSettingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
      debugPrint('HiveService: TaskAdapter registered.');
    }

    if (!Hive.isBoxOpen('myTodooTasks')) {
      _taskBox = await Hive.openBox<Task>('myTodooTasks');
      debugPrint('HiveService: Box "myTodooTasks" opened.');
    } else {
      _taskBox = Hive.box<Task>('myTodooTasks'); // Get the already open box
      debugPrint(
        'HiveService: Box "myTodooTasks" was already open, retrieved existing instance.',
      );
    }
    if (!Hive.isBoxOpen('appSettings')) {
      _appSettingsBox = await Hive.openBox(
        'appSettings',
      ); // This box stores dynamic types
      debugPrint('HiveService: Box "appSettings" opened.');
    } else {
      _appSettingsBox = Hive.box('appSettings');
      debugPrint(
        'HiveService: Box "appSettings" was already open, retrieved existing instance.',
      );
    }
  }

  // Generic put method
  Future<void> put<T>(String key, T value) async {
    await _appSettingsBox.put(key, value);
  }

  // Generic get method
  T? get<T>(String key) {
    return _appSettingsBox.get(key);
  }

  // CRUD

  // getTasks is not deleted
  List<Task> getTasks() {
    return _taskBox.values.where((task) => !task.isDeleted).toList();
  }

  // getDeletedTask
  List<Task> getDeletedTasks() {
    return _taskBox.values.where((task) => task.isDeleted).toList();
  }

  // addTask
  Future<void> addTask(Task task) {
    return _taskBox.put(task.id, task);
  }

  // updateTask
  Future<void> updateTask(Task task) {
    return _taskBox.put(task.id, task);
  }

  // softdeleteTask
  Future<void> softDeleteTask(String taskId) async {
    final taskToDelete = _taskBox.get(taskId);
    if (taskToDelete != null) {
      taskToDelete.isDeleted = true;
      taskToDelete.updatedAt = DateTime.now();
      await _taskBox.put(taskId, taskToDelete); // update the task in the box
    }
  }

  // hardDeleteTask
  Future<void> hardDeleteTask(String taskId) async {
    final taskTitle = _taskBox.get(taskId)?.title ?? 'Unknown';
    await _taskBox.delete(taskId);
    debugPrint(
      'HiveService: Permanently deleted task: "$taskTitle" (ID: $taskId)',
    );
    if (_taskBox.get(taskId) == null) {
      debugPrint(
        'HiveService: Verification: Task $taskId is truly gone from the box.',
      );
    } else {
      debugPrint(
        'HiveService: Verification: Task $taskId *STILL EXISTS* in the box after delete attempt!',
      );
    }
  }

  // Restore a soft-deleted task
  Future<void> restoreTask(String taskId) async {
    final taskToRestore = _taskBox.get(taskId);
    if (taskToRestore != null) {
      taskToRestore.isDeleted = false; // Mark as not deleted
      await _taskBox.put(taskToRestore.id, taskToRestore); // Update the task
    }
  }

  Future<void> close() async {
    // Only close if it's the specific box you opened
    if (Hive.isBoxOpen('myTodooTasks')) {
      return _taskBox.close();
    }
    if (Hive.isBoxOpen('appSettings')) {
      return _appSettingsBox.close();
    }
    return Future.value();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    await _taskBox.clear();
    for (var task in tasks) {
      await _taskBox.put(task.id, task);
    }
  }
}

// Riverpod provider for HiveService
@Riverpod(keepAlive: true)
// ignore: deprecated_member_use_from_same_package
HiveService hiveService(HiveServiceRef ref) {
  throw UnimplementedError(
    'hiveService must be overridden in main.dart. Ensure main.dart provides the initialized HiveService instance via overrides.',
  );
}
