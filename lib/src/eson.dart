import 'dart:convert';

import 'package:eson/src/print_log.dart';
import 'package:eson/src/watcher.dart';

/// Elegant JSON，简称Eson，优雅的JSON数据解析
/// Created by 枫儿 on 2020/12/06.
/// @email：hsnndly@163.com
class Eson extends Object{
  dynamic _data; //JSON数据
  Map<String, dynamic> _pathIndex = {}; // 路径索引
  Watcher _watcher; // 本数据观察者


  /// @Desc  : 创建一个解析器，可传入JSON字符串 或者 Map|List
  /// @author: 枫儿
  Eson(dynamic data,
      {Map<String, PathDataWatcher> watch = const {}, }){
    _initData(data);
    _initPathIndex(this._data);
    _watcher = Watcher(this);
    this.watch(watch, this);
  }


  /// @Desc  : 初始化数据
  /// @author: 枫儿
  void _initData(dynamic data){
    // 数据转化为 Map 或 List
    dynamic _data = {}; // 默认数据为空 Map
    if(data is String){ // 如果传入的是字符串格式化
      try{
        _data = json.decode(data);
      }catch(e){  print(e);   }

    }else if(data is Map || data is List){ //如果传入的是Map或List 直接使用
      _data = data;
    }

    this._data = _data;
  }


  /// @Desc  : 初始化路径索引
  /// @author: 枫儿
  void _initPathIndex(dynamic data, {String basePath = ""}){

    forEachItem(key, value, parentType){

      // 计算当前的路径
      String nodeName = parentType == "Map" ? "${key}" : "[${key}]";
      String nodeDelimite = (parentType == "Map" && basePath != "") ? "." : ""; //分隔符
      String path = "${basePath}${nodeDelimite}${nodeName}"; //当前的路径

      //添加到索引
      this._pathIndex[path] = {
        "path": path,
        "parent": this._pathIndex[basePath],
        'parent_type': parentType,
        "key": key,
        "value": value,
      };

      if(value is Map || value is List){ //如果是Map或者List 继续递归
        _initPathIndex(value, basePath: path);
      }
    }

    //当前是root层，清空_pathIndex，设置root层索引
    if(basePath == ""){
      this._pathIndex = {};
      this._pathIndex[""] = {
        "path": "",
        "parent": null,
        'parent_type': null,
        "key": null,
        "value": data,
      };
    }

    // 清空该basePath下已有索引（重建索引，之前的索引也没用了，覆盖不了的只会占空间，遂清空）
    this._pathIndex.removeWhere((key, value) => ( key != basePath && key.startsWith(basePath) ) ); //只删除节点下的索引

    // 遍历Map或者List
    if(data is Map){
      data.forEach((key, value) => forEachItem(key, value, "Map"));
    }else if(data is List){
      for(int i=0;i<data.length;i++){
        forEachItem(i, data[i], "List");
      }
    }

  }


  /// @Desc  : 获取数据
  /// @author: 枫儿
  T get<T>(path, {defaultValue}){
    Map indexItem = this._pathIndex[path];
    if(indexItem != null && indexItem["value"] != null){
      return indexItem["value"];
    }else{
      return defaultValue;
    }
    // return indexItem == null ? defaultValue : indexItem['value'];
  }


  /// @Desc  : 更新数据
  /// @author: 枫儿
  bool set(path, value){
    Map<String, dynamic> oldPathIndex = this._whereStartsWithDeepCopyValue(path);
    if(path == ""){ // 更新总数据
      _initData(value);
      _initPathIndex(this._data);

    }else{ // 更新path数据
      Map indexItem = this._pathIndex[path];
      // if(indexItem != null && (indexItem["value"]!=null && value!=null) && (indexItem["value"].runtimeType.toString() != value.runtimeType.toString())){
      //   print("EsonError: Inconsistent Value types，The original value was ${indexItem["value"].runtimeType.toString()}, now the assignment is ${value.runtimeType.toString()}. path：${path}",);
      //   return false;
      // }
      if(indexItem != null){
        var parentItem = indexItem["parent"];
        // 修改数据
        try{ parentItem['value'][indexItem["key"]] = value; }catch(e){

          String desc = "Inconsistent Value types，The original value was ${indexItem["value"].runtimeType.toString()}, now the assignment is ${value.runtimeType.toString()}.";
          var stack = StackTrace.current.toString();
          var callStack = stack.split("\n")[1];

          PrintLog.e(tag: "------------- Eson Error -------------", msg: " path 「${path}」: $e\n$desc\n$callStack\n\n");

          return false;
        }

        indexItem['value'] = value; // 修改索引数据（Map修改数据索引就更掉了，List不会变化，所以索引也修改一次）

        if(value is Map || value is List){ //如果是Map || List类型，重建此节点下索引
          _initPathIndex(value, basePath: indexItem['path']);
        }
      }else{
        return false;
      }
    }

    _watcher.commitUpdate(path, oldPathIndex, this._pathIndex);
    return true;
  }

  /// 添加监听数据变化
  void watch(Map<String, PathDataWatcher> watch, Object target){
    this._watcher.watch(watch, target);
  }

  /// 移除该监听者所有的监听（不传variablePath会全部移除）
  void removeWatch(Object target, {String variablePath = null}){
    this._watcher.removeWatch(target, variablePath: variablePath);
  }

  /// 筛选以某个path开头的索引，深拷贝值
  Map<String, dynamic> _whereStartsWithDeepCopyValue(String path){
    Map<String, dynamic> data = {};
    this._pathIndex.forEach((key, value) {
      if(path.startsWith(key)){
        data[key] = json.decode(json.encode({
          "path": value['path'],
          "key": value['key'],
          "value": value['value'],
        }));
      }
    });
    return data;
  }

  @override
  String toString() {
    return json.encode(_data);
  }

}


