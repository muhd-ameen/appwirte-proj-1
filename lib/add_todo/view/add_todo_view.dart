// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/helper/database_helper.dart';
import 'package:todoapp/home/view/home_page.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
//formKey
  final formKey = GlobalKey<FormState>();

  TodoModel todoModel = TodoModel(
    title: '',
    description: '',
    image: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) => value!.isEmpty ? 'Enter Title' : null,
                onSaved: (value) {
                  todoModel.title = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter Description' : null,
                onSaved: (value) {
                  todoModel.description = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),

              /// add image button
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      todoModel.image = image.path;
                      print('${todoModel.image}picked image path');
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child:
                    Text(todoModel.image != null ? 'Image Added' : 'Add Image'),
              ),

              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    await DataBaseHelper().createTodo(
                      title: todoModel.title,
                      description: todoModel.description,
                      image: todoModel.image,
                    );
                    print(todoModel.title);
                    print(todoModel.description);
                    await Navigator.push(
                      context,
                      // ignore: inference_failure_on_instance_creation
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Todo Added Successfully'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text('Add Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoModel {
  TodoModel({
    required this.title,
    required this.description,
    this.image,
    this.isCompleted = false,
  });
  String title;
  String description;
  String? image;
  final bool isCompleted;
}
