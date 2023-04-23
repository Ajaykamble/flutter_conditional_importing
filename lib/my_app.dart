import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

import 'package:flutter/services.dart';
import 'package:toturial/platform/custom_platform.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FilledButton(
                onPressed: () {
                  CustomPlatform().displayAlert(context,"This is sample alert");
                },
                child: const Text("Show Alert"),
              ),
            ),
          ],
        ),
      );
  }
}
