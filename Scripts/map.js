var poly;
var map;
var geocoder;

var cm_openInfowindow;
var cm_mapMarkers = [];
var cm_mapHTMLS = [];

// Change these parameters to customize map
var param_wsId = "od6";
var param_ssKey = "o16162288751915453340.4402783830945175750";
var param_useSidebar = true;
var param_titleColumn = "title";
var param_descriptionColumn = "description";
var param_latColumn = "latitude";
var param_lngColumn = "longitude";
var param_rankColumn = "rank";
var param_iconType = "green";
var param_iconOverType = "orange";
var param_iconTaskCheckInType = "red";
var param_iconInactiveType = "blue";

function cm_createMarker(map, latlng, title, html, rank, type) {
    var iconSize = new google.maps.Size(20, 34);
    var iconShadowSize = new google.maps.Size(37, 34);
    var iconHotSpotOffset = new google.maps.Point(9, 0); // Should this be (9, 34)?
    var iconPosition = new google.maps.Point(0, 0);
    var infoWindowAnchor = new google.maps.Point(9, 2);
    var infoShadowAnchor = new google.maps.Point(18, 25);

    var iconShadowUrl = "http://www.google.com/mapfiles/shadow50.png";
    var iconImageUrl;
    var iconImageOverUrl;
    var iconImageOutUrl;
    var iconImageInactiveUrl;

    if (rank > 0 && rank < 100) {
        iconImageOutUrl = "Public/Images/" +
        "markers/" + param_iconType + "/marker" + rank + ".png";
        if (typeof (type) != undefined && type == 2) {
            iconImageOutUrl = "Public/Images/" +
            "markers/" + param_iconTaskCheckInType + "/marker" + rank + ".png";

        }
        iconImageOverUrl = "http://gmaps-samples.googlecode.com/svn/trunk/" +
        "markers/" + param_iconOverType + "/marker" + rank + ".png";
        iconImageUrl = iconImageOutUrl;


    } else {
        iconImageOutUrl = "http://gmaps-samples.googlecode.com/svn/trunk/" +
        "markers/" + param_iconType + "/blank.png";
        iconImageOverUrl = "http://gmaps-samples.googlecode.com/svn/trunk/" +
        "markers/" + param_iconOverType + "/blank.png";
        iconImageUrl = iconImageOutUrl;
    }

    var markerShadow =
      new google.maps.MarkerImage(iconShadowUrl, iconShadowSize,
                                  iconPosition, iconHotSpotOffset);

    var markerImageOver =
            new google.maps.MarkerImage(iconImageOverUrl, iconSize,
                                  iconPosition, iconHotSpotOffset);
    var markerImageOut =
            new google.maps.MarkerImage(iconImageOutUrl, iconSize,
                                  iconPosition, iconHotSpotOffset);

    var markerOptions = {
        title: title,
        icon: markerImageOut,
        shadow: markerShadow,
        position: latlng,
        map: map
    }

    var marker = new google.maps.Marker(markerOptions);

    marker['html'] = html;
    marker['status'] = 'active';
    marker['markerImageOver'] = markerImageOver;
    marker['markerImageOut'] = markerImageOut;

    google.maps.event.addListener(marker, "click", function () {
        if (marker['status'] == 'active') {
            var infowindowOptions = {
                content: marker['html']
            }
            var infowindow = new google.maps.InfoWindow(infowindowOptions);
            cm_setInfowindow(infowindow);
            infowindow.open(map, marker);
            marker.setIcon(markerImageOut);

        }
        else {
            marker.setIcon(markerImageInactive);
        }
    });
    google.maps.event.addListener(marker, "mouseover", function () {
        if (marker['status'] == 'active') {
            marker.setIcon(markerImageOver);
        }
    });
    google.maps.event.addListener(marker, "mouseout", function () {
        if (marker['status'] == 'active') {
            marker.setIcon(markerImageOut);
        }
    });

    return marker;
}

function cm_activateMarker(markers, triangle) {
    var bounds = new google.maps.LatLngBounds();

    for (index in markers) {
        var marker = markers[index];
        marker['status'] = 'active';
        marker.setMap(map);
        marker.setIcon(marker['markerImageOut']);

        bounds.extend(marker.getPosition());
    }
    //triangle.fillColor = "#FF00FF";
    //triangle.setMap(map);

    map.fitBounds(bounds);
}

function cm_deactivateMarker(markers, triangle) {

    for (index in markers) {
        var marker = markers[index];
        marker.setMap(null);
        marker['status'] = 'inactive';
    }
    triangle.setMap(null);
}

function cm_createBoundary(markers) {
    var boundary = [];
    if (markers.length > 1) {
        var top, left, bottom, right;
        top = markers[0].getPosition().lng();
        bottom = top;
        left = markers[0].getPosition().lat();
        right = left;

        for (index in markers) {
            var marker = markers[index];
            pos = marker.getPosition();
            if (pos.lng() < top) {
                top = pos.lng();
            }
            if (pos.lng() > bottom) {
                bottom = pos.lng();
            }
            if (pos.lat() < left) {
                left = pos.lat();
            }
            if (pos.lat() > right) {
                right = pos.lat();
            }
        }
        boundary.push(new google.maps.LatLng(left - 0.003, top - 0.003));
        boundary.push(new google.maps.LatLng(right + 0.003, top - 0.003));
        boundary.push(new google.maps.LatLng(right + 0.003, bottom + 0.003));
        boundary.push(new google.maps.LatLng(left - 0.003, bottom + 0.003));
    }
    var bermudaTriangle = new google.maps.Polygon({
        paths: boundary,
        strokeColor: "#005580",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#0088CC",
        fillOpacity: 0.1
    });
    bermudaTriangle.setMap(map);
    return bermudaTriangle;
}

function clearOverlays(markerGroups, boundaries) {

    for (markerGroup_index in markerGroups) {
        markers = markerGroups[markerGroup_index];
        for (marker_index in markers) {
            marker = markers[marker_index];
            marker.setMap(null);
        }
    }

    for (boundary_index in boundaries) {
        boundary = boundaries[boundary_index];
        boundary.setMap(null);
    }
}

function cm_setInfowindow(newInfowindow) {
    if (cm_openInfowindow != undefined) {
        cm_openInfowindow.close();
    }

    cm_openInfowindow = newInfowindow;
}

function initMap() {

    if (typeof (map) == 'undefined' || typeof (map) == '' || typeof (map) == null) {
        var mapOptions = {
            center: new google.maps.LatLng(39.943600973165736, 116.31285667419434),
            zoom: 13,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
        geocoder = new google.maps.Geocoder();
    }
}



function reverseGeocode(address, response) {

    geocoder.geocode({ 'address': address }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            if (results.length > 0) {
                var i = 0;
                map.setCenter(results[0].geometry.location);
                for (i = 0; i < results.length; i++) {
                    cm_createMarker(map, results[i].geometry.location, results[i].formatted_address, setInfowindowContent(results[i], response), i + 1);
                    response(results[i].geometry.location);
                }
            }
        } else {
            alert("Geocoder failed due to: " + status);
        }
    });
}

function setInfowindowContent(address, response) {
    var btn_set_location = $('<a href="javascript:void(0)" class="btn btn-small btn-info" >选择这个地址</a>').click(function () {
        response(address.geometry.location);
        if (cm_openInfowindow != undefined) {
            cm_openInfowindow.close();
        }
    });
    var main_content = $('<div style="width:100px"></div>').html(address.formatted_address);
    return main_content.append(btn_set_location)[0];
}



function cm_createInfoWindowHtml(checkIn) {
    var outStr = '<div class="checkInIndex">' + checkIn.index + '</div> <div><i class="icon-time"></i> 时间:' + checkIn.CreatedAt + '<br />' +
				'<i class="icon-map-marker"></i> 坐标:( ' + checkIn.CheckInCoordinate.Latitude + ', ' + checkIn.CheckInCoordinate.Longitude + ' )</div>';

    return outStr;
}



function cm_createInfoWindowHtml_withName(content, link) {
    var btn_set_location = $('<br/><br/><a class="btn btn-small btn-info" >查看店铺详细信息</a>').click(function () {
        if (cm_openInfowindow != undefined) {
            cm_openInfowindow.close();
        }
    }).attr('href', link);
    var main_content = $('<div></div>').html(content);
    return main_content.append(btn_set_location)[0];
}

function cm_createCheckInInfoWindow(storeId, storeName, createdAt) {
    return "<div><i class='icon-time'></i> <span>" + createdAt + "</span> <br/> <i class='icon-home'></i> <a href='View-Store.aspx?storeId=" + storeId + "'>" + storeName + "</a>  </div>";
}