import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_platform.dart';

CustomPlatform getInstance() => CustomPlatformOther();

class CustomPlatformOther implements CustomPlatform {
  @override
  Future<void> displayAlert(BuildContext context, String message) async {
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
  }
}
