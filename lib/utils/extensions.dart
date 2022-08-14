import 'package:flutter/material.dart';

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
}

extension DateFormat on DateTime{
  String toStringMonth(){
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

