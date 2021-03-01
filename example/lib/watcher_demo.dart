import 'package:eson/eson.dart';
import 'package:flutter/material.dart';

class WatcherDemo extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _WatcherDemoState();

}

class _WatcherDemoState extends State<WatcherDemo>{

  /// Eson 适合作为单个组件的所有数据状态管理
  /// Eson is suitable for all data state management as a single component
  final Eson data = Eson({
      "name": "fenger",
      "age": 28,
      "address": {
        "country": "China",
        "city": "Beijing"
      },
      "companys": [{
        "name": "Alibaba Group",
        "shares": "2%"
      }, {
        "name": "Tencent Group",
        "shares": "3%"
      }]
    },

    /// 对于本组件内要监听修改的数据节点，可以直接在初始化eson时定义
    /// For the data node to be monitored and modified in this component, it can be defined directly when initializing eson
    watch: {

      /// path为key，值为监听回调，当更新的值变化时会调用回调，如更新的值无变化则不会调用回调
      /// The path is the key, and the value is the listener callback. When the updated value changes, the callback will be called. If the updated value has not changed, the callback will not be called
      "companys[0].shares" : (dynamic value, dynamic oldValue){
        print("one --- watch「companys[0].shares」update, new value：${value}, old value:${oldValue}");
      },

    }

  );

  @override
  void initState() {
    super.initState();

    /// 调用更新数据，初始化的时候监听了该数据，所以会打印
    /// Call to update the data, the data is monitored during initialization, so it will print
    this.data.set("companys[0].shares", "3%");

    /// 除了在初始化时监听，也可以在任意时候添加监听
    /// In addition to monitoring during initialization, you can also add monitoring at any time
    this.data.watch({

      "companys[0].shares" : (dynamic value, dynamic oldValue){
        print("two --- watch「companys[0].shares」update, new value：${value}, old value:${oldValue}");
      },

      /// 按钮点击时会触发监听，然后监听里调用了更新，所以界面的age会更新
      /// When the button is clicked, the monitoring is triggered, and then the update is called in the monitoring, so the age of the interface will be updated
      "age"  : (dynamic value, dynamic oldValue){
        setState(() {});
      },

    }, this);


  }

  @override
  void dispose() {
    super.dispose();

    /// 组件销毁时，记得取消监听
    /// When the component is destroyed, remember to cancel the monitoring
    this.data.removeWatch(this);
  }


  @override
  Widget build(BuildContext context) {

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.album),
            title: Text("WatcherDemo"),
            subtitle: Text("The watcher monitors the changes of the data, the granularity is to a single variable"),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("age: ${this.data.get("age")}"),

              RaisedButton.icon(
                  onPressed: (){

                    /// 点击按钮时更新数据，会触发到监听的地方，所以会更新界面
                    /// When you click the button to update the data, it will trigger to the monitoring place, so the interface will be updated
                    this.data.set("age", this.data.get("age")+1);

                  },
                  icon: Icon(Icons.add, size: 20, color: Colors.blue,),
                  label: Text("add age")
              ),
            ],
          )
        ],
      ),
    );
  }

}