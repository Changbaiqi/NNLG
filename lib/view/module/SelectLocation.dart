import 'dart:collection';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';

import 'LocationSearch.dart';




class SelectLocation extends StatefulWidget {
  const SelectLocation({Key? key}) : super(key: key);

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {

  //用于获取所有相关位置的JSON
   getPoi(String localName) async {
    //AMapPoi
    await LocationSearch().searchLocation(localName).then((value){

      searchList(value as LinkedHashMap<String,dynamic>);
    });
  }
  //用来记录输入框输入的内容
  String inputstr="";
   //用于记录地图上面的标记点
   Map<String,Marker> _makers = <String,Marker>{};
   String _loacalText = "";
   //添加标记点
   void _addMarker(double x, double y){
     final _markerPosition = LatLng(x, y);
     final Marker marker = Marker(position: _markerPosition,
     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange));

     setState((){
       _makers.clear();
       _makers[marker.id] =  marker;
     });

   }

  @override
  Widget build(BuildContext context) {

    final AMapWidget map = AMapWidget(
      privacyStatement: AMapPrivacyStatement(hasContains: true,hasShow: true,hasAgree: true),
      onMapCreated: onMapCreated,
      scaleEnabled: false,
      markers: Set<Marker>.of(_makers.values),
      myLocationStyleOptions: MyLocationStyleOptions(true),
      initialCameraPosition: const CameraPosition(target: LatLng(39.909187, 116.397451), zoom: 17),
      onTap: this._onMapTap,
      onCameraMove: this._onCameraMove,
      onPoiTouched: this._onMapPoiTouched,
      //onLocationChanged: this._onLocationChanged,
      //onLongPress: this._onMapLongPress,
    );



    return Scaffold(
      body: Stack(
        children: [
          Positioned(child: map),
          searchWidget()
        ],
      ),
    );
  }




//地图的控制就靠这个辣
  late AMapController _mapController;
  void onMapCreated(AMapController controller){
    setState((){
      _mapController = controller;
    });
  }

  //地图视角移动触发
  void _onCameraMove(CameraPosition cameraPosition) {
    if(this.searchListSW == true)
      setState((){
        this.searchListSW = false;
      });
    print('地图视角移动');
  }

  //地图poi点击触发
  void _onMapPoiTouched(AMapPoi poi) {
    if(this.searchListSW == true)
      setState((){
        this.searchListSW = false;
      });
    double x = poi.latLng?.toJson()[0];
    double y = poi.latLng?.toJson()[1];
    this._addMarker(x, y);
    this._moveCamera(x, y);

    //逆地理编码获取位置
    LocationSearch().getLocationText(y, x).then((value){
      this._loacalText = LocationSearch.toLocalText(value);
    });

  }

  void _onMapLongPress(LatLng latLng) {
    if(this.searchListSW == true)
      setState((){
        this.searchListSW = false;
      });
    print('长按地图');
  }

  //地图位置移动触发
  void _onLocationChanged(AMapLocation location) {
    if(this.searchListSW == true)
      setState((){
        this.searchListSW = false;
      });
    //print('地图位置移动');
  }

  //地图点击的效果
  void _onMapTap(LatLng latLng){
    if(this.searchListSW == true)
    setState((){
      this.searchListSW = false;
    });
    double x = latLng.toJson()[0];
    double y = latLng.toJson()[1];
    this._addMarker(x, y);
    this._moveCamera(x, y);

    //逆地理编码获取位置
    LocationSearch().getLocationText(y, x).then((value){
      this._loacalText = LocationSearch.toLocalText(value);
    });

  }


  //用于移动地图视角到指定位置
  void _moveCamera(double x , double y){
    _mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(x,y),
      zoom: 17,
      tilt: 0,
      bearing: 0
    )));
  }





  List<Widget> _approvalNumberWidget = [];
  //获取审图号
  /*void getApprovalNumber() async {
    //普通地图审图号
    String? mapContentApprovalNumber =
    await _mapController.getMapContentApprovalNumber();
    //卫星地图审图号
    String? satelliteImageApprovalNumber =
    await _mapController.getSatelliteImageApprovalNumber();
    setState((){
      if(null != mapContentApprovalNumber){
        _approvalNumberWidget.add(Text(mapContentApprovalNumber));
      }
      if(null != satelliteImageApprovalNumber){
        _approvalNumberWidget.add(Text(satelliteImageApprovalNumber));
      }
    });
    print('地图审图号（普通地图）：$mapContentApprovalNumber');
    print('地图审图号（卫星地图）：$satelliteImageApprovalNumber');
  }*/



//用于存储所有待展示的结果
  List<Widget> searchlist = [];
  //用于控制是否展示搜索的列表
  bool searchListSW = false;
  //搜索控件
  Widget searchWidget(){

    return Positioned(
        top: 35,
        left: 10,
        right: 10,
        child: Card(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child:  TextField(
                            decoration: InputDecoration(
                                icon: Icon(Icons.search),
                                hintText: '请输入要查找的地方名',
                                border: InputBorder.none
                            ),
                            onChanged: (v){
                              //print('测试');
                              this.inputstr=v;
                            },
                          )),
                      Expanded(
                          flex: 1,
                          child: MaterialButton(
                            child: Text('搜索'),
                            onPressed: () {
                              setState((){
                                //this._addMarker();
                                this.searchListSW = false;
                              });
                              getPoi(this.inputstr);
                            },
                          ))
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  child: Text('确认'),
                  onPressed: (){

                    List local = [this._loacalText,Set<Marker>.of(_makers.values).first.position.longitude/*获取x坐标*/,Set<Marker>.of(_makers.values).first.position.latitude/*获取y坐标*/];
                    //ToastUtil().show(local.toString());
                    Navigator.pop(context, local);
                  },
                ),
              ),
              Visibility(
                visible: this.searchListSW,
                  child: Column(
                children: [
                  Container(
                    height: 500,
                    child: ListView(
                      children: searchlist,
                    ),
                  )
                ],
              ))

            ],
          ),
        ));


  }

  //搜索列表的展示子选项
  Widget searchChildCard(String name,String address, String pname,String cityname, location){
    return Card(
      child: InkWell(
        child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${name}',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              Text('地址：${address}'),
              Text('所属省份：${pname}'),
              Text('所在城市：${cityname}'),
              Text('经纬度：${location}')
            ],
          ),),
        onTap: () async {
          List<String> local = location.toString().split(',');
          this._moveCamera(double.parse(local[1]), double.parse(local[0]));
          this._addMarker(double.parse(local[1]), double.parse(local[0]));


          //逆地理编码获取位置
          await LocationSearch().getLocationText(double.parse(local[0]), double.parse(local[1])).then((value){
            //ToastUtil().show('${value}');
            this._loacalText = LocationSearch.toLocalText(value);
            //ToastUtil().show('${LocationSearch.toLocalText(value)}');
          });

        },
      ),
    );
  }

//用于处理搜索的列表结果
  searchList(LinkedHashMap<String,dynamic> list){
    List localList = list['pois'];
    print(localList[0]);

    setState((){
      List<Widget> nowList = [];
      this.searchlist.clear();
      localList.forEach((element) {
        nowList.add(searchChildCard('${element['name']}','${element['address']}', '${element['pname']}', '${element['cityname']}', '${element['location']}'));
      });
      this.searchlist= nowList;
      this.searchListSW = true;
    });
  }









}
