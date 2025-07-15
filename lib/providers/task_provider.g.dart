// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$uninitializedHiveServiceHash() =>
    r'5af1cba7b2995718f9efb6b027b1a12448f68084';

/// See also [uninitializedHiveService].
@ProviderFor(uninitializedHiveService)
final uninitializedHiveServiceProvider = Provider<HiveService>.internal(
  uninitializedHiveService,
  name: r'uninitializedHiveServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$uninitializedHiveServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UninitializedHiveServiceRef = ProviderRef<HiveService>;
String _$initializedHiveServiceHash() =>
    r'7ee8c32e6eba1da18560c4b72855eb3108f83e29';

/// See also [initializedHiveService].
@ProviderFor(initializedHiveService)
final initializedHiveServiceProvider = FutureProvider<HiveService>.internal(
  initializedHiveService,
  name: r'initializedHiveServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initializedHiveServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InitializedHiveServiceRef = FutureProviderRef<HiveService>;
String _$tasksHash() => r'0a9ad240f66fcfc51c3c2043925cf68bd16a6991';

/// See also [Tasks].
@ProviderFor(Tasks)
final tasksProvider = AsyncNotifierProvider<Tasks, List<Task>>.internal(
  Tasks.new,
  name: r'tasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Tasks = AsyncNotifier<List<Task>>;
String _$deletedTasksHash() => r'8636ca757ecd78a31a069da06319c43485f26621';

/// See also [DeletedTasks].
@ProviderFor(DeletedTasks)
final deletedTasksProvider =
    AsyncNotifierProvider<DeletedTasks, List<Task>>.internal(
  DeletedTasks.new,
  name: r'deletedTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$deletedTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeletedTasks = AsyncNotifier<List<Task>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
