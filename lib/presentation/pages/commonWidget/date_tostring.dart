
String datetoString(DateTime d){
  String string = '';

  return d.year.toString()  + '-' + (d.month.toString().length == 1 ?  '0':'') + d.month.toString() + '-' +  (d.day.toString().length == 1 ?  '0':'') + d.day.toString();
}

String dayAndMonth(DateTime d){
  String string = '';

  return (d.day.toString().length == 1 ?  '0':'')  + d.day.toString() + '-' + (d.month.toString().length == 1 ?  '0':'') + d.month.toString() ;
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


DateTime firstDayMonth(DateTime d){
  return new DateTime(d.year,d.month,1);
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


String getTimeMeditatedString({int time}){
  String timemeditated = '';

  if(time == null || time == 0) return '0m';

  // SE PUEDE SACAR DEL TOTAL DE  MEDITACIONES
  int hours = time ~/ 60; 

  if(hours > 24){
    int days = hours ~/ 24;
    int remaininghours = hours % 24;

    if(days > 7){
      int weeks = days ~/ 7;
      int remainingdays = days%7;
      
      timemeditated = weeks.toString() + 'w ' +  remainingdays.toString() + 'd';
    }else{
      timemeditated = days.toString() + 'd ' + remaininghours.toString() + 'h';
    }
  }else{
    if(hours >= 1){
      timemeditated = hours.toString() + 'h';
    }else{
      int minutes = time % 60;
      timemeditated = minutes.toString() + 'm';
    }
  }

  return timemeditated;
}
