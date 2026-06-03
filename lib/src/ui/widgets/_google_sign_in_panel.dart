import 'package:flutter/material.dart';
import '../../core/auth_controller.dart';
import '../config/auth_color_scheme.dart';
import '../config/auth_ui_config.dart';
import '../theme/auth_theme.dart';
import '_auth_card.dart';
import '_auth_button.dart';

/// Google sign-in panel used in both login and signup screens.
class GoogleSignInPanel extends StatefulWidget {
  final AuthUIConfig config;
  final AuthController controller;
  final VoidCallback? onSuccess;

  const GoogleSignInPanel({
    super.key,
    required this.config,
    required this.controller,
    this.onSuccess,
  });

  @override
  State<GoogleSignInPanel> createState() => _GoogleSignInPanelState();
}

class _GoogleSignInPanelState extends State<GoogleSignInPanel> {
  bool _loading = false;
  String? _error;

  Future<void> _signIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.controller.loginWithGoogle();
      widget.onSuccess?.call();
    } catch (e) {
      setState(() => _error = _friendly(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendly(Object e) {
    final msg = e.toString();
    if (msg.contains('network-request-failed')) {
      return 'Network error. Check your connection.';
    }
    if (msg.contains('sign_in_canceled')) return 'Sign-in was cancelled.';
    return 'Google sign-in failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AuthCard(
        colors: widget.config.colorScheme,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Illustration ───────────────────────────────────────
            Center(
              child: _GoogleIllustration(colors: widget.config.colorScheme),
            ),
            const SizedBox(height: 24),

            // ── Copy ───────────────────────────────────────────────
            Text(
              'Continue with Google',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: widget.config.colorScheme.resolvedTextPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in quickly and securely using\nyour Google account.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: widget.config.colorScheme.resolvedTextSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),

            // ── Error ──────────────────────────────────────────────
            if (_error != null) ...[
              AuthErrorBanner(
                  message: _error!, colors: widget.config.colorScheme),
              const SizedBox(height: 16),
            ],

            // ── Button ─────────────────────────────────────────────
            widget.config.googleButton ??
                _GoogleButton(
                    loading: _loading,
                    onPressed: _signIn,
                    colors: widget.config.colorScheme),

            const SizedBox(height: 16),

            // ── Trust badges ───────────────────────────────────────
            _TrustRow(colors: widget.config.colorScheme),
          ],
        ),
      ),
    );
  }
}

// ── Google illustration ───────────────────────────────────────────────────────

class _GoogleIllustration extends StatelessWidget {
  final AuthColorScheme colors;
  const _GoogleIllustration({required this.colors});

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: c.resolvedInputFill,
        shape: BoxShape.circle,
        border: Border.all(color: c.resolvedInputBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: c.resolvedPrimary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Center(child: _GoogleLogo(size: 40)),
    );
  }
}

// ── Google branded button ─────────────────────────────────────────────────────

class _GoogleButton extends StatefulWidget {
  final bool loading;
  final VoidCallback? onPressed;
  final AuthColorScheme colors;

  const _GoogleButton({
    required this.loading,
    required this.colors,
    this.onPressed,
  });

  @override
  State<_GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<_GoogleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
      lowerBound: 0,
      upperBound: 1,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _press, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    final enabled = !widget.loading && widget.onPressed != null;

    return GestureDetector(
      onTapDown: enabled ? (_) => _press.forward() : null,
      onTapUp: enabled
          ? (_) {
              _press.reverse();
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => _press.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: c.resolvedCardColor,
            borderRadius: BorderRadius.circular(AuthTheme.radiusMD),
            border: Border.all(color: c.resolvedInputBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: widget.loading
                  ? SizedBox(
                      key: const ValueKey('loader'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: c.resolvedPrimary,
                      ),
                    )
                  : Row(
                      key: const ValueKey('label'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _GoogleLogo(size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: c.resolvedTextPrimary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Trust row ─────────────────────────────────────────────────────────────────

class _TrustRow extends StatelessWidget {
  final AuthColorScheme colors;
  const _TrustRow({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shield_outlined, size: 14, color: colors.resolvedTextHint),
        const SizedBox(width: 4),
        Text(
          'Secured by Google OAuth 2.0',
          style: TextStyle(
            fontSize: 12,
            color: colors.resolvedTextHint,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Minimal Google "G" logo drawn with Canvas ─────────────────────────────────

class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    final sw = size.width * 0.18;

    void arc(double start, double sweep, Color color) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        start,
        sweep,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = sw
          ..strokeCap = StrokeCap.round,
      );
    }

    arc(-1.57, 1.57, const Color(0xFF4285F4)); // blue
    arc(3.14, 1.05, const Color(0xFFEA4335));  // red
    arc(4.19, 0.52, const Color(0xFFFBBC05));  // yellow
    arc(4.71, 0.52, const Color(0xFF34A853));  // green

    // Horizontal bar
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r, cy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = sw
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
