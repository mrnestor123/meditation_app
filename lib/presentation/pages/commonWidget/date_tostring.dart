
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
  return  (d.hour < 10  ? '0':'')+ d.hour.toString() + ':' + (d.minute <  10 ? '0':'') +  d.minute.toString();
}



String getMinutes(Duration d){
  String minutes = (d.inMinutes % 60).toString();

  if(minutes.length > 1){
    return minutes;
  }else{
    return '0'+ minutes;
  }
}

String getSeconds(Duration d){
  String seconds = (d.inSeconds % 60).toString();

  if(seconds.length > 1){
    return seconds;
  }else{
    return '0'+ seconds;
  }
}



int weekOfMonth(DateTime d){
    var wom = 0;
    var month = d.month;
    DateTime aux = new  DateTime(d.year,d.month,d.day);


    while (aux.month == month) {
      wom++;
      aux = aux.subtract(const Duration(days: 7));
    }

    return wom;
  }


