import 'package:flutter/material.dart';

extension DurationFormat on Duration{
  String printDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

extension StringFormat on String{



  String maxLength(int num){
    if(length>num){
      return substring(0, num);
    }
    return this;
  }

  String normalize(){
    String res = toLowerCase();
    res = res.replaceFirst(res.characters.first, res.characters.first.toUpperCase());
    return res;
  }

  String toCamellCase(){
    List<String> _list = toLowerCase().split(" ");
    String res = "";
    for(String x in _list){
      res+= x.replaceFirst(x.characters.first, x.characters.first.toUpperCase());
      res+=" ";
    }
    return res.trim();
  }

  double? toDouble(){
    try{  return  double.parse(replaceAll(',', '.')); }
    catch(E){ return null;  }
  }

  String clearSimbols(){
    String regex = r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+';
    return replaceAll(RegExp(regex, unicode: true),'');
  }
}

extension DateFormat on DateTime{
  String monthName(){
    switch(month){
      case 1 : return "Enero";
      case 2 : return "Febrero";
      case 3 : return "Marzo";
      case 4 : return "Abril";
      case 5 : return "Mayo";
      case 6 : return "Junio";
      case 7 : return "Julio";
      case 8 : return "Agosto";
      case 9 : return "Septiembre";
      case 10 : return "Octubre";
      case 11 : return "Noviembre";
      case 12 : return "Diciembre";
      default : return "";
    }
  }
  String shortMonthName(){
    switch(month){
      case 1 : return "Ene";
      case 2 : return "Feb";
      case 3 : return "Mar";
      case 4 : return "Abr";
      case 5 : return "May";
      case 6 : return "Jun";
      case 7 : return "Jul";
      case 8 : return "Ago";
      case 9 : return "Sep";
      case 10 : return "Oct";
      case 11 : return "Nov";
      case 12 : return "Dic";
      default : return "";
    }
  }
  int monthDays(){
    switch(month){
      case 1 : return 31;
      case 2 : return isLeapYear() ? 29 : 28;
      case 3 : return 31;
      case 4 : return 30;
      case 5 : return 31;
      case 6 : return 30;
      case 7 : return 31;
      case 8 : return 31;
      case 9 : return 30;
      case 10 : return 31;
      case 11 : return 30;
      case 12 : return 31;
      default : return 0;
    }
  }

  int monthDifference(DateTime afterTime) => afterTime.month-month + 12 * (afterTime.year-year);

  bool isLeapYear() => (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  String toStringWeekDay(){
    switch(weekday){
      case 1 : return "Lun";
      case 2 : return "Mar";
      case 3 : return "Mie";
      case 4 : return "Jue";
      case 5 : return "Vie";
      case 6 : return "Sab";
      case 7 : return "Dom";
      default : return "";
    }
  }
  String toFormatStringDate(){ return '$day-$month-$year';}
  String toFormatStringHour(){ return '$hour:${minute>10 ? minute : '0$minute'} ${hour<12? 'am' : 'pm'}';}

  get id => '${day<10 ? '0$day' : '$day'}-$month-$year';

  DateTime cropTime(){
    return DateTime(year, month, day);

  }

  DateTime lastMonday(){
    DateTime res = this;
    while(res.weekday!=1){
      res= res.add(const Duration(days: -1));
    }
    return res;
  }
  DateTime nextSaturday(){
    DateTime res = this;
    while(res.weekday!=7){
      res= res.add(const Duration(days: 1));
    }
    return res;
  }
  bool isSameDate(DateTime date){
    return day == date.day && month == date.month && year == date.year;
  }
  int fromBirthdayToAge(){
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - year;
    int month1 = currentDate.month;
    int month2 = month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}

