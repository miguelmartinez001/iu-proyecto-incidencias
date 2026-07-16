import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  secondary,
  danger,
  dangersecondary,
  outline,
  neutral,
}

enum IconPosition { left, right }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool? isDisabled;
  final IconPosition iconPosition;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isDisabled = false,
    this.iconPosition = IconPosition.left,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    if (isDisabled == true) {
      backgroundColor = colorScheme.onSurface.withValues(alpha: 0.12);
      foregroundColor = colorScheme.onSurface.withValues(alpha: 0.38);
      borderSide = null;
    } else {
      switch (variant) {
        case ButtonVariant.primary:
          backgroundColor = colorScheme.primary;
          foregroundColor = colorScheme.onPrimary;
          break;
        case ButtonVariant.secondary:
          backgroundColor = colorScheme.secondary;
          foregroundColor = colorScheme.onSecondary;
          break;
        case ButtonVariant.danger:
          backgroundColor = colorScheme.error;
          foregroundColor = colorScheme.onError;
          break;
        case ButtonVariant.dangersecondary:
          backgroundColor = colorScheme.error;
          foregroundColor = colorScheme.onError;
          break;
        case ButtonVariant.outline:
          backgroundColor = Colors.transparent;
          foregroundColor = colorScheme.primary;
          borderSide = BorderSide(color: colorScheme.primary, width: 2);
          break;
        case ButtonVariant.neutral:
          backgroundColor = colorScheme.surface;
          foregroundColor = colorScheme.onSurface;
          borderSide = BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.12),
            width: 1,
          );
          break;
      }
    }

    final buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (icon != null && iconPosition == IconPosition.left) ...[
          Icon(icon, size: 20, color: foregroundColor),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: foregroundColor,
          ),
        ),
        if (icon != null && iconPosition == IconPosition.right) ...[
          const SizedBox(width: 8),
          Icon(icon, size: 20, color: foregroundColor),
        ],
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: (isDisabled == true || variant == ButtonVariant.outline)
              ? 0
              : 2,
          shape: const StadiumBorder(),
          side: borderSide,
        ),
        onPressed: isDisabled == true ? null : onPressed,
        child: buttonContent,
      ),
    );
  }
}
