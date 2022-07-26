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
  String iDay(){
    String dayValue = day.toString();
    if(dayValue.length == 1){
      dayValue = '0$day';
    }
    return '$dayValue-$month-$year';
  }
  DateTime lastMonday(){
    DateTime res = this;
    while(res.weekday!=1){
      res= res.add(Duration(days: -1));
    }
    return res;
  }


}

