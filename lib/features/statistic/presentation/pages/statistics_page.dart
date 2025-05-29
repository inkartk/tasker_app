import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/statistics_bloc.dart';
import '../bloc/statistics_state.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistic'),
        leading: IconButton(
            onPressed: () => context.go('/main?tab=2'),
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Center(
        child: BlocBuilder<StatisticsBloc, StatisticsState>(
          builder: (ctx, state) {
            if (state is StatisticsLoading) {
              return const CircularProgressIndicator();
            }
            if (state is StatisticsLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StatCard('Total Tasks', state.stats.totalTasks),
                  const SizedBox(height: 16),
                  _StatCard('Completed Tasks', state.stats.completedTasks),
                ],
              );
            }
            if (state is StatisticsError) {
              return Text('Error: ${state.message}');
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  const _StatCard(this.title, this.count);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            Text('$count',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
