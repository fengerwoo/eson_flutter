import 'package:flutter_test/flutter_test.dart';

import 'package:eson/eson.dart';

void main() {
  test('Basic use of json parsing', () {

    // String parsing
    Eson e1 = Eson('{"name":"枫儿", "arms": ["gun", "sword"]}');

    // Map or List parsing
    Eson e2 = Eson({"name":"枫儿", "arms": [ {"name":"gun"}, {"name":"sword"}]});
    Eson e3 = Eson(["gun", "sword"]);

    e2.set("arms[0].name", "23");




    Eson ret = Eson('{"name":"枫儿", "arms": [ {"name":"gun"}, {"name":"sword"}]}'); // 创建解析结果对象 ret
    String name = ret.get<String>("arms[0].name"); // 直接调用ret的get方法，传入json路径，就获取到对应数据了



    expect(e1.get("name"), "枫儿");
    expect(e2.get("arms[1].name"), "sword");
    expect(e3.get("[0]"), "gun");

  });
}
