import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Subtle tactile-feedback wrapper: scales [child] down slightly while
/// pressed. A cheap GPU transform (no repaint of [child] itself), used to
/// make buttons and tappable cards feel more responsive. When [haptic] is set
/// it also fires a light haptic on press-down for a native feel.
class PressScale extends StatefulWidget {
  const PressScale({
    super.key,
    required this.child,
    this.scale = 0.97,
    this.enabled = true,
    this.haptic = false,
  });

  final Widget child;
  final double scale;
  final bool enabled;
  final bool haptic;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled || _pressed == value) return;
    if (value && widget.haptic) HapticFeedback.lightImpact();
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
