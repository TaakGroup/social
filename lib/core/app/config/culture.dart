import 'dart:ui';
import '../constants/messages.dart';
import '../utils/classes/app_datetime.dart';

class Culture {
  final DateTimeType dateTimeType;
  final Locale locale;
  final TextDirection textDirection;
  final String fontFamily;

  Culture.iran()
      : dateTimeType = DateTimeType.jalali,
        locale = Messages.persian,
        textDirection = TextDirection.rtl,
        fontFamily = 'YekanBakh';

  Culture.china()
      : dateTimeType = DateTimeType.gregorian,
        locale = Messages.china,
        textDirection = TextDirection.ltr,
        fontFamily = 'Roboto';
}
