import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoo_app/models/task.dart';
import 'package:todoo_app/services/hive_service.dart';
import 'package:flutter/foundation.dart';

part 'task_provider.g.dart';

@Riverpod(keepAlive: true)
// ignore: deprecated_member_use_from_same_package
HiveService uninitializedHiveService(UninitializedHiveServiceRef ref) {
  final service = HiveService();
  ref.onDispose(() {
    service.close();
  });
  return service;
}

@Riverpod(keepAlive: true)
Future<HiveService> initializedHiveService(
  // ignore: deprecated_member_use_from_same_package
  InitializedHiveServiceRef ref,
) async {
  final hiveService = ref.watch(uninitializedHiveServiceProvider);
  await hiveService.init(); // Await the initialization here
  return hiveService;
}

// 3. The Tasks Notifier - now correctly consumes the initialized service
@Riverpod(keepAlive: true)
class Tasks extends _$Tasks {
  @override
  Future<List<Task>> build() async {
    // Await the initialized HiveService Future to get the actual service instance
    final hiveService = await ref.watch(initializedHiveServiceProvider.future);
    return hiveService.getTasks();
  }

  Future<void> addTask(Task task) async {
    state = const AsyncValue.loading();
    try {
      final hiveService = await ref.read(initializedHiveServiceProvider.future);
      await hiveService.addTask(task);
      state = AsyncValue.data(hiveService.getTasks());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTask(Task task) async {
    state = const AsyncValue.loading();
    try {
      final hiveService = await ref.read(initializedHiveServiceProvider.future);
      await hiveService.updateTask(task);
      state = AsyncValue.data(hiveService.getTasks());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> softDeleteTask(String taskId) async {
    state = const AsyncValue.loading();
    try {
      final hiveService = await ref.read(initializedHiveServiceProvider.future);
      await hiveService.softDeleteTask(taskId);
      state = AsyncValue.data(hiveService.getTasks());
      ref.read(deletedTasksProvider.notifier).refreshDeletedTasks();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> hardDeleteTask(String taskId) async {
    state = const AsyncValue.loading();
    try {
      final hiveService = await ref.read(initializedHiveServiceProvider.future);
      await hiveService.hardDeleteTask(taskId);

      state = AsyncValue.data(hiveService.getTasks());
      ref.read(deletedTasksProvider.notifier).refreshDeletedTasks();
      debugPrint(
        'TasksProvider: Hard-deleted. Main and Deleted lists refreshed.',
      );
    } catch (e, st) {
      debugPrint('TasksProvider ERROR during hardDeleteTask: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> restoreTask(String taskId) async {
    state = const AsyncValue.loading();
    try {
      final hiveService = await ref.read(initializedHiveServiceProvider.future);
      await hiveService.restoreTask(taskId);
      state = AsyncValue.data(hiveService.getTasks()); // Refresh state
      ref.read(deletedTasksProvider.notifier).refreshDeletedTasks();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshTasks() async {
    state = const AsyncValue.loading();
    try {
      final hiveService = await ref.read(initializedHiveServiceProvider.future);
      state = AsyncValue.data(hiveService.getTasks());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@Riverpod(keepAlive: true)
class DeletedTasks extends _$DeletedTasks {
  @override
  Future<List<Task>> build() async {
    final hiveService = await ref.watch(initializedHiveServiceProvider.future);
    return hiveService.getDeletedTasks(); // Use your new method here!
  }

  // You need methods to refresh this provider when changes occur
  Future<void> refreshDeletedTasks() async {
    state = const AsyncValue.loading();
    try {
      final hiveService = await ref.read(initializedHiveServiceProvider.future);
      state = AsyncValue.data(hiveService.getDeletedTasks());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
