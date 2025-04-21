import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/features/auth/widgets/snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isHiddenPassword = true;
  TextEditingController nameTextInputController = TextEditingController();
  TextEditingController phoneTextInputController = TextEditingController();
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  TextEditingController repeatedPasswordTextInputController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameTextInputController.dispose();
    phoneTextInputController.dispose();
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    repeatedPasswordTextInputController.dispose();
    super.dispose();
  }

  void togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> register() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (passwordTextInputController.text !=
        repeatedPasswordTextInputController.text) {
      SnackBarService.showSnackBar(context, 'Пароли должны совпадать', true);
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextInputController.text.trim(),
          password: passwordTextInputController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e.code);

      if (e.code == 'email-already-in-use') {
        SnackBarService.showSnackBar(
            context, 'Пользователь уже существует', true);
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
      }
    }

    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              controller: nameTextInputController,
              validator: ((name) => name == null || name.trim().isEmpty
                  ? 'Введите правильное Имя'
                  : null),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Введите Имя',
              ),
            ),
            TextFormField(
              autocorrect: false,
              controller: phoneTextInputController,
              validator: ((phone) => phone == null || phone.trim().isEmpty
                  ? 'Введите правильный номер'
                  : null),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Введите номер',
              ),
            ),
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
                    child: Icon(
                      isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black,
                    ),
                  )),
            ),
            TextFormField(
              autocorrect: false,
              obscureText: isHiddenPassword,
              controller: repeatedPasswordTextInputController,
              validator: (value) => value != null && value.length < 6
                  ? 'Минимум 6 символов'
                  : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Введите Повторно Пароль',
                  suffix: InkWell(
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
                  register();
                },
                child: const Text('Зарегистрироваться')),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text(
                'Войти',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
