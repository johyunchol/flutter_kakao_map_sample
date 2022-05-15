import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_kakao_map_sample/src/circle.dart';
import 'package:flutter_kakao_map_sample/src/hex_color.dart';
import 'package:flutter_kakao_map_sample/src/kakao_map_controller.dart';
import 'package:flutter_kakao_map_sample/src/kakao_map.dart';
import 'package:flutter_kakao_map_sample/src/marker.dart';
import 'package:flutter_kakao_map_sample/src/model/lat_lng.dart';
import 'package:flutter_kakao_map_sample/src/polygon.dart';
import 'package:flutter_kakao_map_sample/src/polyline.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  KakaoMapController? _kakaoMapController;

  Set<Polyline> polylines = {};
  Set<Circle> circles = {};
  Set<Polygon> polygons = {};
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          KakaoMap(
            onMapCreated: (KakaoMapController controller) {
              _kakaoMapController = controller;
            },
            onMapTap: (LatLng latLng) {
              print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
              print("${jsonEncode(latLng)}");
              print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            },
            onCameraIdle: (LatLng latLng, int zoomLevel) {
              print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
              print("${jsonEncode(latLng)}");
              print("zoomLevel : $zoomLevel");
              print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            },
            onZoomChanged: (int zoomLevel) {
              print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
              print("zoomLevel : $zoomLevel");
              print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            },
            polylines: polylines,
            circles: circles,
            polygons: polygons,
            markers: markers.toList(),
          ),
          Positioned(
            bottom: 0,
            child: SafeArea(
              child: Row(
                children: [
                  ElevatedButton(
                    child: const Text('직선'),
                    onPressed: () async {
                      _clear();

                      List<LatLng> list = [LatLng(37.3625806, 126.9248464), LatLng(37.3626138, 126.9264801), LatLng(37.3632727, 126.9280313)];
                      List<LatLng> list2 = [LatLng(37.3616144, 126.9250364), LatLng(37.3614955, 126.9286686), LatLng(37.3608681, 126.9306506), LatLng(37.3594222, 126.9280014)];

                      setState(() {
                        polylines.add(Polyline(polylineId: "1", points: list, strokeColor: Colors.red, strokeOpacity: 0.7, strokeWidth: 8));
                        polylines.add(Polyline(polylineId: "2", points: list2, strokeColor: Colors.blue, strokeOpacity: 1, strokeWidth: 4));

                        fitBounds([...list, ...list2]);
                      });


                    },
                  ),
                  ElevatedButton(
                    child: const Text('원'),
                    onPressed: () {
                      LatLng center = LatLng(37.3616144, 126.9250364);
                      setState(() {
                        circles.add(Circle(circleId: "3", center: center, radius: 44, strokeColor: Colors.amber, strokeOpacity: 1, strokeWidth: 4));

                        fitBounds([center]);
                      });
                    },
                  ),
                  ElevatedButton(
                    child: const Text('다각형'),
                    onPressed: () async {
                      _clear();

                      List<LatLng> list = [LatLng(37.3625806, 126.9248464), LatLng(37.3626138, 126.9264801), LatLng(37.3632727, 126.9280313)];
                      List<LatLng> list2 = [LatLng(37.3616144, 126.9250364), LatLng(37.3614955, 126.9286686), LatLng(37.3608681, 126.9306506), LatLng(37.3594222, 126.9280014)];

                      setState(() {
                        polygons.add(Polygon(polygonId: "4", points: list, strokeWidth: 4, strokeColor: Colors.blue, strokeOpacity: 1, fillColor: Colors.transparent, fillOpacity: 0));
                        polygons.add(Polygon(polygonId: "5", points: list2, strokeWidth: 4, strokeColor: Colors.blue, strokeOpacity: 1, fillColor: Colors.transparent, fillOpacity: 0));

                        fitBounds([...list, ...list2]);
                      });
                    },
                  ),
                  ElevatedButton(
                    child: const Text('다각형-반전'),
                    onPressed: () async {
                      _clear();

                      List<LatLng> list = [LatLng(37.3625806, 126.9248464), LatLng(37.3626138, 126.9264801), LatLng(37.3632727, 126.9280313)];
                      List<LatLng> list2 = [LatLng(37.3616144, 126.9250364), LatLng(37.3614955, 126.9286686), LatLng(37.3608681, 126.9306506), LatLng(37.3594222, 126.9280014)];

                      setState(() {
                        polygons.add(Polygon(
                          polygonId: "6",
                          points: createOuterBounds(),
                          holes: [list, list2],
                          strokeWidth: 4,
                          strokeColor: Colors.blue,
                          strokeOpacity: 0.7,
                          fillColor: Colors.black,
                          fillOpacity: 0.5,
                        ));

                        fitBounds([...list, ...list2]);
                      });
                    },
                  ),
                  ElevatedButton(
                    child: const Text('마커'),
                    onPressed: () {
                      _clear();

                      LatLng latLng = LatLng(37.3625806, 126.9248464);
                      LatLng latLng2 = LatLng(37.3605008, 126.9252204);

                      setState(() {
                        markers.add(Marker(markerId: "7", latLng: latLng, markerImageSrc: '/assets/web/marker.png', infoWindowText: 'TEST1'));
                        markers.add(Marker(markerId: "8", latLng: latLng2, markerImageSrc: '/assets/web/marker.png', infoWindowText: 'TEST2'));

                        fitBounds([latLng, latLng2]);
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _clear() {
    _kakaoMapController?.clear();
    polylines.clear();
    circles.clear();
    polygons.clear();
    markers.clear();
  }

  List<LatLng> createOuterBounds() {
    double delta = 0.01;

    List<LatLng> list = [];

    list.add(LatLng(90 - delta, -180 + delta));
    list.add(LatLng(0, -180 + delta));
    list.add(LatLng(-90 + delta, -180 + delta));
    list.add(LatLng(-90 + delta, 0));
    list.add(LatLng(-90 + delta, 180 - delta));
    list.add(LatLng(0, 180 - delta));
    list.add(LatLng(90 - delta, 180 - delta));
    list.add(LatLng(90 - delta, 0));
    list.add(LatLng(90 - delta, -180 + delta));

    return list;
  }

  fitBounds(List<LatLng> bounds) async {
    _kakaoMapController?.fitBounds(bounds);
  }

}
