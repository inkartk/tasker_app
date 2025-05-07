import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_the_best_project/features/auth/pages/navigation_tabbar.dart';
import 'package:my_the_best_project/features/auth/widgets/snackbar.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isVerifyEmail = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      isVerifyEmail = user.emailVerified;

      if (!isVerifyEmail) {
        sendVerificationEmail();

        timer = Timer.periodic(
          const Duration(seconds: 3),
          (_) => checkEmailVerified(),
        );
      }
    } else {
      Future.microtask(() {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await user.reload();

    final refreshedUser = FirebaseAuth.instance.currentUser;
    final isVerified = refreshedUser?.emailVerified ?? false;

    setState(() {
      isVerifyEmail = isVerified;
    });

    if (isVerifyEmail) {
      timer?.cancel();
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      if (mounted) {
        SnackBarService.showSnackBar(
          context,
          '$e',
          true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => isVerifyEmail
      ? const NavigationTabBar()
      : Scaffold(
          appBar: AppBar(
            title: const Text('Verify Email'),
          ),
          body: Column(
            children: [
              const Text(
                'Письмо с подтверждением было отправлено на вашу электронную почту.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  canResendEmail ? sendVerificationEmail() : null;
                },
                icon: const Icon(Icons.email),
                label: const Text('Повторно отправить'),
              ),
            ],
          ),
        );
}
