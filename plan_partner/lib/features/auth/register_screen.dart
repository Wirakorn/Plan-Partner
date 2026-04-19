import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/brand_app_icon.dart';

const _isLoggedInKey = 'is_logged_in';
const _savedEmailKey = 'auth_email';
const _savedUsernameKey = 'auth_username';
const _savedPasswordKey = 'auth_password';
const _localTasksKey = 'plan_partner_tasks';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSubmitting = false;
  bool _hasAcceptedPrivacy = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_hasAcceptedPrivacy) {
      final accepted = await _showPrivacyConsentPopup();
      if (accepted != true || !mounted) return;
      setState(() => _hasAcceptedPrivacy = true);
    }

    setState(() => _isSubmitting = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_savedEmailKey, _emailController.text.trim());
      await prefs.setString(_savedUsernameKey, _usernameController.text.trim());
      await prefs.setString(_savedPasswordKey, _passwordController.text);
      await prefs.setBool(_isLoggedInKey, true);

      // Clear old task cache on new registration
      await prefs.remove(_localTasksKey);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful')));
      context.go('/home');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<bool?> _showPrivacyConsentPopup() {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Privacy Policy Consent'),
          content: const SingleChildScrollView(
            child: Text(
              'By creating an account, you agree that Plan Partner stores your account details and task data to provide app features. You can review, export, and delete your local data from Settings at any time.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
                context.push('/privacy');
              },
              child: const Text('View Full Policy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE9F8F5), Color(0xFFF7FBFA)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -48,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF4DB8A8).withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -70,
              left: -55,
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C9186).withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: BrandAppIcon(size: 74),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Create Account',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Fill in all fields to register.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.alternate_email_rounded,
                                  ),
                                ),
                                validator: (value) {
                                  final text = value?.trim() ?? '';
                                  if (text.isEmpty) return 'Please enter email';
                                  if (!text.contains('@') ||
                                      !text.contains('.')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.badge_outlined),
                                ),
                                validator: (value) {
                                  final text = value?.trim() ?? '';
                                  if (text.isEmpty) {
                                    return 'Please enter username';
                                  }
                                  if (text.length < 6) {
                                    return 'Username must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline_rounded),
                                ),
                                validator: (value) {
                                  final text = value ?? '';
                                  if (text.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (text.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Confirm Password',
                                  prefixIcon: Icon(
                                    Icons.verified_user_outlined,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Password does not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _hasAcceptedPrivacy,
                                    onChanged: (value) {
                                      setState(
                                        () => _hasAcceptedPrivacy =
                                            value ?? false,
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        const Text('I agree to the '),
                                        TextButton(
                                          onPressed: () =>
                                              context.push('/privacy'),
                                          child: const Text('Privacy Policy'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              OutlinedButton.icon(
                                onPressed: () => context.push('/privacy'),
                                icon: const Icon(Icons.privacy_tip_outlined),
                                label: const Text('Open Privacy Policy'),
                              ),
                              const SizedBox(height: 12),
                              FilledButton.icon(
                                onPressed: _isSubmitting ? null : _register,
                                icon: const Icon(
                                  Icons.app_registration_rounded,
                                ),
                                label: Text(
                                  _isSubmitting ? 'Registering...' : 'Register',
                                ),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton.icon(
                                onPressed: () => context.pop(),
                                icon: const Icon(Icons.arrow_back_rounded),
                                label: const Text('Back to Login'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
