
import 'package:eson/eson.dart';
import 'package:flutter/material.dart';

/// 监听者Widget，构建局部刷新的组件
class WatcherWidget<T> extends StatefulWidget{

  Eson eson;
  String path;
  Widget child;
  T defaultValue;
  Widget Function(BuildContext context, T value, Eson eson, Widget child) builder;


  WatcherWidget({
    @required this.eson,
    @required this.path,
    @required this.builder,
    this.child,
    this.defaultValue,
    Key key}): super(key:key);


  @override
  State<StatefulWidget> createState() => WatcherWidgetState<T>();

}

class WatcherWidgetState<T> extends State<WatcherWidget<T>>{

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
    T value = this.widget.eson.get(this.widget.path, defaultValue: this.widget.defaultValue);
    return this.widget.builder(context, value, this.widget.eson, this.widget.child);
  }

  @override
  void dispose() {
    super.dispose();
    // 注销监听者
    this.widget.eson.removeWatch(this);
  }

}