
class WeekDayForm{

  static String Chinese(int week){

    switch(week){
      case 1:
        return "一";
      case 2:
        return "二";
      case 3:
        return "三";
      case 4:
        return "四";
      case 5:
        return "五";
      case 6:
        return "六";
      case 7:
        return "日";
      default:
        return "未知";
    }


  }

}