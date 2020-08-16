import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/custom_widget/platform_alert_dialogue.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialogue {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(
          title: title,
          content: exception.message,
          defaultActionText: 'OK',
  );
}
