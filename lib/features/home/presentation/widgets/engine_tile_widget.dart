import 'package:flutter/material.dart';
import 'package:prudential_tems/core/theme/app_colors.dart';
import '../../data/models/engine_model.dart';

class EngineTileWidget extends StatefulWidget {
  final Engine engine;
  final VoidCallback onTileSelected;

  const EngineTileWidget({
    super.key,
    required this.engine,
    required this.onTileSelected,
  });

  @override
  _EngineTileWidgetState createState() => _EngineTileWidgetState();
}

class _EngineTileWidgetState extends State<EngineTileWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for rotation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Duration of each rotation
    )..repeat(); // Make the rotation repeat continuously

    // Create a Tween for the rotation from 0 to 1 (360 degrees)
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    // Dispose the controller to free up resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTileSelected,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryColor, AppColors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Rotation applied to the engine image
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return RotationTransition(
                    turns: _rotationAnimation,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/turbofan_engine.png',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      widget.engine.model,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      'Type: ${widget.engine.type}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      'Thrust: ${widget.engine.thrust}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      'Weight: ${widget.engine.weight}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
