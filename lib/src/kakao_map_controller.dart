import 'dart:convert';

import 'package:flutter_kakao_map_sample/src/circle.dart';
import 'package:flutter_kakao_map_sample/src/hex_color.dart';
import 'package:flutter_kakao_map_sample/src/marker.dart';
import 'package:flutter_kakao_map_sample/src/model/lat_lng.dart';
import 'package:flutter_kakao_map_sample/src/polygon.dart';
import 'package:flutter_kakao_map_sample/src/polyline.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMapController {
  final WebViewController _webViewController;

  WebViewController get webViewController => _webViewController;

  KakaoMapController(this._webViewController);

  addPolyline({Set<Polyline>? polylines}) async {
    if (polylines != null) {
      clearPolyline();
      for (var polyline in polylines) {
        await _webViewController.runJavascriptReturningResult(
            "addPolyline('${polyline.polylineId}', '${jsonEncode(polyline.points)}', '${polyline.strokeColor?.toHexColor()}', '${polyline.strokeOpacity}', '${polyline.strokeWidth}');");
      }
    }
  }

  addCircle({Set<Circle>? circles}) async {
    if (circles != null) {
      clearCircle();
      for (var circle in circles) {
        await _webViewController.runJavascript(
            "addCircle('${circle.circleId}', '${jsonEncode(circle.center)}', '${circle.radius}', '${circle.strokeWidth}', '${circle.strokeColor?.toHexColor()}', '${circle.strokeOpacity}');");
      }
    }
  }

  addPolygon({Set<Polygon>? polygons}) async {
    if (polygons != null) {
      clearPolygon();
      for (var polygon in polygons) {
        await _webViewController.runJavascript(
            "addPolygon('${polygon.polygonId}', '${jsonEncode(polygon.points)}', '${jsonEncode(polygon.holes)}', '${polygon.strokeWidth}', '${polygon.strokeColor?.toHexColor()}', '${polygon
                .strokeOpacity}', '${polygon.strokeStyle}', '${polygon.fillColor?.toHexColor()}', '${polygon.fillOpacity}');");
      }
    }
  }

  addMarker({List<Marker>? markers}) async {
    if (markers != null) {
      clearMarker();
      for (var marker in markers) {
        await _webViewController.runJavascript(
            "addMarker('${marker.markerId}', '${jsonEncode(marker.latLng)}', '${marker.markerImageSrc}', '${marker.width}', '${marker.height}', '${marker.offsetX}', '${marker.offsetY}', '${marker
                .infoWindowText}')");
      }
    }
  }

  clear() {
    _webViewController.runJavascript('clear();');
  }

  clearPolyline() {
    _webViewController.runJavascript('clearPolyline();');
  }

  clearCircle() {
    _webViewController.runJavascript('clearCircle();');
  }

  clearPolygon() {
    _webViewController.runJavascript('clearPolygon();');
  }

  clearMarker() {
    _webViewController.runJavascript('clearMarker();');
  }

  fitBounds(List<LatLng> points) async {
    await _webViewController.runJavascript("fitBounds('${jsonEncode(points)}');");
  }
}
