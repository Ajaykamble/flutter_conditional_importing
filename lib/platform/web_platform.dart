import 'package:flutter/src/widgets/framework.dart';
import 'package:toturial/platform/custom_platform.dart';
import 'dart:js' as js;

CustomPlatform getInstance() => CustomPlatformWeb();

class CustomPlatformWeb implements CustomPlatform {
  @override
  Future<void> displayAlert(BuildContext context, String message) async{
    js.context.callMethod("displayAlert", [message]);
  }
}

