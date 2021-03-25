import 'package:eson/src/eson_provider.dart';
import 'package:eson/src/print_log.dart';
import 'package:flutter/cupertino.dart';

import '../eson.dart';

class EsonConsumer<T> extends StatefulWidget {

  String callStack = "";
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
    Key key}) : super(key:key) {

    /// 获取使用组件的代码位置
    var stack = StackTrace.current.toString();
    callStack = stack.split("\n")[1];
  }

  @override
  _EsonConsumerState createState() => _EsonConsumerState<T>();
}

class _EsonConsumerState<T> extends State<EsonConsumer<T>> {


  @override
  Widget build(BuildContext context) {
    this.initWatcher(context); /// 首次build时初始化
    return this.widget.builder(context, getValue(), this.widget.eson, this.widget.child);
  }

  T getValue(){
    T value;

    /// 捕获泛型类型不一致异常
    try{
      value = this.widget.eson.get(this.widget.path, defaultValue: this.widget.defaultValue);
    }catch (e, stack) {
      PrintLog.e(tag: "------------- EsonConsumer Error -------------", msg: ' path 「 ${this.widget.path} 」: $e\n ${this.widget.callStack} \n\n');
      /// 默认值不为空，忽略异常走默认值，否则抛出异常
      if(this.widget.defaultValue != null){
        value = this.widget.defaultValue;
      }else{
        throw e;
      }
    }

    return value;
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
