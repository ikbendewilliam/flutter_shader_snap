# flutter_shader_snap

[![pub package](https://img.shields.io/pub/v/flutter_shader_snap.svg)](https://pub.dartlang.org/packages/flutter_shader_snap)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

Create the Thanos snap effect with a simple widget.

| Split (default) | Smoke |
| -------- | ------- |
| <img src="https://github.com/ikbendewilliam/flutter_shader_snap/blob/main/example/screenshots/split.gif?raw=true" alt="customcropcircle" height="320"/> | <img src="https://github.com/ikbendewilliam/flutter_shader_snap/blob/main/example/screenshots/smoke.gif?raw=true" alt="customcropsquare" height="320"/> |

 


## Getting Started

Add the dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_shader_snap: latest version
```

### IMPORTANT

Add the shader to your `pubspec.yaml` file:

```yaml
flutter:
  shaders:
    - packages/flutter_shader_snap/shaders/split_snap_effect_shader.glsl # add if you use SnapShaderType.split (default)
    - packages/flutter_shader_snap/shaders/split_reversed_snap_effect_shader.glsl # add if you use SnapShaderType.splitReversed
    - packages/flutter_shader_snap/shaders/smoke_snap_effect_shader.glsl # add if you use SnapShaderType.smoke
```

Create an `AnimationController` and just add the SnapShader widget:

```dart
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );

  @override
  Widget build(BuildContext context) {
    return SnapShader(
        controller: _controller,
        child: Any Widget...
    );
  }
}
```

## Performance

The shader is only applied to the child widget when the animation is running, so it doesn't affect the performance of the app.

```dart
builder: (context, child) => controller.value == 0
    ? child!
    : AnimatedSampler
```

It works best with "transparent" widgets (for example Text), but you can use it with any widget.
