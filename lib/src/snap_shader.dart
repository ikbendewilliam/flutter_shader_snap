import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// A widget that applies a snap effect to its child.
class SnapShader extends StatelessWidget {
  /// A controller that can be used to control the snap effect
  final AnimationController controller;

  /// The widget to apply the snap effect to
  final Widget child;

  /// Whether to use the split shader or the smoke shader
  final SnapShaderType snapShaderType;

  const SnapShader({
    required this.child,
    required this.controller,
    this.snapShaderType = SnapShaderType.split,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'packages/flutter_shader_snap/shaders/${snapShaderType.fileName}',
      (context, shader, child) => AnimatedBuilder(
        animation: controller,
        builder: (context, child) => controller.value == 0
            ? child!
            : AnimatedSampler(
                (image, size, canvas) {
                  shader
                    ..setFloat(0, size.width)
                    ..setFloat(1, size.height)
                    ..setFloat(2, controller.value * 0.8) // 0.8 makes the effect fit between 0 and 1
                    ..setImageSampler(0, image);

                  final paint = Paint()..shader = shader;
                  canvas.drawRect(
                    Rect.fromLTWH(0, 0, size.width, size.height),
                    paint,
                  );
                },
                child: child!,
              ),
        child: child,
      ),
      child: child,
    );
  }
}

/// The type of snap shader to use
enum SnapShaderType {
  /// A shader that splits
  split('split_snap_effect_shader.glsl'),

  /// A shader that splits in reverse
  /// Ideal for revealing something or creating
  /// a looped animation with the split shader.
  ///
  /// Where the split shader will split from left to right,
  /// the split reversed shader will split from right to left
  /// or reveal from left to right.
  splitReversed('split_reversed_snap_effect_shader.glsl'),

  /// A shader that creates a smoke type effect
  smoke('smoke_snap_effect_shader.glsl');

  /// The file name of the shader
  final String fileName;

  const SnapShaderType(this.fileName);
}
