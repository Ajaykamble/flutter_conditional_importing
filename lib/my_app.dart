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
  
  displayAlert(String message) async {
    if (!kIsWeb) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          showDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              content: Text(message),
            ),
          );
          break;
        case TargetPlatform.windows:
          const methodChannel = MethodChannel('dev.fluttercrew');
          await methodChannel.invokeMethod("displayAlert", {"message": message});
          break;
        case TargetPlatform.android:
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Text(message),
            ),
          );
          break;
        default:
          break;
      }
    } else {
      js.context.callMethod("displayAlert", [message]);
    }
  }

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
