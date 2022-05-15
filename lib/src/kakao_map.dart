import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kakao_map_sample/src/callbacks.dart';
import 'package:flutter_kakao_map_sample/src/circle.dart';
import 'package:flutter_kakao_map_sample/src/kakao_map_controller.dart';
import 'package:flutter_kakao_map_sample/src/marker.dart';
import 'package:flutter_kakao_map_sample/src/model/lat_lng.dart';
import 'package:flutter_kakao_map_sample/src/polygon.dart';
import 'package:flutter_kakao_map_sample/src/polyline.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMap extends StatefulWidget {
  final MapCreateCallback? onMapCreated;
  final OnMapTap? onMapTap;
  final OnCameraIdle? onCameraIdle;
  final OnZoomChanged? onZoomChanged;

  final Set<Polyline>? polylines;
  final Set<Circle>? circles;
  final Set<Polygon>? polygons;
  final List<Marker>? markers;

  KakaoMap({
    Key? key,
    this.onMapCreated,
    this.onMapTap,
    this.onCameraIdle,
    this.onZoomChanged,
    this.polylines,
    this.circles,
    this.polygons,
    this.markers,
  }) : super(key: key);

  @override
  State<KakaoMap> createState() => _KakaoMapState();
}

class _KakaoMapState extends State<KakaoMap> {
  late final KakaoMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'http://localhost:8080/assets/web/kakaomap.html',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _mapController = KakaoMapController(webViewController);
        if (widget.onMapCreated != null) widget.onMapCreated!(_mapController);
        // _loadHtmlFromAssets();
      },
      javascriptChannels: _channels,
    );
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/web/kakaomap.html');
    await _mapController.webViewController.loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

  @override
  void didUpdateWidget(KakaoMap oldWidget) {
    _mapController.addPolyline(polylines: widget.polylines);
    _mapController.addCircle(circles: widget.circles);
    _mapController.addPolygon(polygons: widget.polygons);
    _mapController.addMarker(markers: widget.markers);
  }

  Set<JavascriptChannel>? get _channels {
    Set<JavascriptChannel>? channels = {};

    channels.add(JavascriptChannel(
        name: 'onMapTap',
        onMessageReceived: (JavascriptMessage result) {
          if (widget.onMapTap != null) widget.onMapTap!(LatLng.fromJson(jsonDecode(result.message)));
        }));

    channels.add(JavascriptChannel(
        name: 'zoomChanged',
        onMessageReceived: (JavascriptMessage result) {
          print("zoomChanged ${result.message}");
          if (widget.onZoomChanged != null) widget.onZoomChanged!(jsonDecode(result.message)['zoomLevel']);
        }));

    channels.add(JavascriptChannel(
        name: 'cameraIdle',
        onMessageReceived: (JavascriptMessage result) {
          print("idle ${result.message}");
          if (widget.onCameraIdle != null) widget.onCameraIdle!(LatLng.fromJson(jsonDecode(result.message)), jsonDecode(result.message)['zoomLevel']);
        }));

    return channels;
  }
}
