import 'package:flutter/material.dart';
import 'package:flutter_kakao_map_sample/src/base_draw.dart';
import 'package:flutter_kakao_map_sample/src/model/lat_lng.dart';

class Polygon extends BaseDraw {
  final String polygonId;
  final List<LatLng> points;
  final List<List<LatLng>>? holes;

  Polygon({
    required this.polygonId,
    required this.points,
    this.holes,
    super.strokeWidth,
    super.strokeColor,
    super.strokeOpacity,
    super.strokeStyle,
    super.fillColor,
    super.fillOpacity,
  });
}
