
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/todo_model.dart';

class TodoRemoteDataSource {
  final FirebaseFirestore firestore;

  TodoRemoteDataSource({required this.firestore});

  // Helper: Get collection reference
  CollectionReference<Map<String, dynamic>> _todosRef(String userId) {
    return firestore.collection('users').doc(userId).collection('todos');
  }

  /// Create a new todo and auto-generate ID
  Future<TodoModel> createTodo(String userId, TodoModel todo) async {
    try {
      final docRef = _todosRef(userId).doc();
      final todoWithId = todo.copyWith(
        id: docRef.id,
        createdDate: DateTime.now(),
      );
      await docRef.set(todoWithId.toMap());
      return todoWithId;
    } catch (e) {
      // Handle/log error as needed
      rethrow;
    }
  }

  /// Get all todos for a user
  Future<List<TodoModel>> getTodos(String userId) async {
    try {
      final snapshot = await _todosRef(userId).get();
      return snapshot.docs.map((doc) => TodoModel.fromMap(doc.data())).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Update an existing todo
  Future<void> updateTodo(String userId, TodoModel todo) async {
    try {
      await _todosRef(userId).doc(todo.id).update(todo.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a todo by ID
  Future<void> deleteTodo(String userId, String todoId) async {
    try {
      await _todosRef(userId).doc(todoId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllTodo(String userId) async {
    try {
      final todosSnapshot = await _todosRef(userId).get();
      final batch = firestore.batch();

      for (var doc in todosSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

    } catch (e) {
      rethrow;
    }
  }

}

