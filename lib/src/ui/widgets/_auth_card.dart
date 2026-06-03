import 'package:flutter/material.dart';
import '../config/auth_color_scheme.dart';
import '../theme/auth_theme.dart';

/// Elevated card container that wraps form content on auth screens.
class AuthCard extends StatefulWidget {
  final Widget child;
  final AuthColorScheme colors;

  const AuthCard({
    super.key,
    required this.child,
    this.colors = const AuthColorScheme(),
  });

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: c.resolvedCardColor,
            borderRadius: BorderRadius.circular(AuthTheme.radiusLG),
            boxShadow: c.resolvedCardShadow,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
