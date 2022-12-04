import 'package:flutter_kakao_map_sample/src/kakao_map_controller.dart';
import 'package:flutter_kakao_map_sample/src/model/lat_lng.dart';

typedef MapCreateCallback = void Function(KakaoMapController controller);

//typedef void CameraPositionCallback(CameraPosition position);

//typedef void OnMarkerTab(Marker? marker, Map<String, int?> iconSize);

typedef OnMapTap = void Function(LatLng latLng);

typedef OnMapDoubleTap = void Function(LatLng latLng);

//typedef void OnMapLongTap(LatLng latLng);
//
//typedef void OnMapDoubleTap(LatLng latLng);
//
//typedef void OnMapTwoFingerTap(LatLng latLng);
//
// typedef void OnCameraChange(LatLng? latLng, CameraChangeReason reason, bool? isAnimated);

typedef OnCameraIdle = void Function(LatLng latLng, int zoomLevel);

typedef OnZoomChanged = void Function(int zoomLevel);

//typedef void OnSymbolTap(LatLng? position, String? caption);
//
//typedef void OnPathOverlayTab(PathOverlayId pathOverlayId);
