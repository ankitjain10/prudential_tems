import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Riverpod Clean Architecture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoScreen(),
    );
  }
}

// Domain Layer
class Todo {
  final int id;
  final String title;

  Todo({required this.id, required this.title});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
    );
  }
}

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<void> addTodo(String title);
  Future<void> removeTodo(int id);
}

class GetTodosUseCase {
  final TodoRepository repository;
  GetTodosUseCase(this.repository);
  Future<List<Todo>> call() => repository.getTodos();
}

// Data Layer
class TodoRepositoryImpl implements TodoRepository {
  final Dio dio;
  TodoRepositoryImpl(this.dio);

  @override
  Future<List<Todo>> getTodos() async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/todos?_limit=10');
    return (response.data as List).map((json) => Todo.fromJson(json)).toList();
  }

  @override
  Future<void> addTodo(String title) async {
    await dio.post('https://jsonplaceholder.typicode.com/todos', data: {'title': title});
  }

  @override
  Future<void> removeTodo(int id) async {
    await dio.delete('https://jsonplaceholder.typicode.com/todos/\$id');
  }
}

final dioProvider = Provider<Dio>((ref) => Dio());

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TodoRepositoryImpl(dio);
});

// Application Layer (State Management)
final getTodosProvider = FutureProvider<List<Todo>>((ref) async {
  final repository = ref.watch(todoRepositoryProvider);
  return repository.getTodos();
});

final todoListProvider = StateNotifierProvider<TodoListNotifier, AsyncValue<List<Todo>>>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return TodoListNotifier(repository);
});

class TodoListNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  final TodoRepository repository;
  TodoListNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      final todos = await repository.getTodos();
      state = AsyncValue.data(todos);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addTodo(String title) async {
    await repository.addTodo(title);
    fetchTodos();
  }

  Future<void> removeTodo(int id) async {
    await repository.removeTodo(id);
    fetchTodos();
  }
}

// UI Layer
class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoListProvider);
    final notifier = ref.watch(todoListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('To-Do App')),
      body: todoState.when(
        data: (todos) => ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return ListTile(
              title: Text(todo.title),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => notifier.removeTodo(todo.id),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: \$error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => notifier.addTodo('New Task'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
