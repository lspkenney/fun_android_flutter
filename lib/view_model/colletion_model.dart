import 'package:flutter/material.dart';
import 'package:wan_android/config/net/api.dart';
import 'package:wan_android/model/article.dart';
import 'package:wan_android/provider/base_list_model.dart';
import 'package:wan_android/provider/base_model.dart';
import 'package:wan_android/service/wan_android_repository.dart';

class CollectionListModel extends BaseListModel {
  @override
  Future<List> loadData(int pageNum) async {
    return await WanAndroidRepository.fetchCollectList(pageNum);
  }
}

class CollectionModel extends BaseModel {
  final Article article;

  CollectionModel(this.article);

  collect() async {
    setBusy(true);
    try {
      await Future.delayed(Duration(seconds: 1));
      // article.collect 字段为null,代表是从我的收藏页面进入的 需要调用特殊的取消接口
      if (article.collect == null) {
        await WanAndroidRepository.unMyCollect(
            id: article.id, originId: article.originId);
      } else {
        if (article.collect) {
          await WanAndroidRepository.unCollect(article.id);
        } else {
          await WanAndroidRepository.collect(article.id);
        }
      }
      article.collect = !(article.collect ?? true);
      setBusy(false);
    } on DioError catch (e) {
      if (e.error is UnAuthorizedException) {
        setUnAuthorized();
      } else {
        debugPrint(e.toString());
        setError(e.toString());
      }
    } catch (e) {
      print(e.toString());
      setError(e.toString());
    }
  }
}
