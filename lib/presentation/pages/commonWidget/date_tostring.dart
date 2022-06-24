
String datetoString(DateTime d){
  String string = d.toIso8601String();

  return d.day.toString() + '-' + d.month.toString();
}


String getMonth(DateTime d){
  List<String> months = [
    'January','February','March','April','May','June','July','August','September','October','November','December'
  ];

  return months[d.month-1];

}


String getHour(DateTime d){
  
  return d.hour.toString() + ':' + d.minute.toString();
}

