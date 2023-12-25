import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shader_snap/flutter_shader_snap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );
  late final _controller2 = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );
  int _counter = 0;
  int _index = 0;
  var _useSplitShader = true;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller2.addStatusListener((status) async {
      if (status != AnimationStatus.completed || _controller2.value == 0) return;
      await Future.delayed(const Duration(seconds: 3));
      _controller2.animateBack(0, duration: const Duration(seconds: 1));
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _index++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SnapShader(
      controller: _controller2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Flutter Shader Snap DEMO'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const Spacer(),
                SnapShader(
                  controller: _controller,
                  snapShaderType: _useSplitShader ? SnapShaderType.split : SnapShaderType.smoke,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You have pushed the button this many times:',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.green),
                      ),
                      Text(
                        '$_counter',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: 100,
                        height: 100,
                        color: Colors.primaries[_index % Colors.primaries.length],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Switch(
                            value: _useSplitShader,
                            onChanged: (value) => setState(() => _useSplitShader = value),
                          ),
                          const Text('Use split (on) or smoke (off) shader'),
                        ],
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: _controller.value,
                  onChanged: (value) => _controller.value = value,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _controller.forward(),
                  child: const Text('Snap!'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _controller.stop(canceled: false),
                  child: const Text('Pause'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _controller.reset(),
                  child: const Text('Reset'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _controller2.forward(),
                  child: const Text('Snap EVERITHING!'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
