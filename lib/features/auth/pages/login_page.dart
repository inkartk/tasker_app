import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/features/auth/widgets/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    super.dispose();
  }

  void togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        SnackBarService.showSnackBar(
          context,
          'Неправильный email или пароль. Повторите попытку',
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

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
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
            TextFormField(
              autocorrect: false,
              obscureText: isHiddenPassword,
              controller: passwordTextInputController,
              validator: ((password) => password != null && password.length < 6
                  ? 'Минимум 6 символов'
                  : null),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Введите Пароль',
                  suffix: InkWell(
                    onTap: togglePassword,
                    child: Icon(
                      isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black,
                    ),
                  )),
            ),
            ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                child: const Text('Войти')),
            TextButton(
                onPressed: () {
                  context.go('/reset_password');
                },
                child: const Text('Забыли пароль?')),
            TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: const Text('Регистрация')),
          ],
        ),
      ),
    );
  }
}
