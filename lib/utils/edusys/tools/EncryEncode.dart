class EncryEncode{
  static String keyStr="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

  static String toEncodeInp(String account,String password){
    return _encodeInp(account)+"%%%"+_encodeInp(password);
  }

  static String _encodeInp(String input){
    var output="";
    var chr1,chr2,chr3;
    var enc1,enc2,enc3,enc4;
    var i =0;
    do{
      chr1 = i+1<=input.length?input.codeUnitAt(i++):null;
      chr2 = i+1<=input.length?input.codeUnitAt(i++):null;
      chr3 = i+1<=input.length?input.codeUnitAt(i++):null;
      enc1=(chr1!=null?chr1>>2:0);
      enc2=(((chr1!=null?chr1&3:0)<<4)|(chr2!=null?chr2>>4:0));
      enc3=(((chr2!=null?chr2&15:0)<<2)|(chr3!=null?chr3>>6:0));
      enc4=(chr3!=null?chr3&63:0);

      if(chr2==null)
        enc3 = enc4 = 64;
      else if(chr3==null)
        enc4=64;

      output = output+keyStr[enc1]+keyStr[enc2]+keyStr[enc3]+keyStr[enc4];
      chr1=chr2=chr3=null;
      enc1=enc2=enc3=enc4=null;
    }while(i<input.length);

    return output;
  }
}