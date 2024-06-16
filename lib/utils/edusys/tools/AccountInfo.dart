class AccountInfo{
  String? _accountPersionalInformationHTML;
  String _allJson="";

  AccountInfo(this._accountPersionalInformationHTML);

  String getAccountName(){
    RegExp regExp1 = RegExp(r'姓名</td>([\w\W]+)>性别');
    Iterable<Match> match1 = regExp1.allMatches(_accountPersionalInformationHTML!);

    for(Match m in match1){
      RegExp regExp2 = RegExp(r'>&nbsp;([^<]+)</td>');
      Iterable<Match> match2 = regExp2.allMatches(m.group(1).toString());
      for(Match m2 in match2){
        return m2.group(1).toString();
      }
      break;
    }
    return "";
  }

  String getAccountMajor(){
    RegExp regExp1 = RegExp(r'>专业：([\w\W]+)>学制');
    Iterable<Match> match1 = regExp1.allMatches(_accountPersionalInformationHTML!);

    for(Match m in match1){
      RegExp regExp2 = RegExp(r'([^<]+)</td>');
      Iterable<Match> match2 = regExp2.allMatches(m.group(1).toString());
      for(Match m2 in match2){
        return m2.group(1).toString();
      }
      break;
    }
    return "";
  }


  String getAccountID(){
    RegExp regExp1 = RegExp(r'>学号：([\w\W]+)</tr>');
    Iterable<Match> match1 = regExp1.allMatches(_accountPersionalInformationHTML!);

    for(Match m in match1){
      RegExp regExp2 = RegExp(r'([^<]+)</td>');
      Iterable<Match> match2 = regExp2.allMatches(m.group(1).toString());
      for(Match m2 in match2){
        return m2.group(1).toString();
      }
      break;
    }
    return "";
  }

  String getAccountClass(){
    RegExp regExp1 = RegExp(r'>班级：([\w\W]+)学号：');
    Iterable<Match> match1 = regExp1.allMatches(_accountPersionalInformationHTML!);

    for(Match m in match1){
      RegExp regExp2 = RegExp(r'([^<]+)</td>');
      Iterable<Match> match2 = regExp2.allMatches(m.group(1).toString());
      for(Match m2 in match2){
        return m2.group(1).toString();
      }
      break;
    }
    return "";
  }

  String getAccountCollege(){
    RegExp regExp1 = RegExp(r'>院系：([\w\W]+)专业');
    Iterable<Match> match1 = regExp1.allMatches(_accountPersionalInformationHTML!);

    for(Match m in match1){
      RegExp regExp2 = RegExp(r'([^<]+)</td>');
      Iterable<Match> match2 = regExp2.allMatches(m.group(1).toString());
      for(Match m2 in match2){
        return m2.group(1).toString();
      }
      break;
    }
    return "";
  }

  String getAccountLengthOfSchool(){
    RegExp regExp1 = RegExp(r'>学制：([\w\W]+)班级');
    Iterable<Match> match1 = regExp1.allMatches(_accountPersionalInformationHTML!);

    for(Match m in match1){
      RegExp regExp2 = RegExp(r'([^<]+)</td>');
      Iterable<Match> match2 = regExp2.allMatches(m.group(1).toString());
      for(Match m2 in match2){
        return m2.group(1).toString();
      }
      break;
    }
    return "";
  }

  String getAccountGender(){
    RegExp regExp1 = RegExp(r'性别</td>([\w\W]+)>姓名拼音');
    RegExpMatch? match1 = regExp1.firstMatch(_accountPersionalInformationHTML!);
    if(match1!=null){
      RegExp regExp2 = RegExp(r'>&nbsp;([^<]+)</td>');
      RegExpMatch? match2 = regExp2.firstMatch(match1.group(1).toString());
      if(match2!=null){
        return match2.group(1).toString();
      }
    }
    return "";
  }


  String getAllJSON(){
    String name = getAccountName();
    String major = getAccountMajor();
    String id = getAccountID();
    String gender = getAccountGender();
    String studentClass = getAccountClass();
    String college = getAccountCollege();
    String lengthOfSchool = getAccountLengthOfSchool();
    _allJson+="{";


    _allJson+="\"name\":"+"\""+name+"\"";
    _allJson+=",\"major\":"+"\""+major+"\"";
    _allJson+=",\"id\":"+"\""+id+"\"";
    _allJson+=",\"gender\":"+"\""+gender+"\"";
    _allJson+=",\"studentClass\":"+"\""+studentClass+"\"";
    _allJson+=",\"college\":"+"\""+college+"\"";
    _allJson+=",\"lengthOfSchool\":"+"\""+lengthOfSchool+"\"";

    _allJson+="}";


    return _allJson;
  }



}