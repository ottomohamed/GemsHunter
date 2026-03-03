import 'package:flutter/material.dart';

enum TileType { empty, red, gem }

class Tile extends StatelessWidget {
  final TileType type;
  final VoidCallback onTap;

  const Tile({
    super.key,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    Widget? child;
    List<BoxShadow> shadows = [];

    switch (type) {
      case TileType.red:
        color = const Color(0xFFFF2D55); // Neon Red
        child = const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30);
        shadows = [
          BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 15, spreadRadius: 2),
        ];
        break;
      case TileType.gem:
        color = const Color(0xFF00FF88); // Neon Green/Cyan
        child = const Icon(Icons.auto_awesome, color: Colors.white, size: 30);
        shadows = [
          BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 15, spreadRadius: 2),
        ];
        break;
      case TileType.empty:
        color = const Color(0xFF1E1E26); // Dark Slate
        child = null;
        shadows = [];
        break;
    }

    return GestureDetector(
      onTapDown: (_) => onTap(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: type == TileType.empty ? Colors.white10 : Colors.white24,
            width: 2,
          ),
          boxShadow: shadows,
        ),
        child: Center(
          child: child != null 
            ? TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: child,
              )
            : null,
        ),
      ),
    );
  }
}
