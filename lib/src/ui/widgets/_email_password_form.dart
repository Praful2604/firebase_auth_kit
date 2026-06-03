import 'package:flutter/material.dart';
import '../../core/auth_controller.dart';
import '../../utils/validators.dart';
import '../config/auth_color_scheme.dart';
import '../config/auth_ui_config.dart';
import '../theme/auth_theme.dart';
import '_auth_card.dart';
import '_auth_text_field.dart';
import '_auth_button.dart';

/// Email + password form used in both login and signup screens.
class EmailPasswordForm extends StatefulWidget {
  final AuthUIConfig config;
  final AuthController controller;
  final bool isLogin;
  final VoidCallback? onSuccess;

  const EmailPasswordForm({
    super.key,
    required this.config,
    required this.controller,
    required this.isLogin,
    this.onSuccess,
  });

  @override
  State<EmailPasswordForm> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (widget.isLogin) {
        await widget.controller.login(email: _email, password: _password);
      } else {
        await widget.controller.signUp(
          name: _name,
          email: _email,
          password: _password,
        );
      }
      widget.onSuccess?.call();
    } catch (e) {
      setState(() => _error = _friendly(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendly(Object e) {
    final msg = e.toString();
    if (msg.contains('user-not-found')) return 'No account found for this email.';
    if (msg.contains('wrong-password')) return 'Incorrect password.';
    if (msg.contains('invalid-email')) return 'Invalid email address.';
    if (msg.contains('email-already-in-use')) return 'An account already exists for this email.';
    if (msg.contains('weak-password')) return 'Password is too weak.';
    if (msg.contains('too-many-requests')) return 'Too many attempts. Try again later.';
    if (msg.contains('network-request-failed')) return 'Network error. Check your connection.';
    return 'Something went wrong. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final cfg = widget.config;
    final colors = cfg.colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AuthCard(
        colors: colors,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Section label ──────────────────────────────────────
              _SectionLabel(
                icon: Icons.email_outlined,
                text: widget.isLogin ? 'Sign in with email' : 'Create your account',
                colors: colors,
              ),
              const SizedBox(height: 20),

              // ── Name (signup only) ─────────────────────────────────
              if (!widget.isLogin) ...[
                cfg.nameField ??
                    AuthTextField(
                      label: 'Full Name',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: cfg.nameValidator ?? AuthValidators.name,
                      onChanged: (v) => _name = v,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      colors: colors,
                    ),
                const SizedBox(height: 14),
              ],

              // ── Email ──────────────────────────────────────────────
              cfg.emailField ??
                  AuthTextField(
                    label: 'Email address',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: cfg.emailValidator ?? AuthValidators.email,
                    onChanged: (v) => _email = v,
                    textInputAction: TextInputAction.next,
                    colors: colors,
                  ),
              const SizedBox(height: 14),

              // ── Password ───────────────────────────────────────────
              cfg.passwordField ??
                  AuthTextField(
                    label: 'Password',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: true,
                    validator: cfg.passwordValidator ?? AuthValidators.password,
                    onChanged: (v) => _password = v,
                    textInputAction: widget.isLogin
                        ? TextInputAction.done
                        : TextInputAction.next,
                    colors: colors,
                  ),

              // ── Confirm password (signup only) ─────────────────────
              if (!widget.isLogin) ...[
                const SizedBox(height: 14),
                AuthTextField(
                  label: 'Confirm Password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  validator: (v) => AuthValidators.confirmPassword(v, _password),
                  textInputAction: TextInputAction.done,
                  colors: colors,
                ),
              ],

              // ── Forgot password (login only) ───────────────────────
              if (widget.isLogin) ...[
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: colors.resolvedLink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // ── Error banner ───────────────────────────────────────
              if (_error != null) ...[
                AuthErrorBanner(message: _error!, colors: colors),
                const SizedBox(height: 16),
              ],

              // ── Submit button ──────────────────────────────────────
              cfg.loginButton != null && widget.isLogin
                  ? cfg.loginButton!
                  : cfg.signupButton != null && !widget.isLogin
                      ? cfg.signupButton!
                      : AuthButton(
                          label: widget.isLogin ? 'Sign In' : 'Create Account',
                          loading: _loading,
                          onPressed: _submit,
                          colors: colors,
                        ),

              // ── Password strength hint (signup only) ───────────────
              if (!widget.isLogin) ...[
                const SizedBox(height: 16),
                _PasswordStrengthHint(password: _password, colors: colors),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String text;
  final AuthColorScheme colors;

  const _SectionLabel({
    required this.icon,
    required this.text,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colors.resolvedPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AuthTheme.radiusXS),
          ),
          child: Icon(icon, size: 16, color: colors.resolvedPrimary),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: colors.resolvedTextPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Password strength hint ────────────────────────────────────────────────────

class _PasswordStrengthHint extends StatelessWidget {
  final String password;
  final AuthColorScheme colors;

  const _PasswordStrengthHint({
    required this.password,
    required this.colors,
  });

  int get _strength {
    if (password.isEmpty) return 0;
    int s = 0;
    if (password.length >= 8) s++;
    if (password.contains(RegExp(r'[A-Z]'))) s++;
    if (password.contains(RegExp(r'[0-9]'))) s++;
    if (password.contains(RegExp(r'[!@#\$%^&*]'))) s++;
    return s;
  }

  Color get _color {
    switch (_strength) {
      case 1: return const Color(0xFFEF4444);
      case 2: return const Color(0xFFF59E0B);
      case 3: return const Color(0xFF3B82F6);
      case 4: return const Color(0xFF10B981);
      default: return AuthTheme.inputBorder;
    }
  }

  String get _label {
    switch (_strength) {
      case 1: return 'Weak';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Strong';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  color: i < _strength ? _color : colors.resolvedInputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        if (_label.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            'Password strength: $_label',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _color,
            ),
          ),
        ],
      ],
    );
  }
}
