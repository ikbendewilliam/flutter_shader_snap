# flutter_shader_snap

Create the Thanos snap effect with a simple widget.

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
    - packages/flutter_shader_snap/shaders/snap_effect_shader.glsl
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

It works best with "transparent" widgets (for example Text), but you can use it with any widget. May look weird on "blocky" widgets like a rectangular container.
