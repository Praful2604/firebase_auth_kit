import 'package:flutter/material.dart';
import '../config/auth_color_scheme.dart';
import '../theme/auth_theme.dart';

/// Primary gradient CTA button used in auth forms.
class AuthButton extends StatefulWidget {
  final String label;
  final bool loading;
  final VoidCallback? onPressed;
  final AuthColorScheme colors;

  const AuthButton({
    super.key,
    required this.label,
    this.loading = false,
    this.onPressed,
    this.colors = const AuthColorScheme(),
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton>
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
        child: AnimatedOpacity(
          opacity: enabled ? 1.0 : 0.65,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              gradient: enabled
                  ? c.resolvedButtonGradient
                  : const LinearGradient(
                      colors: [Color(0xFF9CA3AF), Color(0xFF9CA3AF)],
                    ),
              borderRadius: BorderRadius.circular(AuthTheme.radiusMD),
              boxShadow: enabled ? c.resolvedButtonShadow : [],
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
                          color: c.resolvedButtonTextColor,
                        ),
                      )
                    : Text(
                        widget.label,
                        key: const ValueKey('label'),
                        style: AuthTheme.buttonText.copyWith(
                          color: c.resolvedButtonTextColor,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Error banner ──────────────────────────────────────────────────────────────

class AuthErrorBanner extends StatelessWidget {
  final String message;
  final AuthColorScheme colors;

  const AuthErrorBanner({
    super.key,
    required this.message,
    this.colors = const AuthColorScheme(),
  });

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * -8),
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: c.resolvedErrorContainer,
          borderRadius: BorderRadius.circular(AuthTheme.radiusSM),
          border: Border.all(
            color: c.resolvedError.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: c.resolvedError.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: c.resolvedError,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: c.resolvedError,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Divider with label ────────────────────────────────────────────────────────

class AuthDivider extends StatelessWidget {
  final String label;
  final AuthColorScheme colors;

  const AuthDivider({
    super.key,
    this.label = 'or',
    this.colors = const AuthColorScheme(),
  });

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return Row(
      children: [
        Expanded(child: Divider(color: c.resolvedInputBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c.resolvedTextHint,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: c.resolvedInputBorder)),
      ],
    );
  }
}
