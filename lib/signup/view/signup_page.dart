// ignore_for_file: unused_field, inference_failure_on_instance_creation

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/helper/auth_helper.dart';
import 'package:todoapp/home/view/home_page.dart';
import 'package:todoapp/login/login.dart';
import 'package:todoapp/util/regex.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpModel model = SignUpModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('SignUp', style: Theme.of(context).textTheme.titleLarge),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  onSaved: (newValue) => model.name = newValue,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    model.email = value;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (!passwordRegex.hasMatch(value)) {
                      return 'Please enter a valid password';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    model.password = value;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      try {
                        await AuthHelper()
                            .createUserWithEmail(
                              email: model.email!,
                              password: model.password!,
                              name: model.name!,
                            )
                            .then(
                              (value) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              ),
                            );
                      } catch (e) {
                        log(e.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                      // do something with email and password
                    }
                  },
                  child: const Text('Signup'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'OR',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Signup with Google'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Signup with Apple'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    children: [
                      // ignore: prefer_const_constructors
                      TextSpan(
                        text: 'Already have an account? ',
                        style: const TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Login',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpModel {
  SignUpModel({
    this.email,
    this.password,
    this.name,
  });
  String? email;
  String? password;
  String? name;
}
