import 'package:flutter/material.dart';
import '../theme/auth_theme.dart';

/// Fully customisable header used by both login and signup screens.
///
/// ### Background
/// Supply [headerBackground] (a [Decoration]) or [headerBackgroundWidget]
/// (an arbitrary widget) to replace the default blue gradient.
/// Pass `BoxDecoration(color: Colors.transparent)` to make the header
/// invisible so it blends into a full-screen custom background.
///
/// ### Logo / icon
/// Supply [logoWidget] to replace the default lock icon with anything —
/// an [Image], a [FlutterLogo], or a custom painter.
///
/// ### Typography
/// Override [titleStyle] and [subtitleStyle] to match your brand.
///
/// ### Decorative circles
/// Set [showDecorations] to `false` to remove the subtle circle overlays.
class AuthHeader extends StatefulWidget {
  final String title;
  final String subtitle;
  final TabController? tabController;
  final List<Tab>? tabs;

  /// Decoration applied to the header container.
  /// Defaults to [AuthTheme.headerGradient] (blue gradient) when `null`.
  final Decoration? headerBackground;

  /// Widget drawn as the background layer of the header.
  /// When provided, [headerBackground] is ignored.
  final Widget? headerBackgroundWidget;

  /// Widget shown in place of the default lock icon.
  final Widget? logoWidget;

  /// Text style for [title]. Defaults to [AuthTheme.displayLarge].
  final TextStyle? titleStyle;

  /// Text style for [subtitle]. Defaults to [AuthTheme.subtitle].
  final TextStyle? subtitleStyle;

  /// Whether to render the decorative circle overlays. Defaults to `true`.
  final bool showDecorations;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.tabController,
    this.tabs,
    this.headerBackground,
    this.headerBackgroundWidget,
    this.logoWidget,
    this.titleStyle,
    this.subtitleStyle,
    this.showDecorations = true,
  });

  @override
  State<AuthHeader> createState() => _AuthHeaderState();
}

class _AuthHeaderState extends State<AuthHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasTabs =
        widget.tabs != null &&
        widget.tabs!.isNotEmpty &&
        widget.tabController != null;

    // Resolve the decoration: user-supplied → default blue gradient
    final decoration = widget.headerBackground ??
        const BoxDecoration(
          gradient: AuthTheme.headerGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(AuthTheme.radiusXL),
            bottomRight: Radius.circular(AuthTheme.radiusXL),
          ),
        );

    return Container(
      width: double.infinity,
      decoration: widget.headerBackgroundWidget == null ? decoration : null,
      child: Stack(
        children: [
          // ── Custom background widget (optional) ────────────────────
          if (widget.headerBackgroundWidget != null)
            Positioned.fill(child: widget.headerBackgroundWidget!),

          // ── Decorative circles (can be hidden) ─────────────────────
          if (widget.showDecorations) ...[
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: hasTabs ? 48 : 16,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
          ],

          // ── Content ────────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 28, 24, hasTabs ? 4 : 32),
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideIn,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo — custom widget or default lock icon
                      widget.logoWidget ??
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(
                                  AuthTheme.radiusMD),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.lock_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                      const SizedBox(height: 20),

                      // Title
                      Text(
                        widget.title,
                        style:
                            widget.titleStyle ?? AuthTheme.displayLarge,
                      ),
                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        widget.subtitle,
                        style: widget.subtitleStyle ?? AuthTheme.subtitle,
                      ),

                      // Tabs
                      if (hasTabs) ...[
                        const SizedBox(height: 24),
                        _StyledTabBar(
                          controller: widget.tabController!,
                          tabs: widget.tabs!,
                        ),
                      ] else
                        const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom pill-style tab bar ─────────────────────────────────────────────────

class _StyledTabBar extends StatelessWidget {
  final TabController controller;
  final List<Tab> tabs;

  const _StyledTabBar({required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final iconOnlyTabs = tabs.map((t) {
      return Tab(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (t.icon != null)
              IconTheme(
                data: const IconThemeData(size: 16),
                child: t.icon!,
              ),
            if (t.text != null) ...[
              const SizedBox(width: 5),
              Text(t.text!),
            ],
          ],
        ),
      );
    }).toList();

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AuthTheme.radiusSM),
      ),
      child: TabBar(
        controller: controller,
        tabs: iconOnlyTabs,
        indicator: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(AuthTheme.radiusSM - 2),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.55),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.2,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        padding: const EdgeInsets.all(4),
      ),
    );
  }
}
