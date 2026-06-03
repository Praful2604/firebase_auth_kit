import 'package:flutter/material.dart';
import '../core/auth_controller.dart';
import 'config/auth_ui_config.dart';
import 'theme/auth_theme.dart';
import 'widgets/_auth_header.dart';
import 'widgets/_email_password_form.dart';
import 'widgets/_otp_form.dart';
import 'widgets/_google_sign_in_panel.dart';

/// A pre-built login screen rendered as a [Stack] so the background is
/// fully customisable.
///
/// ### Minimal usage
/// ```dart
/// AuthLoginScreen(
///   config: AuthUIConfig(enableEmailPassword: true),
///   onSuccess: () => Navigator.pushReplacementNamed(context, '/home'),
/// )
/// ```
///
/// ### Custom background + logo
/// ```dart
/// AuthLoginScreen(
///   config: AuthUIConfig(
///     enableEmailPassword: true,
///     // Full-screen image background
///     backgroundImage: DecorationImage(
///       image: AssetImage('assets/bg.jpg'),
///       fit: BoxFit.cover,
///     ),
///     // Transparent header so it blends into the background
///     headerBackground: BoxDecoration(color: Colors.transparent),
///     // Your own logo instead of the lock icon
///     headerLogoWidget: Image.asset('assets/logo.png', width: 52),
///     // Custom title / subtitle colours
///     headerTitleStyle: TextStyle(color: Colors.white, fontSize: 28,
///         fontWeight: FontWeight.bold),
///     headerSubtitleStyle: TextStyle(color: Colors.white70),
///     // Hide the decorative circles
///     showHeaderDecorations: false,
///   ),
///   onSuccess: () {},
/// )
/// ```
class AuthLoginScreen extends StatefulWidget {
  final AuthUIConfig config;
  final VoidCallback? onSuccess;

  /// Called when the user taps "Sign Up" in the footer.
  /// If null, the footer link is hidden.
  final VoidCallback? onSignupTap;

  const AuthLoginScreen({
    super.key,
    this.config = const AuthUIConfig(),
    this.onSuccess,
    this.onSignupTap,
  });

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen>
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
              'No sign-in method enabled.\nSet enableEmailPassword, enableGoogle,\nor enableOtp in AuthUIConfig.',
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
          // Custom widget takes priority; otherwise use the decoration.
          if (cfg.backgroundWidget != null)
            cfg.backgroundWidget!
          else
            Container(decoration: cfg.resolveScreenDecoration()),

          // ── Layer 1 : auth content ─────────────────────────────────
          Column(
            children: [
              // Header
              AuthHeader(
                title: 'Welcome Back',
                subtitle: 'Sign in to continue',
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
              _SignupFooter(config: cfg, onSignupTap: widget.onSignupTap),
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
          isLogin: true,
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

class _SignupFooter extends StatelessWidget {
  final AuthUIConfig config;
  final VoidCallback? onSignupTap;
  const _SignupFooter({required this.config, this.onSignupTap});

  @override
  Widget build(BuildContext context) {
    if (onSignupTap == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 28, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(fontSize: 14, color: AuthTheme.textSecondary),
          ),
          GestureDetector(
            onTap: onSignupTap,
            child: const Text(
              'Sign Up',
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
