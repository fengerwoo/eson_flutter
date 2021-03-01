
import 'package:eson/eson.dart';
import 'package:flutter/material.dart';

class EsonProvider extends StatelessWidget{

  Eson eson;
  Widget child;

  EsonProvider({
    Key key,
    @required this.eson,
    @required this.child,

  }) : assert(eson !=  null, "The eson of EsonProvider cannot be null"),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.child;
  }

  static Eson of(BuildContext context){
    EsonProvider esonProvider = context.findAncestorWidgetOfExactType<EsonProvider>();
    if(esonProvider != null){
      return esonProvider.eson;
    }else{
      return null;
    }
  }

}