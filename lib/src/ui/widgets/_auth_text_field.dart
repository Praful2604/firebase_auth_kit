import 'package:flutter/material.dart';
import '../config/auth_color_scheme.dart';
import '../theme/auth_theme.dart';

/// Styled text field used across auth forms.
class AuthTextField extends StatefulWidget {
  final String label;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final AuthColorScheme colors;

  const AuthTextField({
    super.key,
    required this.label,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.focusNode,
    this.colors = const AuthColorScheme(),
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = false;
  bool _focused = false;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _focus = widget.focusNode ?? FocusNode();
    _focus.addListener(() {
      if (mounted) setState(() => _focused = _focus.hasFocus);
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    final focusColor = c.resolvedInputFocusIcon;
    final hintColor = c.resolvedTextHint;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AuthTheme.radiusMD),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: focusColor.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: TextFormField(
        focusNode: _focus,
        obscureText: _obscure,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: c.resolvedTextPrimary,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _focused ? focusColor : hintColor,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(
              widget.prefixIcon,
              size: 20,
              color: _focused ? focusColor : hintColor,
            ),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: hintColor,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
              : null,
          filled: true,
          fillColor: c.resolvedInputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.radiusMD),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.radiusMD),
            borderSide: BorderSide(
              color: c.resolvedInputBorder,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.radiusMD),
            borderSide: BorderSide(
              color: c.resolvedInputFocusBorder,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.radiusMD),
            borderSide: BorderSide(color: c.resolvedError, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.radiusMD),
            borderSide: BorderSide(color: c.resolvedError, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: TextStyle(
            fontSize: 12,
            color: c.resolvedError,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
