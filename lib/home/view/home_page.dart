// ignore_for_file: cascade_invocations, inference_failure_on_instance_creation, lines_longer_than_80_chars

import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:todoapp/add_todo/view/add_todo_view.dart';
import 'package:todoapp/helper/auth_helper.dart';
import 'package:todoapp/helper/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  model.DocumentList? todoList;
  @override
  void initState() {
    getData();
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final authHelper = AuthHelper();
              authHelper.signOut(context: context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
        title: const Text('Home'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTodoPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: todoList == null || todoList!.documents.isEmpty || isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: todoList!.documents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    todoList!.documents[index].data['title'].toString(),
                  ),
                  subtitle: Text(
                    todoList!.documents[index].data['image'].toString(),
                  ),
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (todoList!.documents[index].data['image'] != null)
                        FutureBuilder(
                          future: DataBaseHelper().storage.getFilePreview(
                                fileId: todoList!.documents[index].data['image']
                                    as String,
                                bucketId: '647b0787b87b8151d5ff',
                              ),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Image.memory(
                                    snapshot.data!,
                                  )
                                : const CircularProgressIndicator();
                          },
                        ),
                      Checkbox(
                        value: todoList!.documents[index].data['isCompleted']
                            as bool,
                        onChanged: (value) {
                          setState(() {
                            todoList!.documents[index].data['isCompleted'] =
                                value;
                          });
                          final databaseHelper = DataBaseHelper();
                          databaseHelper.updateIsCompleted(
                            documentId: todoList!.documents[index].$id,
                            isCompleted: value!,
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          final databaseHelper = DataBaseHelper();
                          databaseHelper
                              .deleteTodo(
                                documentId: todoList!.documents[index].$id,
                              )
                              .then(
                                (value) => setState(
                                  () => todoList!.documents.removeAt(
                                    index,
                                  ),
                                ),
                              );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    final databaseHelper = DataBaseHelper();
    todoList = await databaseHelper.getAllTodos();
    setState(() {
      isLoading = false;
    });
  }
}
