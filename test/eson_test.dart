import 'package:flutter_test/flutter_test.dart';

import 'package:eson/eson.dart';

void main() {
  test('Basic use of json parsing', () {

    // String parsing
    Eson e1 = Eson('{"name":"枫儿", "arms": ["gun", "sword"]}');

    // Map or List parsing
    Eson e2 = Eson({"name":"枫儿", "arms": [ {"name":"gun"}, {"name":"sword"}]});
    Eson e3 = Eson(["gun", "sword"]);

    expect(e1.get("name"), "枫儿");
    expect(e2.get("arms[1].name"), "sword");
    expect(e3.get("[0]"), "gun");

  });
}
