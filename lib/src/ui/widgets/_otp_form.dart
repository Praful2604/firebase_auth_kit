import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/auth_controller.dart';
import '../config/auth_color_scheme.dart';
import '../config/auth_ui_config.dart';
import '../theme/auth_theme.dart';
import '_auth_card.dart';
import '_auth_text_field.dart';
import '_auth_button.dart';

/// Phone OTP form used in both login and signup screens.
///
/// Design highlights:
/// - Animated step transition (phone → OTP entry)
/// - 6-box OTP input with auto-advance
/// - Resend countdown timer
class OtpForm extends StatefulWidget {
  final AuthUIConfig config;
  final AuthController controller;
  final VoidCallback? onSuccess;

  const OtpForm({
    super.key,
    required this.config,
    required this.controller,
    this.onSuccess,
  });

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> with TickerProviderStateMixin {
  String _phone = '';
  String _otp = '';
  String _verificationId = '';
  bool _otpSent = false;
  bool _loading = false;
  String? _error;

  // Resend countdown
  int _resendSeconds = 0;

  late final AnimationController _stepAnim;
  late final Animation<double> _stepFade;
  late final Animation<Offset> _stepSlide;

  @override
  void initState() {
    super.initState();
    _stepAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _stepFade = CurvedAnimation(parent: _stepAnim, curve: Curves.easeOut);
    _stepSlide = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _stepAnim, curve: Curves.easeOutCubic));
    _stepAnim.forward();
  }

  @override
  void dispose() {
    _stepAnim.dispose();
    super.dispose();
  }

  void _animateStep(VoidCallback change) {
    _stepAnim.reverse().then((_) {
      if (mounted) {
        setState(change);
        _stepAnim.forward();
      }
    });
  }

  Future<void> _sendOtp() async {
    if (_phone.trim().isEmpty) {
      setState(() => _error = 'Enter a phone number.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.controller.sendOTP(
        phone: _phone.trim(),
        onCodeSent: (id) {
          if (mounted) {
            _animateStep(() {
              _verificationId = id;
              _otpSent = true;
              _resendSeconds = 30;
            });
            _startResendTimer();
          }
        },
      );
    } catch (e) {
      setState(() => _error = _friendly(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_otp.trim().length < 6) {
      setState(() => _error = 'Enter the complete 6-digit OTP.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.controller.verifyOTP(
        verificationId: _verificationId,
        code: _otp.trim(),
      );
      widget.onSuccess?.call();
    } catch (e) {
      setState(() => _error = _friendly(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _startResendTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendSeconds--);
      return _resendSeconds > 0;
    });
  }

  String _friendly(Object e) {
    final msg = e.toString();
    if (msg.contains('invalid-phone-number')) {
      return 'Invalid phone number format. Use +[country code][number].';
    }
    if (msg.contains('too-many-requests')) {
      return 'Too many attempts. Try again later.';
    }
    if (msg.contains('invalid-verification-code')) {
      return 'Incorrect OTP. Please try again.';
    }
    if (msg.contains('network-request-failed')) {
      return 'Network error. Check your connection.';
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    final colors = c.colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AuthCard(
        colors: colors,
        child: FadeTransition(
          opacity: _stepFade,
          child: SlideTransition(
            position: _stepSlide,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Icon ──────────────────────────────────────────
                Center(child: _PhoneIcon(sent: _otpSent, colors: colors)),
                const SizedBox(height: 20),

                // ── Heading ───────────────────────────────────────
                Text(
                  _otpSent ? 'Enter the OTP' : 'Phone Verification',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AuthTheme.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _otpSent
                      ? 'We sent a 6-digit code to\n$_phone'
                      : 'Enter your phone number to receive\na one-time verification code.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AuthTheme.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),

                if (!_otpSent) ...[
                  // ── Phone input ────────────────────────────────
                  c.phoneField ??
                      AuthTextField(
                        label: 'Phone number (e.g. +1 234 567 8900)',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        onChanged: (v) => _phone = v,
                        textInputAction: TextInputAction.done,
                        colors: colors,
                      ),
                  const SizedBox(height: 20),

                  if (_error != null) ...[
                    AuthErrorBanner(message: _error!, colors: colors),
                    const SizedBox(height: 16),
                  ],

                  c.sendOtpButton ??
                      AuthButton(
                        label: 'Send OTP',
                        loading: _loading,
                        onPressed: _sendOtp,
                        colors: colors,
                      ),
                ] else ...[
                  // ── OTP boxes ──────────────────────────────────
                  c.otpField != null
                      ? c.otpField!
                      : _OtpBoxes(
                          onCompleted: (v) => setState(() => _otp = v),
                          colors: colors,
                        ),
                  const SizedBox(height: 20),

                  if (_error != null) ...[
                    AuthErrorBanner(message: _error!, colors: colors),
                    const SizedBox(height: 16),
                  ],

                  c.verifyOtpButton ??
                      AuthButton(
                        label: 'Verify OTP',
                        loading: _loading,
                        onPressed: _verifyOtp,
                        colors: colors,
                      ),
                  const SizedBox(height: 16),

                  // ── Resend ─────────────────────────────────────
                  Center(
                    child: _resendSeconds > 0
                        ? Text(
                            'Resend code in ${_resendSeconds}s',
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.resolvedTextHint,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : TextButton.icon(
                            onPressed: _loading
                                ? null
                                : () => _animateStep(() {
                                      _otpSent = false;
                                      _otp = '';
                                      _error = null;
                                    }),
                            icon: Icon(
                              Icons.refresh_rounded,
                              size: 16,
                              color: colors.resolvedLink,
                            ),
                            label: Text(
                              'Resend OTP',
                              style: TextStyle(
                                color: colors.resolvedLink,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animated phone icon ───────────────────────────────────────────────────────

class _PhoneIcon extends StatelessWidget {
  final bool sent;
  final AuthColorScheme colors;
  const _PhoneIcon({required this.sent, required this.colors});

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: sent
            ? AuthTheme.success.withValues(alpha: 0.1)
            : c.resolvedOtpIcon.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: sent
              ? AuthTheme.success.withValues(alpha: 0.3)
              : c.resolvedOtpIcon.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Icon(
        sent ? Icons.sms_outlined : Icons.phone_android_rounded,
        color: sent ? AuthTheme.success : c.resolvedOtpIcon,
        size: 36,
      ),
    );
  }
}

// ── 6-box OTP input ───────────────────────────────────────────────────────────

class _OtpBoxes extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final AuthColorScheme colors;
  const _OtpBoxes({required this.onCompleted, required this.colors});

  @override
  State<_OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<_OtpBoxes> {
  static const int _length = 6;
  final List<TextEditingController> _controllers =
      List.generate(_length, (_) => TextEditingController());
  final List<FocusNode> _nodes =
      List.generate(_length, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < _length - 1) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == _length) widget.onCompleted(otp);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_length, (i) {
        return SizedBox(
          width: 44,
          height: 52,
          child: TextFormField(
            controller: _controllers[i],
            focusNode: _nodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            onChanged: (v) => _onChanged(i, v),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: c.resolvedTextPrimary,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: c.resolvedInputFill,
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AuthTheme.radiusSM),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AuthTheme.radiusSM),
                borderSide: BorderSide(
                  color: c.resolvedInputBorder,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AuthTheme.radiusSM),
                borderSide: BorderSide(
                  color: c.resolvedInputFocusBorder,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        );
      }),
    );
  }
}
