import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_flutter/pages/home/floor.dart';
import 'package:learn_flutter/pages/home/header.dart';
import 'package:learn_flutter/pages/home/item_list.dart';
import 'package:learn_flutter/pages/home/swipper_image.dart';
import 'package:learn_flutter/utils/request_util.dart';
import 'package:learn_flutter/bean/floor/floor_model_entity.dart';
import 'package:learn_flutter/bean/entity_factory.dart';
import 'package:learn_flutter/api/api.dart';
import 'ad.dart';
import 'item.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  List<FloorModelResultContentData> floorList = [];

  @override
  initState() {
    super.initState();
    this.getFloorList();
    this.getInitData();
  }

  getFloorList() async {
    print(Api.appCenterInfo);
    var response = await RequestUtil.getInstance().post(Api.appCenterInfo);
    this.setState(() {
      var res = EntityFactory.generateOBJ<FloorModelEntity>(response.data);
      floorList = res.result.content.data;
    });
  }

  /// 获取初始化数据
  getInitData() async {
    var response = await RequestUtil.getInstance().post(Api.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(''),
        // ),
        body: Column(
          children: <Widget>[
            Container(
              height: 48,
              color: Colors.red,
            ),
            Header(),
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        SwipperImage(),
                        // Image.network('https://m.360buyimg.com/mobilecms/s1125x939_jfs/t1/57927/10/5246/102061/5d2ef10bEf2debf2e/93d987f05fa960ea.jpg.dpg.webp'),
                        Container(
                          height: 145,
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Floor(
                                floorList: floorList.length >= 10
                                    ? floorList.getRange(0, 10)?.toList()
                                    : [],
                              ),
                              Floor(
                                floorList: floorList.length >= 20
                                    ? floorList.getRange(10, 20)?.toList()
                                    : [],
                              ),
                            ],
                          ),
                        ),
                        Ad(
                          bgImage:
                              'https://m.360buyimg.com/mobilecms/jfs/t1/55537/13/5336/79992/5d2eeea7E5b9166b0/57bda184a914540a.jpg!q70.jpg.dpg.webp',
                          jumpUrl:
                              'https://pro.m.jd.com/mall/active/EenpY3YPwqzMVxgzmvrmiPxXZfD/index.html',
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    sliver: SliverGrid(
                      //Grid
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //Grid按两列显示
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        // childAspectRatio: 4.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          //创建子widget
                          return Item();
                        },
                        childCount: 30,
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Fluttertoast.showToast(
              msg: 'you click me',
            );
          },
          child: Center(
            child: Icon(Icons.add),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: (event) {
            this.setState(() {
              currentIndex = event;
            });
          },
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('首页'),
              activeIcon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              title: Text('分类'),
              activeIcon: Icon(Icons.view_quilt),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.near_me),
              title: Text('发现'),
              activeIcon: Icon(Icons.navigation),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('购物车'),
              activeIcon: Icon(Icons.shopping_cart),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text(
                '我的',
              ),
              activeIcon: Icon(Icons.face),
            ),
          ],
        ));
  }
}