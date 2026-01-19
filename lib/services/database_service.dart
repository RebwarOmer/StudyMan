import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Users ---

  Future<void> saveUser({required String uid, required String email, required String username}) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) {
    return _firestore.collection('users').doc(uid).get();
  }

  Future<void> updateUsername(String uid, String username) async {
    await _firestore.collection('users').doc(uid).update({
      'username': username,
    });
  }

  Future<void> deleteUserData(String uid) async {
    // Delete Todos
    final todosSnapshot = await _firestore.collection('users').doc(uid).collection('todos').get();
    for (var doc in todosSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete Notes
    final notesSnapshot = await _firestore.collection('users').doc(uid).collection('notes').get();
    for (var doc in notesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete User Doc
    await _firestore.collection('users').doc(uid).delete();
  }

  // --- Todos ---

  CollectionReference<Map<String, dynamic>> _todosRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('todos');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTodosStream(String uid, {int? limit}) {
    Query<Map<String, dynamic>> query = _todosRef(uid).orderBy('createdAt', descending: true);
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots();
  }

  Future<void> addTodo(String uid, String title) async {
    await _todosRef(uid).add({
      'title': title,
      'isDone': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleTodo(String uid, String docId, bool currentStatus) async {
    await _todosRef(uid).doc(docId).update({
      'isDone': !currentStatus,
    });
  }

  Future<void> updateTodoTitle(String uid, String docId, String newTitle) async {
    await _todosRef(uid).doc(docId).update({
      'title': newTitle,
    });
  }

  Future<void> deleteTodo(String uid, String docId) async {
    await _todosRef(uid).doc(docId).delete();
  }

  // --- Notes ---

  CollectionReference<Map<String, dynamic>> _notesRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('notes');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotesStream(String uid, {int? limit}) {
    Query<Map<String, dynamic>> query = _notesRef(uid).orderBy('createdAt', descending: true);
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots();
  }

  Future<void> addNote(String uid, String title, String content) async {
    await _notesRef(uid).add({
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(String uid, String docId, String title, String content) async {
    await _notesRef(uid).doc(docId).update({
      'title': title,
      'content': content,
    });
  }

  Future<void> deleteNote(String uid, String docId) async {
    await _notesRef(uid).doc(docId).delete();
  }
}
