
String getIsoDatetime(DateTime date) {
  // make date string without offset
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  final second = date.second.toString().padLeft(2, '0');
  final datetimeString =
      '${date.year}-${month}-${day}T${hour}:${minute}:${second}.000';

  // make offset string
  final duration = date.timeZoneOffset;
  final offsetHours = duration.inHours.abs().toString().padLeft(2, '0');
  final offsetMinutes =
      (duration.inMinutes.abs() - (duration.inHours.abs() * 60))
          .toString()
          .padLeft(2, '0');
  final offsetString = "$offsetHours:$offsetMinutes";

  // offset positive/negative
  if (duration.isNegative)
    return datetimeString + "-" + offsetString;
  else
    return datetimeString + "+" + offsetString;
  ;
}