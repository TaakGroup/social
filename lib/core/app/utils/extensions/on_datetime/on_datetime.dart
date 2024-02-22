import 'package:intl/intl.dart';

extension ToString on DateTime {
  String toServerString() => DateFormat('yyyy-MM-dd HH:mm:ss.sssss').format(this);
}
