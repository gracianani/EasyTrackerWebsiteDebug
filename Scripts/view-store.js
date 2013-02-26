var today = 'input[id$=hf_today]';
var yesterday = 'input[id$=hf_yesterday]';
var last7days = 'input[id$=hf_last7days]';
var thisWeek = 'input[id$=hf_thisWeek]';
var lastWeek = 'input[id$=hf_lastWeek]';
var last30days = 'input[id$=hf_last30days]';
var thisMonth = 'input[id$=hf_thisMonth]';
var lastMonth = 'input[id$=hf_lastMonth]';

var stats = 'input[id$=hf_stats]';
var enterTime;
var currentTime;

function getStoreUpdate() {
    if ($('select[id$=ddl_stores]').length > 0) {
        var storeId = $('select[id$=ddl_stores]').val();
        currentTime = new Date().getTime();
        var data = {
            'elasp': currentTime - enterTime,
            'storeId': storeId
        };

        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: 'Public/Services/MapWebService.asmx/GetStoreUpdate',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (msg) {
                if (parseInt(msg.d) > 0) {
                    $(".alert").removeClass("hidden").html('<strong><a href="/View-Store.aspx?StoreId=' + storeId + '">有' + msg.d + '个新店铺信息更新，点击查看</a></strong>');
                }
            }
        });
    }
}
function initMap(lat, lng) {
    map = L.map('map_canvas').setView([39.943600973165736, 116.31285667419434], 13);
    var mpn = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');
    var qst = new L.TileLayer('http://otile1.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png', { attribution: 'Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">' });
    map.addLayer(mpn);
    map.addLayer(qst);
    map.addControl(new L.Control.Layers({ 'Mapnik': mpn, 'MapQuest': qst, 'Google': new L.Google() }));
    map.setView([lat, lng], 13);
    var marker = L.marker([lat, lng], { draggable: false }).addTo(map);
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
            $('input[id$=hf_' + this.id + ']').val(selectedDate);
            $('input[id$=hf_' + $(dates.not(this)).attr('id') + ']').val($(dates.not(this)).val());

        }
    });
    
    if ($("input[id$=hf_txtDateFrom]").val().length == 0) {
        dates.first().val(yesterdateDateText).trigger('change');
        dates.last().val(todayDateText).trigger('change');
        $('input[id$=hf_txtDateFrom]').val(yesterdateDateText);
        $('input[id$=hf_txtDateTo]').val(todayDateText);
    }
    else {
        $('#txtDateFrom').val($("input[id$=hf_txtDateFrom]").val());
        $('#txtDateTo').val($("input[id$=hf_txtDateTo]").val());
    }
}

$(document).ready(function () {
    
    initDatepicker();
    enterTime = new Date().getTime();
    window.setInterval(getStoreUpdate, 60 * 1000 * 3);
    $('.lnk_StorePhotos').each(function () {
        var imgSrc = $(this).children('img').attr('src');
        $(this).attr('href', imgSrc);
    });

    $('#storesTabs a').click(function (e) {
        e.preventDefault();
        $(this).tab('show');
        initMap();
    });

    var anchorname = location.hash;
    if (anchorname != undefined && anchorname != null && anchorname != '') {
        var tabname = anchorname.replace('#', '#tab_');
        $(tabname).tab('show');

        if (anchorname == '#map') {
            initMap();
        }
    } else {
        initMap( $('.lat').html(), $('.lng').html() );
    }
    

});

