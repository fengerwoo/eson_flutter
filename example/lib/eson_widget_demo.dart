import 'package:eson/eson.dart';
import 'package:flutter/material.dart';

class EsonWidgetDemo extends StatefulWidget {
  @override
  _EsonWidgetDemoState createState() => _EsonWidgetDemoState();
}

class _EsonWidgetDemoState extends State<EsonWidgetDemo> {

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
      "shares": 2
    }, {
      "name": "Tencent Group",
      "shares": 3
    }]
  });


  @override
  Widget build(BuildContext context) {

    /// Eson的局部刷新和Provider的使用方式类似，用EsonProvider包裹住EsonConsumer，
    /// 当EsonProvider的eson数据刷新时会重新调用EsonConsumer的builder
    /// EsonConsumer也可以指定eson实例，这样就不会向上查找EsonProvider
    ///
    /// The partial refresh of Eson is similar to the way of using Provider. The EsonConsumer is wrapped with EsonProvider.
    /// When the eson data of EsonProvider is refreshed, the builder of EsonConsumer will be called again.
    /// EsonConsumer can also specify an eson instance, so that EsonProvider will not be searched upwards
    ///
    return EsonProvider(
        eson: this.data, /// EsonProvider must be passed in eson
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.album),
                title: Text("EsonWidgetDemo"),
                subtitle: Text("Use Eson for partial refresh in Widget"),
              ),

              DataTable(
                columns: [
                  DataColumn(label: Text('Alibaba shares')),
                  DataColumn(label: Text('Tencent shares')),
                ],
                rows: [
                  DataRow(cells: [

                    DataCell(

                        /// 在需要局部刷新的地方定义EsonConsumer，必须传入builder
                        /// 可选传入path，默认绑定eson数据根节点，强烈建议传入
                        /// 可选传入eson实例 可指定eson实例（指定后不再向上查找EsonProvider）
                        /// 可选传入defaultValue，设置获取为空时候默认值
                        /// 可选传入 child ，复用子组件减少不必要的性能消耗
                        ///
                        /// Define EsonConsumer where partial refresh is needed, and builder must be passed in
                        /// Optional input path, the root node of eson data is bound by default, it is strongly recommended to pass in
                        /// Optional incoming eson instance can be specified eson instance (no longer look up EsonProvider after designation)
                        /// Optional input defaultValue, set the default value when the get is empty
                        /// Optional pass in child, reuse sub-components to reduce unnecessary performance consumption
                        EsonConsumer<String>(
                            path: "companys[0].shares",
                            defaultValue:  "",
                            builder: (BuildContext context, String value, Eson eson, Widget child){
                              return Text("${value}%");
                            }
                        )),

                    DataCell(
                        EsonConsumer<int>(
                            path: "companys[1].shares",
                            defaultValue: 0,
                            builder: (BuildContext context, int value, Eson eson, Widget child){
                              return Text("${value}%");
                            }
                        )),
                      // EsonConsumer(builder: null)
                  ])
                ],
              ),

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          RaisedButton.icon(
                              onPressed: (){

                                /// 更新eson实例数据，会触发绑定了该eson实例EsonProvider下对应EsonConsumer的builder更新
                                /// Updating the data of the eson instance will trigger the update of the builder that is bound to the corresponding EsonConsumer under the Eson Provider of the eson instance
                                this.data.set("companys[0].shares", this.data.get("companys[0].shares") + 1);
                              },
                              icon: Icon(Icons.add, color: Colors.red,),
                              label: Text("add", style: TextStyle(color: Colors.red),)),
                          RaisedButton.icon(
                              onPressed: (){
                                this.data.set("companys[0].shares", this.data.get("companys[0].shares") - 1);
                              },
                              icon: Icon(Icons.horizontal_rule, color: Colors.green,),
                              label: Text("less", style: TextStyle(color: Colors.green),)),
                        ],
                      ),
                    ),


                    Container(
                      child: Column(
                        children: [
                          RaisedButton.icon(
                              onPressed: (){
                                this.data.set("companys[1].shares", this.data.get("companys[1].shares") + 1);
                              },
                              icon: Icon(Icons.add, color: Colors.red,),
                              label: Text("add", style: TextStyle(color: Colors.red),)),
                          RaisedButton.icon(
                              onPressed: (){
                                this.data.set("companys[1].shares", this.data.get("companys[1].shares") - 1);
                              },
                              icon: Icon(Icons.horizontal_rule, color: Colors.green,),
                              label: Text("less", style: TextStyle(color: Colors.green),)),
                        ],
                      ),
                    )

                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
                child: Column(
                  children: [

                    EsonConsumer(
                        builder: (BuildContext context, dynamic value, Eson eson, Widget child){
                          return Text("${eson.toString()}");
                        }
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
    );
  }
}
