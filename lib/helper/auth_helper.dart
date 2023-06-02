// ignore_for_file: library_prefixes

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:todoapp/app/view/app.dart';

class AuthHelper {
  final Account account = Account(client);
  Future<model.Account> createUserWithEmail({
    required String email,
    required String password,
    required String name,
  }) {
    try {
      final response = account.create(
        email: email,
        password: password,
        name: name,
        userId: ID.unique(),
      );
      return response;
    } on AppwriteException {
      rethrow;
    }
  }

  Future<model.Session> loginUserWithEmail({
    required String email,
    required String password,
  }) {
    try {
      final response = account.createEmailSession(
        email: email,
        password: password,
      );
      return response;
    } on AppwriteException {
      rethrow;
    }
  }

  Future<bool> signOut() async {
    try {
      await account.deleteSessions();
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
