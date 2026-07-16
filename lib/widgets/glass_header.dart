import 'dart:ui';

import 'package:flutter/material.dart';

class GlassHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool? showRightActionButton;
  final Widget? rightActionButton;
  final VoidCallback? onRightActionPressed;

  const GlassHeader({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.showRightActionButton = false,
    this.rightActionButton,
    this.onRightActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          width: double.infinity,
          height: statusBarHeight + 60,
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.90),
            border: Border(
              bottom: BorderSide(
                color: colorScheme.onSurface.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          padding: EdgeInsets.only(top: statusBarHeight, left: 16, right: 16),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              if (showBackButton) ...[
                GestureDetector(
                  onTap: onBackPressed ?? () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.90),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              if (showRightActionButton == true) ...[
                const SizedBox(width: 12),
                rightActionButton ?? Container(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
