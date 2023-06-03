// ignore_for_file: flutter_style_todos, duplicate_ignore

import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:todoapp/app/app.dart';

class DataBaseHelper {
  Databases databases = Databases(client);
  Storage storage = Storage(client);

  String getImageUrl({required String bucketId, required String fileId}) {
    final url =
        'https://cloud.appwrite.io/v1/storage/buckets/$bucketId/files/$fileId/view?project=647a637e68a48b1d204f&mode=admin';
    return url;
  }

  // ignore: flutter_style_todos
  /// create todo document
  Future<model.Document> createTodo({
    required String title,
    required String description,
    String? image,
  }) async {
    final model.Document response;
    try {
      if (image != null) {
        final imageId = await createFileStorage(image);
        log(imageId, name: 'imageId');
        // ignore: join_return_with_assignment
        response = await databases.createDocument(
          databaseId: '647a73caa051c6f77ce3',
          collectionId: '647a73d7c779cc8d79f8',
          documentId: ID.unique(),
          data: {
            'title': title,
            'description': description,
            'isCompleted': false,
            'createdOn': DateTime.now().toString(),
            'picture': imageId,
          },
        );
        return response;
      } else {
        response = await databases.createDocument(
          databaseId: '647a73caa051c6f77ce3',
          collectionId: '647a73d7c779cc8d79f8',
          documentId: ID.unique(),
          data: {
            'title': title,
            'description': description,
            'isCompleted': false,
            'createdOn': DateTime.now().toString(),
          },
        );
      }
      return response;
    } on AppwriteException {
      rethrow;
    }
  }

  /// get all todos

  Future<model.DocumentList> getAllTodos() async {
    try {
      final response = await databases.listDocuments(
        databaseId: '647a73caa051c6f77ce3',
        collectionId: '647a73d7c779cc8d79f8',
      );

      return response;
    } on AppwriteException {
      rethrow;
    }
  }

  /// update todo
  Future<model.Document> updateIsCompleted({
    required String documentId,
    required bool isCompleted,
  }) async {
    try {
      final response = await databases.updateDocument(
        databaseId: '647a73caa051c6f77ce3',
        collectionId: '647a73d7c779cc8d79f8',
        documentId: documentId,
        data: {
          'isCompleted': isCompleted,
        },
      );
      return response;
    } on AppwriteException {
      rethrow;
    }
  }

  /// delete todo
  Future<void> deleteTodo({
    required String documentId,
  }) async {
    try {
      await databases.deleteDocument(
        databaseId: '647a73caa051c6f77ce3',
        collectionId: '647a73d7c779cc8d79f8',
        documentId: documentId,
      );
    } on AppwriteException {
      rethrow;
    }
  }

  Future<String> createFileStorage(String image) async {
    try {
      final response = await storage.createFile(
        bucketId: '647b0787b87b8151d5ff',
        fileId: ID.unique(),
        file: InputFile.fromPath(path: image, filename: 'image.png'),
      );
      return response.$id;
    } on AppwriteException {
      rethrow;
    }
  }

  Future<List<int>> getFilePreview({
    required String bucketId,
    required String fileId,
  }) async {
    try {
      final response = await storage.getFilePreview(
        bucketId: bucketId,
        fileId: fileId,
      );
      return response;
    } on AppwriteException {
      rethrow;
    }
  }
}
