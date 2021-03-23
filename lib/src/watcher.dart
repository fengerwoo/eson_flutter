import 'package:eson/eson.dart';

class Watcher{

  Map<String, List<Map<String, dynamic>>> _watch = {};
  Eson _eson; // eson 对象

  Watcher(Eson eson){
    this._eson = eson;
  }

  /// 添加监听数据变化
  void watch(Map<String, PathDataWatcher> watch, Object target){
    if(watch == null || target == null){
      throw Exception("The watcher Map and target cannot be empty!");
    }

    watch.forEach((String path, PathDataWatcher callback) {
      // 如果不存在监听该path的，先创建
      if(this._watch[path] == null){
        this._watch[path] = [];
      }

      this._watch[path].add({
        "callback": callback,
        "target": target,
      });
    });
  }

  /// 移除该监听者所有的监听（不传variablePath会全部移除）
  void removeWatch(Object target, {String variablePath = null}){
    this._watch.forEach((String path, List list) {
      list.removeWhere((watch){
        return watch['target'] == target && (path == variablePath || variablePath == null);
      });
    });
  }

  /// 提交更新
  /// 更新节点path，影响的变量path，新数据索引
  void commitUpdate(String updatePath, Map<String, dynamic> oldPathIndex, Map<String, dynamic> newPathIndex){
    newPathIndex.forEach((path, nodeData) { // 遍历所有的path
      if(this._watch[path] != null && path.startsWith(updatePath)){ // 只影响 存在监听列表 并且 属于updatePath及其以下的 path
         List watchList = this._watch[path];
         watchList.forEach((watch) { // 遍历回调给所有监听
           PathDataWatcher callback = watch['callback'];

           // 获取旧数据，如果path原本不存在则为null
           dynamic nodeOldData = oldPathIndex[path];
           dynamic oldData = nodeOldData != null ? nodeOldData['value'] : null;

           dynamic newData = nodeData['value'];

           if(oldData != newData){ //有变化才更新
             callback(newData, oldData);
           }

         });
      }
    });
  }

}

/// 路径数据监听者回调
typedef PathDataWatcher = Function(dynamic value, dynamic oldValue);