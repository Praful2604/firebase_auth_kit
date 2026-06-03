import 'package:flutter/material.dart';
import '../core/auth_controller.dart';
import 'config/auth_ui_config.dart';
import 'theme/auth_theme.dart';
import 'widgets/_auth_header.dart';
import 'widgets/_email_password_form.dart';
import 'widgets/_otp_form.dart';
import 'widgets/_google_sign_in_panel.dart';

/// A pre-built signup screen rendered as a [Stack] so the background is
/// fully customisable.
///
/// ### Minimal usage
/// ```dart
/// AuthSignupScreen(
///   config: AuthUIConfig(enableEmailPassword: true),
///   onSuccess: () => Navigator.pushReplacementNamed(context, '/home'),
/// )
/// ```
///
/// ### Custom background + logo
/// ```dart
/// AuthSignupScreen(
///   config: AuthUIConfig(
///     enableEmailPassword: true,
///     backgroundColor: Colors.deepPurple,
///     headerBackground: BoxDecoration(color: Colors.transparent),
///     headerLogoWidget: Icon(Icons.person_add, color: Colors.white, size: 40),
///     headerTitleStyle: TextStyle(color: Colors.white, fontSize: 28,
///         fontWeight: FontWeight.bold),
///     showHeaderDecorations: false,
///   ),
///   onSuccess: () {},
/// )
/// ```
class AuthSignupScreen extends StatefulWidget {
  final AuthUIConfig config;
  final VoidCallback? onSuccess;

  /// Called when the user taps "Sign In" in the footer.
  /// If null, the footer link is hidden.
  final VoidCallback? onLoginTap;

  const AuthSignupScreen({
    super.key,
    this.config = const AuthUIConfig(),
    this.onSuccess,
    this.onLoginTap,
  });

  @override
  State<AuthSignupScreen> createState() => _AuthSignupScreenState();
}

class _AuthSignupScreenState extends State<AuthSignupScreen>
    with SingleTickerProviderStateMixin {
  final _controller = AuthController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    final count = widget.config.enabledMethods.length;
    if (count > 1) {
      _tabController = TabController(length: count, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final methods = widget.config.enabledMethods;

    if (methods.isEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'No sign-up method enabled.\nSet enableEmailPassword, enableGoogle,\nor enableOtp in AuthUIConfig.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    final cfg = widget.config;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Layer 0 : background ───────────────────────────────────
          if (cfg.backgroundWidget != null)
            cfg.backgroundWidget!
          else
            Container(decoration: cfg.resolveScreenDecoration()),

          // ── Layer 1 : auth content ─────────────────────────────────
          Column(
            children: [
              // Header
              AuthHeader(
                title: 'Create Account',
                subtitle: "Join us today",
                tabController: _tabController,
                tabs: methods.length > 1
                    ? methods.map(_tabLabel).toList()
                    : null,
                headerBackground: cfg.headerBackground,
                headerBackgroundWidget: cfg.headerBackgroundWidget,
                logoWidget: cfg.headerLogoWidget,
                titleStyle: cfg.headerTitleStyle,
                subtitleStyle: cfg.headerSubtitleStyle,
                showDecorations: cfg.showHeaderDecorations,
              ),

              // Form area
              Expanded(
                child: methods.length == 1
                    ? _buildSingleMethod(methods.first)
                    : TabBarView(
                        controller: _tabController,
                        children: methods.map(_buildSingleMethod).toList(),
                      ),
              ),

              // Footer
              _LoginFooter(config: cfg, onLoginTap: widget.onLoginTap),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleMethod(AuthMethod method) {
    switch (method) {
      case AuthMethod.emailPassword:
        return EmailPasswordForm(
          config: widget.config,
          controller: _controller,
          isLogin: false,
          onSuccess: widget.onSuccess,
        );
      case AuthMethod.otp:
        return OtpForm(
          config: widget.config,
          controller: _controller,
          onSuccess: widget.onSuccess,
        );
      case AuthMethod.google:
        return GoogleSignInPanel(
          config: widget.config,
          controller: _controller,
          onSuccess: widget.onSuccess,
        );
    }
  }

  Tab _tabLabel(AuthMethod method) {
    switch (method) {
      case AuthMethod.emailPassword:
        return const Tab(icon: Icon(Icons.email_outlined), text: 'Email');
      case AuthMethod.otp:
        return const Tab(icon: Icon(Icons.phone_outlined), text: 'Phone');
      case AuthMethod.google:
        return const Tab(icon: Icon(Icons.language_outlined), text: 'Google');
    }
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────

class _LoginFooter extends StatelessWidget {
  final AuthUIConfig config;
  final VoidCallback? onLoginTap;
  const _LoginFooter({required this.config, this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    if (onLoginTap == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 28, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account? ',
            style: TextStyle(fontSize: 14, color: AuthTheme.textSecondary),
          ),
          GestureDetector(
            onTap: onLoginTap,
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: AuthTheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
