import 'package:eson/src/eson_provider.dart';
import 'package:flutter/cupertino.dart';

import '../eson.dart';

class EsonConsumer<T> extends StatefulWidget {

  bool isInitWatcher = false;

  Eson eson;
  String path;
  Widget child;
  T defaultValue;

  final Widget Function(BuildContext context, T value, Eson eson, Widget child) builder;

  EsonConsumer({
    this.eson,
    this.path = "",
    @required this.builder,
    this.child,
    this.defaultValue,
    Key key}): super(key:key);

  @override
  _EsonConsumerState createState() => _EsonConsumerState<T>();
}

class _EsonConsumerState<T> extends State<EsonConsumer<T>> {



  @override
  Widget build(BuildContext context) {
    this.initWatcher(context); /// 首次build时初始化

    T value = this.widget.eson.get(this.widget.path, defaultValue: this.widget.defaultValue);
    return this.widget.builder(context, value, this.widget.eson, this.widget.child);
  }

  initWatcher(BuildContext context){
    if(this.widget.isInitWatcher == true){
      return;
    }
    this.widget.isInitWatcher = true;

    /// 未传入eson对象，向上查找
    if(this.widget.eson == null){
      EsonProvider provider = context.findAncestorWidgetOfExactType<EsonProvider>();
      this.widget.eson = provider.eson;
    }

    assert(
      this.widget.eson != null,
      "EsonConsumer is not wrapped in EsonProvider, and no eson instance is passed in"
    );

    /// 注册监听者
    this.widget.eson.watch({
      this.widget.path: (value, oldValue){
        setState(() {});
      },
    }, this);

  }


  @override
  void dispose() {
    super.dispose();
    /// 注销监听者
    if(this.widget.eson != null){
      this.widget.eson.removeWatch(this);
    }
  }

}
