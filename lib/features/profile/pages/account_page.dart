// lib/features/profile/presentation/pages/account_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_the_best_project/features/profile/bloc/cubit_profile.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const Color _primaryColor = Color(0xFF3366FF);
  static const Color _backgroundColor = Color(0xFFF2F4F7);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final p = state.profile!;
          const double headerHeight = 100;
          const double avatarRadius = 50;

          return Column(
            children: [
              Container(
                height: headerHeight,
                decoration: const BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 2) Белая карточка
              Positioned(
                top: headerHeight - avatarRadius,
                left: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(
                    top: avatarRadius + 16,
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    children: [
                      Text(
                        user?.displayName ?? 'User',
                        style: const TextStyle(
                          color: _primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Профессия
                      Text(
                        p.profession,
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Дата рождения
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cake,
                              size: 20, color: _primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd.MM.yyyy').format(p.birthDate),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Локация и задачи
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 20, color: _primaryColor),
                              SizedBox(width: 4),
                              Text(
                                'Malang, Indonesia',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Container(
                              width: 1, height: 24, color: Colors.grey[200]),
                          const Row(
                            children: [
                              Icon(Icons.work_outline,
                                  size: 20, color: _primaryColor),
                              SizedBox(width: 4),
                              Text(
                                '2653 Task Completed',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 3) Аватар

              // 4) Меню
              Positioned(
                top: headerHeight + avatarRadius + 16,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const Divider(height: 1, color: Colors.grey),
                      _MenuItem(
                        icon: Icons.bar_chart,
                        title: 'Statistic',
                        onTap: () => context.go('/statistic'),
                      ),
                      const Divider(height: 1, color: Colors.grey),
                      _MenuItem(
                        icon: Icons.person,
                        title: 'Edit Profile',
                        onTap: () => context.push('/profile_page'),
                      ),
                      const Divider(height: 1, color: Colors.grey),
                      _MenuItem(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () => context.go('/settings'),
                      ),
                      const Divider(height: 1, color: Colors.grey),
                      _MenuItem(
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          context.go('/');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _MenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primary = Color(0xFF3366FF);
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: primary),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        onTap: onTap,
      ),
    );
  }
}
