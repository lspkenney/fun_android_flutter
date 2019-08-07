import 'package:wan_android/config/net/http.dart';
import 'package:wan_android/model/article.dart';
import 'package:wan_android/model/banner.dart';
import 'package:wan_android/model/search.dart';
import 'package:wan_android/model/tree.dart';
import 'package:wan_android/model/user.dart';

class WanAndroidRepository {
  // 轮播
  static Future fetchBanners() async {
    var response = await http.get('banner/json');
    return response.data
        .map<Banner>((item) => Banner.fromJsonMap(item))
        .toList();
  }

  // 置顶文章
  static Future fetchTopArticles() async {
    var response = await http.get('article/top/json');
    return response.data
        .map<Article>((item) => Article.fromMap(item))
        .toList();
  }

  // 文章
  static Future fetchArticles(int pageNum, {int cid}) async {
    var response = await http.get('article/list/$pageNum/json',
        queryParameters: (cid != null ? {'cid': cid} : null));
    return response.data['datas']
        .map<Article>((item) => Article.fromMap(item))
        .toList();
  }

  // 项目分类
  static Future fetchTreeCategories() async {
    var response = await http.get('tree/json');
    return response.data.map<Tree>((item) => Tree.fromJsonMap(item)).toList();
  }

  // 体系分类
  static Future fetchProjectCategories() async {
    var response = await http.get('project/tree/json');
    return response.data.map<Tree>((item) => Tree.fromJsonMap(item)).toList();
  }

  // 搜索热门记录
  static Future fetchSearchHotKey() async {
    var response = await http.get('hotkey/json');
    return response.data
        .map<SearchHotKey>((item) => SearchHotKey.fromJsonMap(item))
        .toList();
  }

  // 搜索结果
  static Future fetchSearchResult({key = "", int pageNum = 0}) async {
    var response =
        await http.post<Map>('article/query/$pageNum/json', queryParameters: {
      'k': key,
    });
    return response.data['datas']
        .map<Article>((item) => Article.fromMap(item))
        .toList();
  }

  /// 登录
  /// [Http.init] 添加了拦截器 设置了自动cookie.
  static Future login(String username, String password) async {
    var response = await http.post<Map>('user/login', queryParameters: {
      'username': username,
      'password': password,
    });
    return User.fromJsonMap(response.data);
  }

  /// 登出
  static Future logout() async {
    /// 自动移除cookie
    await http.get('user/logout/json');
  }

  static testLoginState() async {
    var response1 = await http.get('lg/todo/listnotdo/0/json/1');
  }


  // 收藏列表
  static Future fetchCollectList(int pageNum ) async {
    var response = await http.get<Map>('lg/collect/list/$pageNum/json');
    return response.data['datas']
        .map<Article>((item) => Article.fromMap(item))
        .toList();
  }

  // 收藏
  static Future collect(id) async {
    var response = await http.post('lg/collect/$id/json');
    return response;
  }
  // 取消收藏
  static Future unCollect(id) async {
    var response = await http.post('lg/uncollect_originId/$id/json');
    return response;
  }
  // 取消收藏2
  static Future unMyCollect({id,originId}) async {
    var response = await http.post('lg/uncollect/$id/json',queryParameters: {
      'originId':originId??-1
    });
    return response;
  }
}
