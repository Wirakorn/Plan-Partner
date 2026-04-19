import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <({String title, String body})>[
      (
        title: '1. Information We Collect',
        body:
            'Plan Partner stores account details that you provide (email and username), plus your tasks and task-related content such as title, description, due date, and completion status.',
      ),
      (
        title: '2. How We Use Information',
        body:
            'Your data is used only to provide app features such as registration, sign-in, task management, reminders, and personalized display within the app.',
      ),
      (
        title: '3. Storage and Security',
        body:
            'Data may be stored locally on your device and, on supported platforms, synchronized with configured cloud services. We recommend protecting your device with a passcode and keeping your app updated.',
      ),
      (
        title: '4. Data Sharing',
        body:
            'Plan Partner does not sell your personal data. Information is shared only with services required for core functionality (for example, backend or hosting providers used by this app).',
      ),
      (
        title: '5. Your Choices',
        body:
            'You can clear cache, delete local data, or log out from Settings at any time. If you stop using the app, you can uninstall it to remove locally stored data from your device.',
      ),
      (
        title: '6. Children\'s Privacy',
        body:
            'This app is not directed to children under the age required by your local regulations. If you believe a child has provided personal data, contact the app administrator to request removal.',
      ),
      (
        title: '7. Policy Updates',
        body:
            'We may update this policy from time to time. Material changes will be reflected in this page and effective date.',
      ),
      (
        title: '8. Contact',
        body:
            'For privacy questions, contact the Plan Partner team through the support channel listed in the store profile.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan Partner Privacy Policy',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Effective date: April 19, 2026'),
                  const SizedBox(height: 12),
                  const Text(
                    'This policy explains what data Plan Partner collects, how it is used, and your choices regarding your information.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...sections.map(
            (section) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(section.body),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
