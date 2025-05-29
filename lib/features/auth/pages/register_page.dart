import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  void _togglePassword() {
    setState(() => _hidePassword = !_hidePassword);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();
    final password2 = _pass2Ctrl.text.trim();

    if (password != password2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Пароли должны совпадать'),
            backgroundColor: Colors.red),
      );
      return;
    }

    // 1) Сгенерить код
    final code = (100000 + Random().nextInt(900000)).toString();

    // 2) Записать документ в Firestore
    await FirebaseFirestore.instance
        .collection('email_verifications')
        .doc(email)
        .set({
      'code': code,
      'name': name,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 3) Перейти на экран ввода кода, передав email и пароль
    GoRouter.of(context).push(
      '/verify-code',
      extra: {
        'email': email,
        'password': password,
        'name': name,
      },
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF7FAFC),
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          suffixIcon: suffix,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/login')),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(children: [
            Text(
              'TASKER',
              style: GoogleFonts.righteous(
                fontSize: 30,
                color: const Color(0xFF006EE9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Management App',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9A9A9A),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Create your account',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            _buildField(
              controller: _nameCtrl,
              hint: 'Username',
              icon: Icons.person,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Введите имя' : null,
            ),
            _buildField(
              controller: _emailCtrl,
              hint: 'Email',
              icon: Icons.email,
              validator: (v) => v != null && EmailValidator.validate(v)
                  ? null
                  : 'Неверный email',
            ),
            _buildField(
              controller: _passCtrl,
              hint: 'Password',
              icon: Icons.lock,
              obscure: _hidePassword,
              suffix: IconButton(
                icon: Icon(
                    _hidePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: _togglePassword,
              ),
              validator: (v) =>
                  v != null && v.length >= 6 ? null : 'Минимум 6 символов',
            ),
            _buildField(
              controller: _pass2Ctrl,
              hint: 'Confirm Password',
              icon: Icons.lock,
              obscure: _hidePassword,
              validator: (v) =>
                  v != null && v.length >= 6 ? null : 'Минимум 6 символов',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006EE9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Register',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '— Or Register with —',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}
