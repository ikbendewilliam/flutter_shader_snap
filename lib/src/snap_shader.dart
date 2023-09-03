import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class SnapShader extends StatelessWidget {
  final AnimationController controller;
  final Widget child;

  const SnapShader({
    required this.child,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'packages/flutter_shader_snap/shaders/snap_effect_shader.glsl',
      (context, shader, child) => AnimatedBuilder(
        animation: controller,
        builder: (context, child) => controller.value == 0
            ? child!
            : AnimatedSampler(
                (image, size, canvas) {
                  shader
                    ..setFloat(0, size.width)
                    ..setFloat(1, size.height)
                    ..setFloat(2, controller.value)
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
