
var data_markers = [];
var data_boundaries = [];


var enterTime;
var currentTime;
function getTrackingsUpdate() {
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
                    $(".alert").removeClass("hidden").html('<strong><a href="/View-Employee.aspx?EmployeeId=' + employeeId + '">有' + msg.d + '个新位置更新，点击查看</a></strong>');
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
var EARTH_RADIUS = 6378.137
			

function rad(d){
	return d*Math.PI/180.0 ;
}
			
// Calculates distance between two latitude/longitude coordinates in km,
// based on the haversine formula.
function calcDistance(prevLat, prevLong, currLat, currLong) {
    // KNOWN CONSTANTS
    var degreesToRadians = Math.PI / 180;
    var earthRadius = 6371; // approximation in kilometers assuming earth to be spherical
    // CONVERT LATITUDE AND LONGITUDE VALUES TO RADIANS
    var previousRadianLat = prevLat * degreesToRadians;
    var previousRadianLong = prevLong * degreesToRadians;
    var currentRadianLat = currLat * degreesToRadians;
    var currentRadianLong = currLong * degreesToRadians;
    // CALCULATE RADIAN DELTA BETWEEN THE TWO POSITIONS
    var latitudeRadianDelta = currentRadianLat - previousRadianLat;
    var longitudeRadianDelta = currentRadianLong - previousRadianLong;
    var expr1 = (Math.sin(latitudeRadianDelta / 2) * Math.sin(latitudeRadianDelta / 2)) +
                (Math.cos(previousRadianLat) * Math.cos(currentRadianLat) * Math.sin(longitudeRadianDelta / 2) * Math.sin(longitudeRadianDelta / 2));
    var expr2 = 2 * Math.atan2(Math.sqrt(expr1), Math.sqrt(1 - expr1));
    var distanceValue = earthRadius * expr2;
    return distanceValue;
}


function isSameLocation(Coordinate1, Coordinate2) {
	
	var dis = calcDistance(Coordinate1.Latitude, Coordinate1.Longitude, Coordinate2.Latitude, Coordinate2.Longitude);
	if ( dis < 8) {
		return true;
	}
	return false;
    

}
function sortDataListByLocation(checkInGroupByDate) {
 
    var dataList = new Array();

    for (var i = 0; i < checkInGroupByDate.length; i++) {
        if (0 == i || checkInGroupByDate[i].CheckInType == 2  ||  checkInGroupByDate[i-1].CheckInType == 2) {
            //第一条纪录，是签到的纪录，直接创建一个新的点
            dataList.push(checkInGroupByDate[i]);
        } else {

            var lastPoint = dataList[dataList.length - 1];
            
            if (isSameLocation(checkInGroupByDate[i].CheckInCoordinate, lastPoint.CheckInCoordinate)) {

	        
                if ((checkInGroupByDate.length - 1) == i || checkInGroupByDate[i+1].CheckInType == 2 || !isSameLocation(checkInGroupByDate[i + 1].CheckInCoordinate, lastPoint.CheckInCoordinate)) {

                    var createdAt = checkInGroupByDate[i].CreatedAt + '-' + lastPoint.CreatedAt;
                    lastPoint.CreatedAt = createdAt;

                }

            } else {
                dataList.push(checkInGroupByDate[i]);
            }
        }
    }
    
    for ( var i = 0; i < dataList.length; i++ ) {
	    dataList[i].index = dataList.length - i;
    }


    return dataList;
}

$(document).ready(function () {

    initDatepicker();
    initMap();
    enterTime = new Date().getTime();
    window.setInterval(getTrackingsUpdate, 60 * 1000 * 3);

    $('#btnSearch').click(function () {
        $('#locations').html('');
        var data = {
            'employeeId': $('select[id$=ddl_Employee]').val(),
            'from': $('#txtDateFrom').val(),
            'to': $('#txtDateTo').val()
        };
        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: 'Public/Services/MapWebService.asmx/GetUserLocationsAll',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (msg) {
                clearOverlays(data_markers, data_boundaries);
                var location_data_list = $.parseJSON(msg.d);
                

                if (location_data_list.length < 1) {
                    $('#locations').text('在选定时段内，该员工无踩点纪录');
                } else {
                    $.each(location_data_list, function (index, checkInGroupByDate) {
                        console.log(checkInGroupByDate);
                        
                        var tempDate = new Date(checkInGroupByDate.CheckInDate);
                        var dateStr = tempDate.getFullYear() + '-' + (tempDate.getMonth() + 1) + '-' + tempDate.getDate();

                        var descirptionLi = $('<li class="nav-header" data-toggle="collapse" ></li>').html(dateStr);
                        descirptionLi.attr("data-target", ".collapse_" + index);
                        descirptionLi.attr("data-parent", "#locations");
                        descirptionLi.appendTo("#locations");

                        var list = $('<ul class="nav nav-list" style="max-height:150px;overflow-x:hidden;overflow-y:auto;"></ul>');
                        list.addClass("collapse_" + index).addClass("collapse");

                        var sorted_checkin_list = sortDataListByLocation(checkInGroupByDate.CheckInDetails);

                        $("#employeeLocationTemplate").tmpl(sorted_checkin_list).appendTo(list);
                        list.appendTo(descirptionLi);
                        var cm_mapMarkers = [];


                        $.each(sorted_checkin_list, function (index_c, checkInGroupByCoordinate) {


                            var point = new google.maps.LatLng(checkInGroupByCoordinate.CheckInCoordinate.Latitude, checkInGroupByCoordinate.CheckInCoordinate.Longitude);
                            var html = '';
                            if (checkInGroupByCoordinate.CheckInType == 2 && checkInGroupByCoordinate.Store.length > 0) {
                                html = cm_createCheckInInfoWindow(checkInGroupByCoordinate.Store[0].StoreId, checkInGroupByCoordinate.Store[0].StoreName, checkInGroupByCoordinate.CreatedAt);
                            }
                            else {
                                html = cm_createInfoWindowHtml(checkInGroupByCoordinate);
                            }
                            var marker = cm_createMarker(map, point, checkInGroupByCoordinate.CreatedAt, html, checkInGroupByCoordinate.index, checkInGroupByCoordinate.CheckInType);
                            cm_mapMarkers.push(marker);

                            list.find('a').slice(index_c, index_c + 1).click(function () {
                                var infowindowOptions = {
                                    content: html
                                };
                                var infowindow = new google.maps.InfoWindow(infowindowOptions);
                                cm_setInfowindow(infowindow);
                                infowindow.open(map, marker);
                                return false;
                            });
                        });


                        var cm_boundary = cm_createBoundary(cm_mapMarkers);
                        data_markers.push(cm_mapMarkers);
                        data_boundaries.push(cm_boundary);

                        if (index == 0) {
                            list.addClass("in");
                            cm_activateMarker(cm_mapMarkers, cm_boundary);
                        }
                        else {
                            cm_deactivateMarker(cm_mapMarkers, cm_boundary);
                        }

                        descirptionLi.on('shown', function () {
                            cm_activateMarker(cm_mapMarkers, cm_boundary);

                        })
                        descirptionLi.on('hidden', function () {
                            cm_deactivateMarker(cm_mapMarkers, cm_boundary);
                        });


                    });

                    $('#locations').collapse({
                        toggle: false
                    })
                }
            }
        });
    });
    $('#MainContent_ddl_Employee').change(function () {
        $('#btnSearch').click();
    });
    $('#btnSearch').click();
});