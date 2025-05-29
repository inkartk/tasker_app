// lib/features/profile/presentation/pages/account_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/features/profile/bloc/cubit_profile.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  static const Color _primaryColor = Color(0xFF3366FF);
  static const Color _backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.profile == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = state.profile!;

        return Scaffold(
            backgroundColor: _primaryColor,
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: _primaryColor,
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(36)),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.displayName ?? 'User',
                                    style: const TextStyle(
                                      color: _primaryColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Профессия
                                  Text(
                                    profile.profession,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black54),
                                  ),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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

                          // Статистика выполненных задач

                          const SizedBox(height: 16),

                          _MenuItem(
                            icon: Icons.person,
                            title: 'My Profile',
                            onTap: () => context.push('/profile_page'),
                          ),
                          const Divider(height: 1, color: Colors.white),
                          _MenuItem(
                            icon: Icons.bar_chart,
                            title: 'Statistic',
                            onTap: () => context.go('/statistic'),
                          ),
                          const Divider(height: 1, color: Colors.white),
                          _MenuItem(
                            icon: Icons.settings,
                            title: 'Settings',
                            onTap: () => context.go('/settings'),
                          ),
                          const Divider(height: 1, color: Colors.white),
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
              ),
            ));
      },
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
      padding: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          icon,
          color: primary,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        onTap: onTap,
      ),
    );
  }
}
