var map;
var data_markers = [];


var enterTime;
var currentTime;


var shopIcon;
var shopLayer;
var trackLayer;

var shop_markers = [];
var shops = [];
var currentShop = {};
var info;

function initMap() {
   
    map = L.map('map_canvas').setView([39.943600973165736, 116.31285667419434], 13);
	console.log(map);
    var mpn = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');
    var qst = new L.TileLayer('http://otile1.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png', { attribution: 'Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">' });
    map.addLayer(mpn);
    map.addLayer(qst);
	
	initShopIcon();
	shopLayer = new L.layerGroup().addTo(map);
	initShopDetailWindow();
	trackLayer = new L.layerGroup().addTo(map);
    map.addControl(new L.Control.Layers({ 'Mapnik': mpn, 'MapQuest': qst, 'Google': new L.Google() },{'店铺':shopLayer,'行程':trackLayer}));
}



function generateTestShops(data) {

    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: 'Public/Services/MapWebService.asmx/GetCheckInStats',
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function (msg) {
            shops = [];
            var stats = $.parseJSON(msg.d);
            $.each(stats, function (index, stat) {
                shops.push({
                    'id': stat.StoreId,
                    'name': stat.StoreName,
                    'latlng': [stat.Latitude, stat.Longitude],
                    'checkincount': stat.CheckInCount,
                    'photocount': stat.PhotoCount,
                    'records': stat.Records
                });
            });
            initShopMarkers(shops);
        }
    });
	
	
}
function initShopIcon() {
	shopIcon = L.icon({
		iconUrl: 'Public/Styles/images/shop.png',
		shadowUrl: 'Public/Styles/images/shop-shadow.png',
		iconSize:     [32, 32], // size of the icon
		shadowSize:   [42, 13], // size of the shadow
		iconAnchor:   [16, 16], // point of the icon which will correspond to marker's location
		shadowAnchor: [11, -2],  // the same for the shadow
		popupAnchor:  [-4, -16] // point from which the popup should open relative to the iconAnchor
	});	
}

function initShopDetailWindow() {
	info = L.control();
	info.setPosition('bottomright');
	info.onAdd = function (map) {
		this._div = L.DomUtil.create('div', 'info'); // create a div with a class "info"
		this.update();
		return this._div;
	};
	
	// method that we will use to update the control based on feature properties passed
	info.update = function (props) {
	    var trackRecords = "";
	    if (props) {
	        if (props.records) {
	            for (var i = 0; i < props.records.length; i++) {
	                console.log(props.records[i]);
	                trackRecords += (i + 1) + '. ' + props.records[i].EmployeeName + "&nbsp;" + props.records[i].Time + '<br>';
	            }
	        }
	    }
	    this._div.innerHTML = '<h4>' + (props ?
			'<b>' + props.name + '</b> <br>踩点总数' + props.checkincount
			: '店铺明细') + '</h4>' + (props ?
			trackRecords
			: '请在地图中选择一个商店');
	};
	
	info.addTo(map);
}

function initShopMarkers(shopList) {

    $.each(shopList, function (index, shop) {

        var shopMarker = L.marker(shop['latlng'], { icon: shopIcon }).bindPopup(shop['name'] + '<br>签到' + shop['checkincount'] + '次');
        shopLayer.addLayer(shopMarker);
        shop_markers.push(shopMarker);
        shopMarker.on({
            mouseover: function (e) {
                var props = [];
                props.name = shop['name'];
                props.checkincount = shop['checkincount'];
                props.records = shop['records'];
                info.update(props);
            }
        });
    });
	
}


function clearOverlays() {


    for (index in data_markers) {
        var marker = data_markers[index];
        marker.setOpacity(0.0);
        marker.unbindPopup();
    }
    data_markers = [];

    for (index in shop_markers) {
        var marker = shop_markers[index];
        marker.setOpacity(0.0);
        marker.unbindPopup();
    }
    shop_markers = [];
}

function getTrackingsUpdate( ) {
    if ($('select[id$=ddl_Employee]').length > 0) {
        var employeeId = $('select[id$=ddl_Employee]').val();
        currentTime = new Date().getTime();
        var data = {
            'elasp': currentTime - enterTime,
            'employeeId': employeeId
        };

        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: 'Public/Services/MapWebService.asmx/GetTrackingUpdate',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (msg) {
                if (parseInt(msg.d) > 0) {
                    $(".alert").removeClass("hidden").html('<strong><a href="/View-Employee-Leaflet.aspx?EmployeeId=' + employeeId + '">有' + msg.d + '个新位置更新，点击查看</a></strong>');
                }
            }
        });
    }
}

function initDatepicker() {
    var today = new Date();
    var tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000));
    var yesterday = new Date(today.getTime() - (5 * 24 * 60 * 60 * 1000));
    var todayDateText = tomorrow.getFullYear() + '-' + (tomorrow.getMonth() + 1) + '-' + tomorrow.getDate();
    var yesterdateDateText = yesterday.getFullYear() + '-' + (yesterday.getMonth() + 1) + '-' + yesterday.getDate();
    var dates = $("#txtDateFrom, #txtDateTo").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        dateFormat: 'yy-mm-dd',
        onSelect: function (selectedDate) {
            var option = this.id == "txtDateFrom" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings);
            dates.not(this).datepicker("option", option, date);
        }
    });
    dates.first().val(yesterdateDateText).trigger('change');
    dates.last().val(todayDateText).trigger('change');
}




function isSameLocation(Coordinate1, Coordinate2) {
	var latlng1 = new L.LatLng(Coordinate1.Latitude, Coordinate1.Longitude);
	var latlng2 = new L.LatLng(Coordinate2.Latitude, Coordinate2.Longitude);
	
	var distance = latlng1.distanceTo(latlng2);
    if (distance < 10) {
        return true;
    }
    return false;
}

function sortDataListByLocation(checkInGroupByDate) {
    var dataList = new Array();

    for (var i = 0; i < checkInGroupByDate.length; i++) {
        if (0 == i || checkInGroupByDate[i].CheckInType == 2 || checkInGroupByDate[i - 1].CheckInType == 2) {
            //第一条纪录，是签到的纪录，直接创建一个新的点
            dataList.push(checkInGroupByDate[i]);
        } else {

            var lastPoint = dataList[dataList.length - 1];
           /* if (isSameLocation(checkInGroupByDate[i].CheckInCoordinate, lastPoint.CheckInCoordinate)) {
                if ((checkInGroupByDate.length - 1) == i || checkInGroupByDate[i + 1].CheckInType == 2 || !isSameLocation(checkInGroupByDate[i + 1].CheckInCoordinate, lastPoint.CheckInCoordinate)) {

                    var createdAt = checkInGroupByDate[i].CreatedAt + '-' + lastPoint.CreatedAt;
                    lastPoint.CreatedAt = createdAt;

                }

            } else {
                dataList.push(checkInGroupByDate[i]);
            }*/
            dataList.push(checkInGroupByDate[i]);
        }
    }

    for (var i = 0; i < dataList.length; i++) {
        dataList[i].index = dataList.length - i;
    }
    return dataList;
}

function getBounds(dataList) {
	var southWest = new L.LatLng(180, 0);
	var northEast = new L.LatLng(0, 180);
	for ( var i = 0; i < dataList.length; i++) {
		lat = dataList[i].CheckInCoordinate.Latitude;
		lng = dataList[i].CheckInCoordinate.Longitude;
		
		if (southWest.lat > lat ) {
			southWest.lat = lat
		}
		if (southWest.lng < lng ) {
			southWest.lng = lng
		}
		if (northEast.lat < lat ) {
			northEast.lat = lat
		}
		if (northEast.lng > lng ) {
			northEast.lng = lng
		}
	}
	
	bounds = new L.LatLngBounds(southWest, northEast);

	return bounds;
	
}
function getRegularCheckInInfoWindowHtml(checkIn) {
    var outStr = '<div class="checkInIndex">' + checkIn.index + '</div> <div><i class="icon-time"></i> 时间:' + checkIn.CreatedAt + '<br />' +
				'<i class="icon-map-marker"></i> 坐标:( ' + checkIn.CheckInCoordinate.Latitude + ', ' + checkIn.CheckInCoordinate.Longitude + ' )</div>';

    return outStr;
}


function getStoreCheckInInfoWindowHtml(storeId, storeName, createdAt) {
    if (typeof (createdAt) != 'undefined') {
        return "<div><i class='icon-time'></i> <span>" + createdAt + "</span> <br/> <i class='icon-home'></i> <a href='View-Store.aspx?storeId=" + storeId + "'>" + storeName + "</a>  </div>";
    }
    else {
        return "<div><i class='icon-home'></i> <a href='View-Store.aspx?storeId=" + storeId + "'>" + storeName + "</a>  </div>";
    }
}

function activateMarkers(markers) {
    for (index in markers) {
        var marker = markers[index];
        marker['status'] = 'active';
        marker.setOpacity(1.0);
    }
}

function deactivateMarkers(markers) {

    for (index in markers) {
        var marker = markers[index];
        marker['status'] = 'inactive';
        marker.setOpacity(0.0);
    }
}

$(document).ready(function () {

    //$('.container').removeClass('container').addClass('container-fluid');

    //initDatepicker();
    initMap();
    //enterTime = new Date().getTime();
    //window.setInterval(getTrackingsUpdate, 60 * 1000 * 3);




});