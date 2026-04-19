import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/providers/task_provider.dart';
import '../../core/providers/user_provider.dart';
import '../../core/utils/task_query.dart';
import '../../widgets/brand_app_icon.dart';
import '../../widgets/task_list.dart';

class _MockWeather {
  final String label;
  final String condition;
  final int tempC;

  const _MockWeather({
    required this.label,
    required this.condition,
    required this.tempC,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _chatBadgeCount = 1;

  static const List<_QuickAction> _quickActions = [
    _QuickAction(
      title: 'Today',
      subtitle: 'Focus on what matters now',
      icon: Icons.today_rounded,
    ),
    _QuickAction(
      title: 'Upcoming',
      subtitle: 'See what is coming next',
      icon: Icons.event_note_rounded,
    ),
    _QuickAction(
      title: 'AI Chat',
      subtitle: 'Open the chat preview',
      icon: Icons.chat_bubble_outline_rounded,
    ),
  ];

  static const List<_MockWeather> _weatherData = [
    _MockWeather(label: 'Now', condition: 'Cloudy', tempC: 30),
    _MockWeather(label: '14:00', condition: 'Light Rain', tempC: 29),
    _MockWeather(label: '18:00', condition: 'Partly Cloudy', tempC: 28),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static void _showWeatherPopup(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
        title: const Text('Weather'),
        content: SizedBox(
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _weatherData
                .map(
                  (w) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.cloud_outlined, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text('${w.label} • ${w.condition}')),
                        Text('${w.tempC}°C'),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _openChat() async {
    await context.push('/chat');
    if (!mounted) return;
    setState(() {
      _chatBadgeCount = 0;
    });
  }

  Future<void> _confirmDeleteTask(String taskId) async {
    final taskProvider = context.read<TaskProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete task?'),
        content: const Text('This task will be removed permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await taskProvider.deleteTask(taskId);
    if (!mounted) return;
    messenger.showSnackBar(const SnackBar(content: Text('Task deleted')));
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final userName = context.watch<UserProvider>().user?.name.trim();
    final displayName = (userName == null || userName.isEmpty)
        ? 'Planner'
        : userName;
    final tasks = taskProvider.tasks;
    final filteredTasks = searchTasks(tasks, _searchQuery);
    final todayTasks = filterTodayTasks(filteredTasks);
    final upcomingTasks = filterUpcomingTasks(filteredTasks);
    final completedTasks = filterCompletedTasks(filteredTasks);
    final dueSoonTasksList = tasksDueSoon(filteredTasks);

    final totalCount = tasks.length;
    final completedCount = tasks.where((task) => task.isCompleted).length;
    final remainingCount = totalCount - completedCount;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFE9F7F4),
                child: Icon(
                  Icons.person_rounded,
                  color: Color(0xFF24796E),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Settings',
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: -40,
              right: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF4DB8A8).withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 110,
              left: -55,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E8F84).withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2E8F84), Color(0xFF5CB7AA)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF24796E).withValues(alpha: 0.14),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const BrandAppIcon(size: 60, elevated: false),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your day, organized',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Track tasks, priorities, and reminders in one place.',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.88,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _StatPill(
                              label: 'Total',
                              value: '$totalCount',
                              icon: Icons.grid_view_rounded,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatPill(
                              label: 'Done',
                              value: '$completedCount',
                              icon: Icons.check_circle_rounded,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatPill(
                              label: 'Left',
                              value: '$remainingCount',
                              icon: Icons.timelapse_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() => _searchQuery = value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Search tasks',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _searchQuery.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                    icon: const Icon(Icons.clear_rounded),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filledTonal(
                        onPressed: _openChat,
                        icon: Badge(
                          isLabelVisible: _chatBadgeCount > 0,
                          label: Text(
                            _chatBadgeCount > 9 ? '9+' : '$_chatBadgeCount',
                          ),
                          child: const Icon(Icons.smart_toy_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _quickActions.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final action = _quickActions[index];
                        return _QuickActionCard(
                          action: action,
                          onTap: () {
                            if (action.title == 'AI Chat') {
                              _openChat();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (dueSoonTasksList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Card(
                      color: const Color(0xFFFFF8EF),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFF0A23B),
                          child: Icon(
                            Icons.notifications_active_outlined,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          '${dueSoonTasksList.length} task(s) due soon',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          dueSoonTasksList
                              .take(3)
                              .map((task) => task.title)
                              .join(', '),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: TabBarView(
                    children: [
                      TaskList(
                        tasks: todayTasks,
                        onComplete: (taskId) =>
                            taskProvider.toggleComplete(taskId),
                        onEdit: (taskId) => context.push('/entry/$taskId'),
                        onDelete: _confirmDeleteTask,
                      ),
                      TaskList(
                        tasks: upcomingTasks,
                        onComplete: (taskId) =>
                            taskProvider.toggleComplete(taskId),
                        onEdit: (taskId) => context.push('/entry/$taskId'),
                        onDelete: _confirmDeleteTask,
                      ),
                      TaskList(
                        tasks: completedTasks,
                        onComplete: (taskId) =>
                            taskProvider.toggleComplete(taskId),
                        onEdit: (taskId) => context.push('/entry/$taskId'),
                        onDelete: _confirmDeleteTask,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.small(
              heroTag: 'weatherFab',
              onPressed: () => _showWeatherPopup(context),
              child: const Icon(Icons.cloud_outlined),
            ),
            const SizedBox(width: 12),
            Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton(
                  heroTag: 'chatFab',
                  onPressed: _openChat,
                  backgroundColor: const Color(0xFF24796E),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.chat_bubble_outline_rounded),
                ),
                if (_chatBadgeCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      height: 20,
                      constraints: const BoxConstraints(minWidth: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE44E5D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _chatBadgeCount > 9 ? '9+' : '$_chatBadgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            FloatingActionButton(
              heroTag: 'addTaskFab',
              onPressed: () => context.push('/entry'),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final String title;
  final String subtitle;
  final IconData icon;

  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;
  final VoidCallback onTap;

  const _QuickActionCard({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFEAF8F5),
                  child: Icon(action.icon, color: const Color(0xFF24796E)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        action.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        action.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
