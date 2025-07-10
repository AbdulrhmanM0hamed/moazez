import 'package:flutter/material.dart';

/// A widget that simulates two doors opening from the center,
/// revealing a [child] widget beneath. Typically used for a splash screen effect.
class DoorOpenAnimation extends StatelessWidget {
  const DoorOpenAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1800),
    this.height = 300, // يمكنك تغييره حسب احتياجك
  }) : super(key: key);

  /// Widget revealed after the doors fully open (e.g., app logo).
  final Widget child;

  /// Total duration of the door-opening animation.
  final Duration duration;

  /// Fixed height for animation area to prevent layout issues.
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity, // اجعل العرض ممتد لكامل الشاشة
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          return Stack(
            children: [
              Center(child: child),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: 0.0),
                duration: duration,
                curve: Curves.easeInOutCubic,
                builder: (context, value, _) {
                  final panelWidth = maxWidth * value * 0.5;
                  return Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: panelWidth,
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: panelWidth,
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
