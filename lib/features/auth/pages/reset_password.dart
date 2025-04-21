import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/features/auth/widgets/snackbar.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailTextInputController.text);
    } on FirebaseAuthException catch (e) {
      print(e.code);

      if (e.code == 'user-not-found') {
        SnackBarService.showSnackBar(
          context,
          'Такой email незарегистрирован!',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
        return;
      }
    }
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ResetPassword Page'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              controller: emailTextInputController,
              validator: ((email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Введите правильный email'
                      : null),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Введите Email',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  resetPassword();
                },
                child: const Text('Сбросить пароль')),
          ],
        ),
      ),
    );
  }
}
