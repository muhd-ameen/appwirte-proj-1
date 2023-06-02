// ignore_for_file: library_prefixes, inference_failure_on_instance_creation

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:todoapp/app/view/app.dart';
import 'package:todoapp/login/login.dart';
import 'package:todoapp/util/prefs.dart';

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

  Future<model.Session> loginAnounymously() {
    try {
      final response = account.createAnonymousSession();
      return response;
    } on AppwriteException {
      rethrow;
    }
  }

  Future<bool> signOut({required BuildContext context}) async {
    try {
      await account.deleteSessions();
      Prefs.removeSession();
      // ignore: use_build_context_synchronously
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> loginWithNumber(String s) async {
    try {
      final token = await account.createPhoneSession(
        userId: ID.unique(),
        phone: s,
      );
      return token.userId;

      //verify token
    } on AppwriteException {
      rethrow;
    }
  }

  Future<model.Session> verifyOTP({
    required String userId,
    required String otp,
  }) async {
    try {
      final session = await account.updatePhoneSession(
        userId: userId,
        secret: otp,
      );
      return session;
    } catch (e) {
      rethrow;
    }
  }
}
