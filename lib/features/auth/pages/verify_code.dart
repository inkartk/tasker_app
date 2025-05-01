import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/gen/assets.gen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCodePage extends StatefulWidget {
  final String email, password, displayName;
  const VerifyCodePage({
    super.key,
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final TextEditingController _ctrl = TextEditingController();
  String? _error;

  Future<void> _checkCode() async {
    final doc = await FirebaseFirestore.instance
        .collection('email_verifications')
        .doc(widget.email)
        .get();

    if (!doc.exists) {
      setState(() => _error = 'Код не найден');
      return;
    }

    final data = doc.data()!;
    final sentCode = data['code'] as String;
    final ts = (data['timestamp'] as Timestamp?)?.toDate();
    final now = DateTime.now();

    if (ts == null || now.difference(ts) > const Duration(minutes: 1)) {
      await doc.reference.delete();

      // Сгенерировать новый код
      final newCode =
          (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();

      await FirebaseFirestore.instance
          .collection('email_verifications')
          .doc(widget.email)
          .set({
        'code': newCode,
        'name': widget.displayName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _error = 'Код устарел. Мы отправили новый.';
        _ctrl.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Код устарел. Новый код отправлен на почту.'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      return;
    }

    if (_ctrl.text.trim() != sentCode) {
      setState(() => _error = 'Неверный код');
      return;
    }

    final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: widget.email,
      password: widget.password,
    );

    await userCred.user!.updateDisplayName(widget.displayName);
    await doc.reference.delete();

    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'TASK-WAN',
              style: TextStyle(
                fontSize: 28,
                color: Color(0xFF006EE9),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Management App',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              'Verify Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Image(
              image: Assets.images.bro.image().image,
              height: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              'Please enter the verification number\nwe sent to your email',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            PinCodeTextField(
              appContext: context,
              controller: _ctrl,
              length: 6,
              keyboardType: TextInputType.number,
              autoFocus: true,
              animationType: AnimationType.fade,
              enableActiveFill: true,
              onChanged: (value) {
                if (_error != null) setState(() => _error = null);
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 55,
                fieldWidth: 45,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveColor: Colors.blueAccent,
                selectedColor: Colors.blueAccent,
                activeColor: Colors.blueAccent,
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // TODO: Resend logic
              },
              child: const Text.rich(
                TextSpan(
                  text: "Don't receive a code? ",
                  children: [
                    TextSpan(
                      text: 'Resend',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _checkCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006EE9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confiirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
