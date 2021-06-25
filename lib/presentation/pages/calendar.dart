

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';

import 'config/configuration.dart';

class Calendar {
  final DateTime date;
  final bool thisMonth;
  final bool prevMonth;
  final bool nextMonth;

  Calendar({
    this.date,
    this.thisMonth = false,
    this.prevMonth = false,
    this.nextMonth = false
  });
}

class CustomCalendar{

  // number of days in month [JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC]
  final List<int> _monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  // check for leap year
  bool _isLeapYear(int year){
    if(year % 4 == 0){
      if(year % 100 == 0){
        if(year % 400 == 0) return true;
        return false;
      }
      return true;
    }
    return false;
  }

  /// get the month calendar
  /// month is between from 1-12 (1 for January and 12 for December)
  List<Calendar> getMonthCalendar(int month, int year, {StartWeekDay startWeekDay = StartWeekDay.sunday}){

    // validate
    if(year == null || month == null || month < 1 || month > 12) throw ArgumentError('Invalid year or month');

    List<Calendar> calendar = List<Calendar>();

    // used for previous and next month's calendar days
    int otherYear;
    int otherMonth;
    int leftDays;

    // get no. of days in the month
    // month-1 because _monthDays starts from index 0 and month starts from 1
    int totalDays = _monthDays[month - 1];
    // if this is a leap year and the month is february, increment the total days by 1
    if(_isLeapYear(year) && month == DateTime.february) totalDays++;

    // get this month's calendar days
    for(int i=0; i<totalDays; i++){
      calendar.add(
        Calendar(
          // i+1 because day starts from 1 in DateTime class
          date: DateTime(year, month, i+1),
          thisMonth: true,
        ),
      );
    }

    // fill the unfilled starting weekdays of this month with the previous month days
    if(
      (startWeekDay == StartWeekDay.sunday && calendar.first.date.weekday != DateTime.sunday) ||
      (startWeekDay == StartWeekDay.monday && calendar.first.date.weekday != DateTime.monday)
    ){
      // if this month is january, then previous month would be decemeber of previous year
      if(month == DateTime.january){
        otherMonth = DateTime.december; // _monthDays index starts from 0 (11 for december)
        otherYear = year-1;
      }
      else{
        otherMonth = month - 1;
        otherYear = year;
      }
      // month-1 because _monthDays starts from index 0 and month starts from 1
      totalDays = _monthDays[otherMonth - 1];
      if(_isLeapYear(otherYear) && otherMonth == DateTime.february) totalDays++;

      leftDays = totalDays - calendar.first.date.weekday + ((startWeekDay == StartWeekDay.sunday) ? 0 : 1);
      
      for(int i=totalDays; i>leftDays; i--){
        calendar.insert(0,
          Calendar(
            date: DateTime(otherYear, otherMonth, i),
            prevMonth: true,
          ),
        );
      }
    }

    // fill the unfilled ending weekdays of this month with the next month days
    if(
      (startWeekDay == StartWeekDay.sunday && calendar.last.date.weekday != DateTime.saturday) ||
      (startWeekDay == StartWeekDay.monday && calendar.last.date.weekday != DateTime.sunday)
    ){
      // if this month is december, then next month would be january of next year
      if(month == DateTime.december){
        otherMonth = DateTime.january;
        otherYear = year+1;
      }
      else{
        otherMonth = month+1;
        otherYear = year;
      }
      // month-1 because _monthDays starts from index 0 and month starts from 1
      totalDays = _monthDays[otherMonth-1];
      if(_isLeapYear(otherYear) && otherMonth == DateTime.february) totalDays++;

      leftDays = 7 - calendar.last.date.weekday - ((startWeekDay == StartWeekDay.sunday) ? 1 : 0);
      if(leftDays == -1) leftDays = 6;

      for(int i=0; i<leftDays; i++){
        calendar.add(
          Calendar(
            date: DateTime(otherYear, otherMonth, i+1),
            nextMonth: true,
          ),
        );
      }
    }

    return calendar;

  }
}


class CalendarWidget extends StatefulWidget {
  List<Meditation> meditations;

  CalendarWidget({this.meditations});

  @override
  _CalendarState createState() => _CalendarState();
}

enum StartWeekDay {sunday, monday}


class _CalendarState extends State<CalendarWidget> {
  DateTime _currentDateTime;
  DateTime _selectedDateTime;
  List<Calendar> _sequentialDates;
  List<Meditation> filteredmeditations;
  int midYear;
  int selectedmonth, selectedyear;
  final List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  @override
  void initState() {
    super.initState();
    final date = DateTime.now();
    _currentDateTime = DateTime(date.year, date.month);
    selectedmonth = date.month -1 ;
    selectedyear = date.year;
    _selectedDateTime = DateTime(date.year, date.month, date.day);
    getMeditations(date.month, date.year);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _getCalendar());
    });
  }

  void getMeditations(month, year){
    filteredmeditations = widget.meditations.where((element) => element.day.month == month && element.day.year == year).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // dates view
  Widget _datesView(){
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // prev month button
              _toggleBtn(false),
              Text(_monthNames[selectedmonth] + ' ' + selectedyear.toString(), style: Configuration.text('small', Colors.black),),

              Chip(label: Text(filteredmeditations.length.toString() + ' meditations', style: Configuration.text('verytiny', Colors.black))),
              // next month button
              _toggleBtn(true),
            ],
          ),
          SizedBox(height: 10),
          _calendarBody(),
          
        ],
    );
  }
  
   // calendar
  Widget _calendarBody() {
    if(_sequentialDates == null) return Container();
    //HAY QUE QUITAR EL GRIDVIEW PARA PODER HACERLO SIN ESPACIOS :()
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: _sequentialDates.length + 7,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent: 25.0,
        mainAxisSpacing: 15,
        crossAxisCount: 7,
        crossAxisSpacing: 15,
      ), 
      itemBuilder: (context, index){
        if(index < 7) return _weekDayTitle(index);
        //if(_sequentialDates[index - 7].date == _selectedDateTime) return _selector(_sequentialDates[index - 7]);
        return _calendarDates(_sequentialDates[index - 7]);
      },
    );
  }

  // next / prev month buttons
  Widget _toggleBtn(bool next) {
    return InkWell(
      onTap: (){
          setState(() => (next) ? _getNextMonth() : _getPrevMonth());        
      },
      child: Container(
        alignment: Alignment.center,
        child: Icon((next) ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: Colors.black),
      ),
    );
  }
  
  // calendar header
  Widget _weekDayTitle(int index){
    return Center(child: Text(_weekDays[index], style: TextStyle(color: Colors.black, fontSize: 12)));
  }

  // calendar element
  Widget _calendarDates(Calendar calendarDate){
    return InkWell(
      onTap: (){
        if(_selectedDateTime != calendarDate.date){
          if(calendarDate.nextMonth){
            _getNextMonth();
          }
          else if(calendarDate.prevMonth){
            _getPrevMonth();
          }
          setState(() => _selectedDateTime = calendarDate.date);
        } 
      },
      child: Center(
        child: Column(
          children: [
            Text(
              '${calendarDate.date.day}', 
              style: TextStyle(
                color: (calendarDate.thisMonth) 
                ? (calendarDate.date.weekday == DateTime.sunday) ? Colors.black : Colors.black 
                : (calendarDate.date.weekday == DateTime.sunday) ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.5),
              ),
            ),
            filteredmeditations.where((element) => element.day.day == calendarDate.date.day && element.day.month == calendarDate.date.month).length > 0 ?
            Icon(Icons.self_improvement, size: 9, color: Configuration.maincolor) : Container()
          ],
        )
      ),
    );
  }

  // date selector
  Widget _selector(Calendar calendarDate) {
    return Container(
      decoration: BoxDecoration(
        color: Configuration.maincolor,
        borderRadius: BorderRadius.circular(50)
      ),
      child: Center(
        child: Text(
          '${calendarDate.date.day}',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
    );
  }

  // get next month calendar
  void _getNextMonth() {
    if(_currentDateTime.month == 12) {
      selectedmonth = 0;
      selectedyear ++;
      _currentDateTime = DateTime(_currentDateTime.year+ 1, 1);
    }
    else{
      selectedmonth++;
      _currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month+1);
    }
    
    getMeditations(selectedmonth + 1, selectedyear);

    _getCalendar();
  }

  // get previous month calendar
  void _getPrevMonth(){
    if(_currentDateTime.month == 1){
      selectedmonth = 11;
      selectedyear--;
      _currentDateTime = DateTime(_currentDateTime.year-1, 12);
    }
    else {
      selectedmonth--;
      _currentDateTime = DateTime(_currentDateTime.year, _currentDateTime.month-1);
    }

    getMeditations(selectedmonth + 1, selectedyear);

    _getCalendar();
  }

  // get calendar for current month
  void _getCalendar(){
    _sequentialDates = CustomCalendar().getMonthCalendar(_currentDateTime.month, _currentDateTime.year, startWeekDay: StartWeekDay.monday);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
          padding: EdgeInsets.all(8),
          child: _datesView() 
    );
  }
}





