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

    $('.container').removeClass('container').addClass('container-fluid');

    initDatepicker();
    initMap();
    enterTime = new Date().getTime();
    window.setInterval(getTrackingsUpdate, 60 * 1000 * 3);

    $('#btnSearch').click(function () {

        clearOverlays();
        $('#locations').html('');


        var data = {
            'employeeId': $('select[id$=ddl_Employee]').val(),
            'from': $('#txtDateFrom').val(),
            'to': $('#txtDateTo').val()
        };
        generateTestShops(data);
        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: 'Public/Services/MapWebService.asmx/GetUserLocationsAll',
            contentType: 'application/json',
            data: JSON.stringify(data),
            beforeSend: function () {
                Spinners.create('#spinner', {
                    radius: 8,
                    height: 11,
                    width: 7.4,
                    dashes: 7,
                    opacity: 0.8,
                    padding: 1,
                    rotation: 650,
                    color: '#000000'
                }).play()
            },
            success: function (msg) {
                Spinners.get('#spinner').remove();
                clearOverlays();
                var response = msg.d;
                if (response.Status == false) {
                    alert(response.LocationResponse);
                    return;
                }
                var location_data_list = $.parseJSON(response.LocationResponse);
                if (location_data_list.length < 1) {
                    $('#locations').text('在选定时段内，该员工无踩点纪录');
                } else {
                    $.each(location_data_list, function (index, checkInGroupByDate) {

                        var tempDate = new Date(checkInGroupByDate.CheckInDate);
                        var dateStr = tempDate.getFullYear() + '-' + (tempDate.getMonth() + 1) + '-' + tempDate.getDate();
                        var descirptionLi = $('<li class="nav-header" data-toggle="collapse" ></li>');
                        var descriptionA = $('<a  data-toggle="collapse" ></a>').html(dateStr);
                        descriptionA.attr("data-target", ".collapse_" + index);
                        descriptionA.attr("data-parent", "#locations");
                        descriptionA.appendTo(descirptionLi);
                        descirptionLi.appendTo("#locations");

                        var list = $('<ul class="nav nav-list" style="max-height:475px;overflow-x:hidden;overflow-y:auto;"></ul>');
                        list.addClass("collapse_" + index).addClass("collapse");

                        var sorted_checkin_list = sortDataListByLocation(checkInGroupByDate.CheckInDetails);
                        var bounds = getBounds(sorted_checkin_list);

                        $("#employeeLocationTemplate").tmpl(sorted_checkin_list).appendTo(list);
                        list.appendTo(descirptionLi);
                        var cm_mapMarkers = [];


                        $.each(sorted_checkin_list, function (index_c, checkInGroupByCoordinate) {
                            var LeafIcon = L.Icon.extend({
                                options: {

                                    shadowUrl: 'Public/Libs/Leaflet/images/numbers/shadow.png',
                                    iconSize: [20, 34],
                                    shadowSize: [40, 34],
                                    iconAnchor: [12, 33],
                                    shadowAnchor: [10, 34],
                                    popupAnchor: [-1, -28]
                                }
                            });
                            var icon;
                            var html = '';
                            if (checkInGroupByCoordinate.CheckInType == 2 && checkInGroupByCoordinate.Store.length > 0) {
                                html = getStoreCheckInInfoWindowHtml(checkInGroupByCoordinate.Store[0].StoreId, checkInGroupByCoordinate.Store[0].StoreName, checkInGroupByCoordinate.CreatedAt);
                                icon = new LeafIcon({ iconUrl: "Public/Libs/Leaflet/images/numbers/red/marker" + checkInGroupByCoordinate.index + ".png" });
                            }
                            else {
                                html = getRegularCheckInInfoWindowHtml(checkInGroupByCoordinate);
                                icon = new LeafIcon({ iconUrl: "Public/Libs/Leaflet/images/numbers/blue/marker" + checkInGroupByCoordinate.index + ".png" });
                            }
                            var marker = L.marker([checkInGroupByCoordinate.CheckInCoordinate.Latitude, checkInGroupByCoordinate.CheckInCoordinate.Longitude], { icon: icon });
                            trackLayer.addLayer(marker);
                            cm_mapMarkers.push(marker);
                            marker.bindPopup(html);
                            data_markers.push(marker);
                            list.find('a').slice(index_c, index_c + 1).click(function () {

                                marker.openPopup();
                                return false;
                            });

                        }); //end each


                        if (index == 0) {
                            list.addClass("in");
                            activateMarkers(cm_mapMarkers);
                            map.fitBounds(bounds);
                        }
                        else {
                            deactivateMarkers(cm_mapMarkers);
                        }

                        descirptionLi.on('shown', function () {
                            activateMarkers(cm_mapMarkers);
                            map.fitBounds(bounds);


                        })
                        descirptionLi.on('hidden', function () {
                            deactivateMarkers(cm_mapMarkers);
                        });


                    });

                    $('#locations').collapse({
                        toggle: true
                    });
                    $('table[id$=gv_UserTask] tr').click(function () {
                        var storeId = $(this).find('input[id$=StoreId]');
                        var latitude = $(this).find('input[id$=Latitude]');
                        var longitude = $(this).find('input[id$=Longitude]');
                        var storeName = $(this).find('td:eq(0)').html();
                        var html = getStoreCheckInInfoWindowHtml(storeId.val(), storeName);
                        var popup = L.popup()
            .setLatLng([latitude.val(), longitude.val()])
            .setContent(html)
            .openOn(map);
                    });


                }
            }
        });
    });
    $('#MainContent_ddl_Employee').change(function () {
        $('#btnSearch').click();
    });
    $('#btnSearch').click();


});