
import 'package:eson/eson.dart';
import 'package:flutter/material.dart';

/// 监听者Widget，构建局部刷新的组件
class WatcherWidget extends StatefulWidget{

  Eson eson;
  String path;
  Widget child;
  Widget Function(BuildContext context, dynamic value, Eson eson, Widget child) builder;


  WatcherWidget({
    @required this.eson,
    @required this.path,
    @required this.builder,
    this.child,
    Key key}): super(key:key);


  @override
  State<StatefulWidget> createState() => WatcherWidgetState();

}

class WatcherWidgetState extends State<WatcherWidget>{

  @override
  void initState() {
    super.initState();
    // 注册监听者
    this.widget.eson.watch({
      this.widget.path: (value, oldValue){
        setState(() {});
      },
    }, this);
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.builder(context, this.widget.eson.get(this.widget.path), this.widget.eson, this.widget.child);
  }

  @override
  void dispose() {
    super.dispose();
    // 注销监听者
    this.widget.eson.removeWatch(this);
  }

}