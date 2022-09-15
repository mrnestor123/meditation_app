
String datetoString(DateTime d){
  String string = '';

  return d.year.toString()  + '-' + (d.month.toString().length == 1 ?  '0':'') + d.month.toString() + '-' +  (d.day.toString().length == 1 ?  '0':'') + d.day.toString();
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



String getMinutes(Duration d){
  String minutes = (d.inMinutes % 60).toString();

  if(minutes.length > 1){
    return minutes;
  }else{
    return '0'+ minutes;
  }
}

