import 'package:flutter_kakao_map_sample/src/model/lat_lng.dart';

class Marker {
  final String markerId;
  final LatLng latLng;
  String? markerImageSrc;
  int? width;
  int? height;
  int? offsetX;
  int? offsetY;
  String? infoWindowText;

  Marker({required this.markerId, required this.latLng, this.markerImageSrc, this.width, this.height, this.offsetX, this.offsetY, this.infoWindowText});
}