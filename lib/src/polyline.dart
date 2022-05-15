import 'package:flutter/material.dart';
import 'package:flutter_kakao_map_sample/src/base_draw.dart';
import 'package:flutter_kakao_map_sample/src/model/lat_lng.dart';

class Polyline extends BaseDraw {
  final String polylineId;
  final List<LatLng> points;

  // Polyline({
  //   required this.polylineId,
  //   required this.points,
  //   super.strokeWidth,
  //   super.strokeColor,
  //   super.strokeOpacity,
  //   super.strokeStyle,
  //   super.fillColor,
  //   super.fillOpacity,
  // });

  Polyline({
    required this.polylineId,
    required this.points,
    int? strokeWidth,
    Color? strokeColor,
    double? strokeOpacity,
    String? strokeStyle,
    Color? fillColor,
    double? fillOpacity,
  }) {
    this.strokeWidth = strokeWidth;
    this.strokeColor = strokeColor;
    this.strokeOpacity = strokeOpacity;
    this.strokeStyle = strokeStyle;
    this.fillColor = fillColor;
    this.fillOpacity = fillOpacity;
  }
}
