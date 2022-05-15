let map = null;
let polylines = [];
let circles = [];
let polygons = [];
let markers = [];

function clearPolyline() {
    for (let i = 0; i < polylines.length; i++) {
        polylines[i].setMap(null);
    }

    polylines = [];
}

function clearCircle() {
    for (let i = 0; i < circles.length; i++) {
        circles[i].setMap(null);
    }

    circles = [];
}

function clearPolygon() {
    for (let i = 0; i < polygons.length; i++) {
        polygons[i].setMap(null);
    }

    polygons = [];
}

function clearMarker() {
    for (let i = 0; i < markers.length; i++) {
        markers[i].setMap(null);
    }

    if (infoWindow != null) infoWindow.close();

    markers = [];
}

function clear() {
    clearPolyline();
    clearCircle();
    clearPolygon();
    clearMarker();
}

function addPolyline(callId, points, color, opacity = 1.0, width = 4) {
    let list = JSON.parse(points);
    let paths = [];
    for (let i = 0; i < list.length; i++) {
        paths.push(new kakao.maps.LatLng(list[i].latitude, list[i].longitude));
    }

    // 지도에 표시할 선을 생성합니다
    let polyline = new kakao.maps.Polyline({
        path: paths, // 선을 구성하는 좌표배열 입니다
        strokeWeight: width, // 선의 두께 입니다
        strokeColor: color, // 선의 색깔입니다
        strokeOpacity: opacity, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
        strokeStyle: 'solid' // 선의 스타일입니다
    });

    polylines.push(polyline);

    // 지도에 선을 표시합니다
    polyline.setMap(map);
}

function addCircle(callId, center, radius, strokeWeight, strokeColor, strokeOpacity = 1, strokeStyle = 'solid', fillColor = '#FFFFFF', fillOpacity = 0) {
    center = JSON.parse(center);

    // 지도에 표시할 원을 생성합니다
    let circle = new kakao.maps.Circle({
        center: new kakao.maps.LatLng(center.latitude, center.longitude),  // 원의 중심좌표 입니다
        radius: radius, // 미터 단위의 원의 반지름입니다
        strokeWeight: strokeWeight, // 선의 두께입니다
        strokeColor: strokeColor, // 선의 색깔입니다
        strokeOpacity: strokeOpacity, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
        strokeStyle: strokeStyle, // 선의 스타일 입니다
        fillColor: fillColor, // 채우기 색깔입니다
        fillOpacity: fillOpacity  // 채우기 불투명도 입니다
    });

    circles.push(circle);

    // 지도에 원을 표시합니다
    circle.setMap(map);
}

function addPolygon(callId, points, holes, strokeWeight, strokeColor, strokeOpacity = 1, strokeStyle = 'solid', fillColor = '#FFFFFF', fillOpacity = 0) {
    points = JSON.parse(points);
    let paths = [];
    for (let i = 0; i < points.length; i++) {
        paths.push(new kakao.maps.LatLng(points[i].latitude, points[i].longitude));
    }

    holes = JSON.parse(holes);
    if (!empty(holes)) {
        let holePaths = [];

        for (let i = 0; i < holes.length; i++) {
            let array = [];
            for (let j = 0; j < holes[i].length; j++) {
                array.push(new kakao.maps.LatLng(holes[i][j].latitude, holes[i][j].longitude));
            }
            holePaths.push(array);
        }

        return addPolygonWithHole(callId, paths, holePaths, strokeWeight, strokeColor, strokeOpacity, strokeStyle, fillColor, fillOpacity);
    }

    return addPolygonWithoutHole(callId, paths, strokeWeight, strokeColor, strokeOpacity, strokeStyle, fillColor, fillOpacity);
}

function addPolygonWithoutHole(callId, points, strokeWeight, strokeColor, strokeOpacity = 1, strokeStyle = 'solid', fillColor = '#FFFFFF', fillOpacity = 0) {
    // 지도에 표시할 다각형을 생성합니다
    let polygon = new kakao.maps.Polygon({
        path: points, // 그려질 다각형의 좌표 배열입니다
        strokeWeight: strokeWeight, // 선의 두께입니다
        strokeColor: strokeColor, // 선의 색깔입니다
        strokeOpacity: strokeOpacity, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
        strokeStyle: strokeStyle, // 선의 스타일입니다
        fillColor: fillColor, // 채우기 색깔입니다
        fillOpacity: fillOpacity // 채우기 불투명도 입니다
    });

    polygons.push(polygon);

    // 지도에 다각형을 표시합니다
    polygon.setMap(map);
}

function addPolygonWithHole(callId, points, holes, strokeWeight, strokeColor, strokeOpacity = 1, strokeStyle = 'solid', fillColor = '#FFFFFF', fillOpacity = 0) {
    // 다각형을 생성하고 지도에 표시합니다
    let polygon = new kakao.maps.Polygon({
        map: map,
        path: [points, ...holes], // 좌표 배열의 배열로 하나의 다각형을 표시할 수 있습니다
        strokeWeight: strokeWeight, // 선의 두께입니다
        strokeColor: strokeColor, // 선의 색깔입니다
        strokeOpacity: strokeOpacity, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
        fillColor: fillColor, // 채우기 색깔입니다
        fillOpacity: fillOpacity, // 채우기 불투명도 입니다
    });

    polygons.push(polygon);
}

function addMarker(markerId, latLng, imageSrc, width = 24, height = 30, offsetX = 0, offsetY = 0, infoWindowText) {
    let imageSize = new kakao.maps.Size(width, height); // 마커이미지의 크기입니다
    let imageOption = {offset: new kakao.maps.Point(offsetX, offsetY)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.

    let markerImage = null;
    // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
    if (!empty(imageSrc)) {
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
    }
    latLng = JSON.parse(latLng);
    let markerPosition = new kakao.maps.LatLng(latLng.latitude, latLng.longitude); // 마커가 표시될 위치입니다

    // 마커를 생성합니다
    let marker = new kakao.maps.Marker({
        position: markerPosition,
        image: markerImage, // 마커이미지 설정
    });

    // 마커가 지도 위에 표시되도록 설정합니다
    marker.setMap(map);

    markers.push(marker);

    // 마커에 클릭이벤트를 등록합니다
    kakao.maps.event.addListener(marker, 'click', function () {
        if (!empty(infoWindowText)) {
            // 마커 위에 인포윈도우를 표시합니다
            if (infoWindow != null) infoWindow.close();
            showInfoWindow(marker, latLng.latitude, latLng.longitude, infoWindowText);
        }
    });
}

let infoWindow = null;

function showInfoWindow(marker, latitude, longitude, contents = '') {
    let iwContent = '<div style="padding:5px;">' + contents + '</div>', // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
        iwPosition = new kakao.maps.LatLng(latitude, longitude), //인포윈도우 표시 위치입니다
        iwRemovable = true; // removable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다

    // 인포윈도우를 생성하고 지도에 표시합니다
    infoWindow = new kakao.maps.InfoWindow({
        map: map, // 인포윈도우가 표시될 지도
        position: iwPosition,
        content: iwContent,
        removable: iwRemovable
    });

    infoWindow.open(map, marker);
}

function setCenter(latitude, longitude) {
    // 이동할 위도 경도 위치를 생성합니다
    let moveLatLon = new kakao.maps.LatLng(latitude, longitude);

    // 지도 중심을 이동 시킵니다
    map.setCenter(moveLatLon);
}

function panTo(latitude, longitude) {
    // 이동할 위도 경도 위치를 생성합니다
    let moveLatLon = new kakao.maps.LatLng(latitude, longitude);

    // 지도 중심을 부드럽게 이동시킵니다
    // 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
    map.panTo(moveLatLon);
}

function fitBounds(points) {
    let list = JSON.parse(points);

    let bounds = new kakao.maps.LatLngBounds();
    for (let i = 0; i < list.length; i++) {
        // LatLngBounds 객체에 좌표를 추가합니다
        bounds.extend(new kakao.maps.LatLng(list[i].latitude, list[i].longitude));
    }

    map.setBounds(bounds);
}

window.onload = function () {
    let container = document.getElementById('map');
    let options = {
        center: new kakao.maps.LatLng(37.3626138, 126.9264801),
        level: 3
    };

    map = new kakao.maps.Map(container, options);

    // 마우스 드래그로 지도 이동이 완료되었을 때 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
    kakao.maps.event.addListener(map, 'dragstart', function () {
        // console.log(">>>>>>>>>>> drag start");
    });

    // 마우스 드래그로 지도 이동이 완료되었을 때 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
    kakao.maps.event.addListener(map, 'idle', function () {
        const latLng = map.getCenter();

        const idleLatLng = {
            latitude: latLng.getLat(),
            longitude: latLng.getLng(),
            zoomLevel: map.getLevel(),
        }

        cameraIdle.postMessage(JSON.stringify(idleLatLng));
    });

    kakao.maps.event.addListener(map, 'click', function (mouseEvent) {
        // 클릭한 위도, 경도 정보를 가져옵니다
        let latLng = mouseEvent.latLng;

        //map.setCenter(latlng);
        map.panTo(latLng);

        const clickLatLng = {
            latitude: latLng.getLat(),
            longitude: latLng.getLng(),
            zoomLevel: map.getLevel(),
        }

        onMapTap.postMessage(JSON.stringify(clickLatLng));
    });

    kakao.maps.event.addListener(map, 'zoom_changed', function (mouseEvent) {
        const level = map.getLevel();
        zoomChanged.postMessage(JSON.stringify({zoomLevel: level}));
    });
}

const empty = (value) => {
    if (value === null) return true
    if (typeof value === 'undefined') return true
    if (typeof value === 'string' && value === '' && value === 'null') return true
    if (Array.isArray(value) && value.length < 1) return true
    if (typeof value === 'object' && value.constructor.name === 'Object' && Object.keys(value).length < 1 && Object.getOwnPropertyNames(value) < 1) return true
    if (typeof value === 'object' && value.constructor.name === 'String' && Object.keys(value).length < 1) return true // new String
    return false
}
