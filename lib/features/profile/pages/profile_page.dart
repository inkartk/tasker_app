// lib/features/profile/presentation/pages/profile_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_the_best_project/features/profile/bloc/cubit_profile.dart';
import 'package:my_the_best_project/features/profile/data/model.dart';

/// Обёртка, которая ждёт, пока [ProfileCubit] подгрузит профиль,
/// и переключается с индикатора на форму.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ProfileForm(profile: state.profile!);
        },
      ),
    );
  }
}

/// Форма редактирования профиля.
/// Здесь безопасно брать данные из [widget.profile] и инициализировать контроллеры.
class ProfileForm extends StatefulWidget {
  final UserProfile profile;
  const ProfileForm({super.key, required this.profile});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _profCtrl;
  late final TextEditingController _birthCtrl;
  // late DateTime _birth;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.name);
    _profCtrl = TextEditingController(text: widget.profile.profession);
    _birthCtrl = TextEditingController(
      text: DateFormat('dd.MM.yyyy').format(widget.profile.birthDate),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _profCtrl.dispose();
    _birthCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: widget.profile.birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      _birthCtrl.text = DateFormat('dd.MM.yyyy').format(d);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final state = context.watch<ProfileCubit>().state;
    final profile = state.profile!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Имя
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),

          // Профессия
          TextField(
            controller: _profCtrl,
            decoration: const InputDecoration(labelText: 'Profession'),
          ),
          const SizedBox(height: 12),

          // Дата рождения
          TextField(
            controller: _birthCtrl,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: _pickDate,
          ),
          const SizedBox(height: 12),

          // Email (только просмотр)
          TextField(
            enabled: false,
            decoration: InputDecoration(
              labelText: user?.email ?? 'Нет email',
              hintText: profile.email,
            ),
          ),

          const Spacer(),

          // Кнопка Save
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.loading
                  ? null
                  : () async {
                      final parsed =
                          DateFormat('dd.MM.yyyy').parse(_birthCtrl.text);
                      await context.read<ProfileCubit>().saveChanges(
                            name: _nameCtrl.text,
                            profession: _profCtrl.text,
                            birthDate: parsed, // теперь это DateTime
                          );
                      context.go('/main?tab=2');
                    },
              child: state.loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
