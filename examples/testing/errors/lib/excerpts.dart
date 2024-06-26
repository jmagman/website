// ignore_for_file: directives_ordering

import './backend.dart';

import 'package:flutter/services.dart';

// #docregion catch-error
import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  MyBackend myBackend = MyBackend();
  PlatformDispatcher.instance.onError = (error, stack) {
    myBackend.sendError(error, stack);
    return true;
  };
  runApp(const MyApp());
}
// #enddocregion catch-error

// #docregion custom-error
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        Widget error = const Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(body: Center(child: error));
        }
        ErrorWidget.builder = (errorDetails) => error;
        if (widget != null) return widget;
        throw StateError('widget is null');
      },
    );
  }
}
// #enddocregion custom-error

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    // #docregion on-pressed
    return OutlinedButton(
      child: const Text('Click me!'),
      onPressed: () async {
        const channel = MethodChannel('crashy-custom-channel');
        await channel.invokeMethod('blah');
      },
    );
    // #enddocregion on-pressed
  }
}
