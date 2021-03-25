class PrintLog{

  static e({String tag = "E", String msg ="" }){
    print("\x1B[41m\x1B[30;1m 🐞 $tag\x1b[0m \x1B[0m\x1B[31m\n$msg\x1b[0m");
  }


}