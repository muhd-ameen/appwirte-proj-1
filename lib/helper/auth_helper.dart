// ignore_for_file: library_prefixes

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as Model;
import 'package:todoapp/app/view/app.dart';

class AuthHelper {
  final Account account = Account(client);
  Future<Model.Account> createUserWithEmail({
    required String email,
    required String password,
  }) {
    try {
      final response = account.create(
        email: email,
        password: password,
        userId: ID.unique(),
      );
      return response;
    } on AppwriteException {
      rethrow;
    }
  }
}
