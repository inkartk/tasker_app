import 'package:flutter/material.dart';

class ToDoTextField extends StatefulWidget {
  const ToDoTextField({super.key});

  @override
  State<ToDoTextField> createState() => _ToDoTextFieldState();
}

class _ToDoTextFieldState extends State<ToDoTextField> {
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 300,
        child: TextFormField(
          autocorrect: false,
          controller: inputController,
          validator: ((name) => name == null || name.trim().isEmpty
              ? 'Введите правильное Имя'
              : null),
        ),
      ),
    );
  }
}
