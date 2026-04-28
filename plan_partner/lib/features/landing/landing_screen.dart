import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/brand_app_icon.dart';

class LandingScreen extends StatelessWidget {
  final bool isLoggedIn;

  const LandingScreen({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF071D1A),
                  Color(0xFF0B2E29),
                  Color(0xFF123F38),
                ],
                stops: [0.0, 0.52, 1.0],
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x6651D6C0), Color(0x0051D6C0)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -130,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x554FC3B2), Color(0x004FC3B2)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
                    child: _TopNavigation(isLoggedIn: isLoggedIn),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
                    child: _HeroSection(isLoggedIn: isLoggedIn),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                    child: _SectionCard(
                      title: 'App feature',
                      subtitle:
                          'Designed to keep your team focused and moving every day.',
                      child: const _FeatureGrid(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: _SectionCard(
                      title: 'App preview',
                      subtitle:
                          'Replace these polished placeholders with your real product screenshots.',
                      child: const _PreviewPlaceholders(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                    child: _SectionCard(
                      title: 'About app',
                      subtitle:
                          'A planning companion built for speed and clarity.',
                      child: const _AboutContent(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 26),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF136F63), Color(0xFF1E9F8F)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40136F63),
                            blurRadius: 18,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () =>
                            context.go(isLoggedIn ? '/home' : '/login'),
                        icon: const Icon(Icons.rocket_launch_outlined),
                        label: Text(
                          isLoggedIn ? 'Open App Dashboard' : 'Go to Web App',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopNavigation extends StatelessWidget {
  final bool isLoggedIn;

  const _TopNavigation({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Wrap(
          spacing: 6,
          children: [
            _NavLink(label: 'Features', onTap: () {}),
            _NavLink(label: 'Privacy', onTap: () => context.go('/privacy')),
            _NavLink(label: 'About', onTap: () {}),
            _NavLink(
              label: 'Download',
              onTap: () => context.go(isLoggedIn ? '/home' : '/login'),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFC9D8EE),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isLoggedIn;

  const _HeroSection({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final heroHeight = screenHeight * 0.74;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: heroHeight < 460 ? 460 : heroHeight,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BrandAppIcon(size: 112, elevated: false),
            const SizedBox(height: 26),
            Text(
              'Plan Partner',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: const Color(0xFF1BD68A),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Plan clearly. Work confidently.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF89EBD3),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Your tasks, priorities, and progress in one focused workspace',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF8CAFC7),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1BD66E),
                    foregroundColor: const Color(0xFF053528),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => context.go(isLoggedIn ? '/home' : '/login'),
                  icon: const Icon(Icons.public_outlined),
                  label: const Text('Get Started'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF5AAEA3)),
                    foregroundColor: const Color(0xFFCAF7EE),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => context.go('/register'),
                  icon: const Icon(Icons.app_registration_outlined),
                  label: const Text('Create account'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF7FFFD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFB8DBD3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF104E45),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.4,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        icon: Icons.checklist_rounded,
        title: 'Task tracking',
        pill: 'Daily to-do management',
        body:
            'Create, edit, complete, and delete tasks in seconds with a clean flow that keeps daily planning fast and consistent.',
      ),
      (
        icon: Icons.priority_high_rounded,
        title: 'Priority focus',
        pill: 'Deadline-aware planning',
        body:
            'Group work by priority and due date so you can lock on urgent tasks first and avoid last-minute chaos.',
      ),
      (
        icon: Icons.insights_outlined,
        title: 'Progress review',
        pill: 'Momentum snapshot',
        body:
            'Track completed versus pending items with simple metrics that instantly show your momentum each day.',
      ),
      (
        icon: Icons.chat_bubble_outline_rounded,
        title: 'Chat with AI',
        pill: 'Adaptive daily planning',
        body:
            'Chat with AI to adjust your daily plan in real time. It helps rebalance priorities, suggest practical next steps, and keep your schedule realistic for each day.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        const cardHeight = 258.0;
        final cardWidth = constraints.maxWidth >= 1100
            ? (constraints.maxWidth - (gap * 3)) / 4
            : 260.0;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(width: gap),
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FCFB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFCFE7E3)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x120B4C43),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F6F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            items[i].icon,
                            color: const Color(0xFF24796E),
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          items[i].title,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            items[i].body,
                            textAlign: TextAlign.start,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(height: 1.45),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F6F2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            items[i].pill,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A6A60),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PreviewPlaceholders extends StatelessWidget {
  const _PreviewPlaceholders();

  @override
  Widget build(BuildContext context) {
    const previewPaths = [
      'assets/images/preview_1.jpg',
      'assets/images/preview_2.jpg',
      'assets/images/preview_3.jpg',
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 600
            ? 2
            : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: previewPaths.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF9CCFC7),
                    style: BorderStyle.solid,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFFFFF), Color(0xFFEFFAF7)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x140F5A50),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      previewPaths[index],
                      fit: BoxFit.cover,
                      alignment: index == 2
                          ? Alignment.topCenter
                          : Alignment.center,
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Preview ${index + 1}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan Partner is a productivity app built for teams and individuals who want structure without complexity. You can register in seconds, add tasks, set priorities, and track everything in one clean dashboard.',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 10),
        Text(
          'The experience is designed for quick planning, focused execution, and smooth weekly review so you always know what is done and what comes next.',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
        ),
      ],
    );
  }
}
