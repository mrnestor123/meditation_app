
String datetoString(DateTime d){
  String string = d.toIso8601String();

  return d.day.toString() + '-' + d.month.toString();
}