import 'package:eson/eson.dart';
import 'package:flutter/material.dart';

class JsonParseDemo extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _JsonParseDemoState();

}

class _JsonParseDemoState extends State<JsonParseDemo>{


  @override
  Widget build(BuildContext context) {

    /// JSON sample data
    String json = '''
    {
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
    }
    ''';

    /// 创建Eson，您可以传入json字符串，或者已经解析好的List或者Map
    /// Create Eson, you can pass in JSON string or parsed List or Map
    Eson eson = Eson(json);

    /// 获取数据非常简单，您只需要调用get方法，传入json里的路径即可
    /// Obtaining data is very simple, you only need to call the get method and pass in the path in json.
    String name = eson.get("name");

    /// 获取深层的数据
    /// Get deep data
    String city = eson.get("address.city");

    /// 获取数组内的元素
    /// Get an element in the array
    Map alibaba = eson.get("companys[0]");

    /// 获取更深级的数据
    /// Get deeper data
    String tencent_shares = eson.get("companys[1].shares");

    /// 获取不存在的数据也是安全的，默认变量返回null
    /// It is safe to get a value that does not exist, and the default variable returns null
    String tencent_title = eson.get("companys[1].title");

    /// 获取数据为null时，设置返回的默认值
    /// When the get value is null, set the default value returned
    String tencent_title2 = eson.get("companys[1].title", defaultValue: "manager");


    /// 更新数据
    /// update data
    eson.set("companys[1].shares", "6%");

    /// 增加数据
    /// add data
    List companys = eson.get("companys");
    companys.add( { "name": "JD" , "shares": "1%"});
    eson.set("companys[2]", companys);


    String tojson = eson.toString();

    return Card(
      child: Column(
        children: [
            ListTile(
              leading: Icon(Icons.album),
              title: Text("JsonParseDemo"),
              subtitle: Text("Basic pure JSON parsing operation without Model"),
            ),

            DataTable(
                columns: [
                  DataColumn(label: Text('name')),
                  DataColumn(label: Text('city')),
                  DataColumn(label: Text('shares')),
                  DataColumn(label: Text('title2')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text(name)),
                    DataCell(Text(city)),
                    DataCell(Text(tencent_shares)),
                    DataCell(Text(tencent_title2)),
                  ])
                ],
            ),

            Text(tojson),
        ],
      ),
    );
  }

}