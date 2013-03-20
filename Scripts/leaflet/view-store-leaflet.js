
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
var map;
var shop_markers=[];

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
function initDatepicker() {
    var today = new Date();
    var tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000));
    var yesterday = new Date(today.getTime() - (5 * 24 * 60 * 60 * 1000));
    var todayDateText = tomorrow.getFullYear() + '-' + (tomorrow.getMonth() + 1) + '-' + tomorrow.getDate();
    var yesterdateDateText = yesterday.getFullYear() + '-' + (yesterday.getMonth() + 1) + '-' + yesterday.getDate();
    var dates = $("input[id$=txtDateFrom], input[id$=txtDateTo]").datepicker({
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

function initMap() {
    map = L.map('map_canvas').setView([39.943600973165736, 116.31285667419434], 13);
    var mpn = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');
    var qst = new L.TileLayer('http://otile1.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png', { attribution: 'Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">' });
    map.addLayer(mpn);
    map.addLayer(qst);
    map.addControl(new L.Control.Layers({ 'Mapnik': mpn, 'MapQuest': qst, 'Google': new L.Google() }));
}

function getInfoWindowHtmlByStoreName(content, link) {
    var btn_set_location = $('<br/><br/><a class="btn btn-small btn-info" >查看店铺详细信息</a>').attr('href', link);
    var main_content = $('<div></div>').html(content);
    return main_content.html();
}

function bindStorePopup() {
    $.each($(".storeList-item"), function (index, shopListItem) {

        $(shopListItem).click(function () {
            var shop = $.parseJSON($(this).find('shopjson').html());
            shop_markers[index].openPopup();
            getStoreLatestInfo(shop['id']);
            map.panTo([shop['lat'], shop['lng']]);
        });
    });
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
        initMap();
    }
    bindStorePopup();
    $('#summaryTemplate').tmpl({ Today: $(today).val(), Yesterday: $(yesterday).val(), ThisMonth: $(thisMonth).val(), LastMonth: $(lastMonth).val(), ThisWeek: $(thisWeek).val(),
        LastWeek: $(lastWeek).val(), Last7Days: $(last7days).val(), ThisMonth: $(thisMonth).val(), LastMonth: $(lastMonth).val(), Last30Days: $(lastMonth).val()
    }).appendTo('#summary'); ;

    statsVal = $.parseJSON($(stats).val());
    console.log(statsVal);
    chart = new Highcharts.Chart({
        chart: {
            renderTo: 'flowchart',
            type: 'line',
            marginRight: 130,
            marginBottom: 25
        },
        title: {
            text: '月报道数统计表',
            x: -20 //center
        },
        subtitle: {
            text: '店铺数：',
            x: -20
        },
        xAxis: {
            categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        },
        yAxis: {
            title: {
                text: '次数'
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: '#808080'
            }]
        },
        tooltip: {
            formatter: function () {
                return '<b>' + this.series.name + '</b><br/>' +
                        this.x + ': ' + this.y + '次';
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            x: -10,
            y: 100,
            borderWidth: 0
        },
        series: [{
            name: statsVal[0].year,
            data: $.map(statsVal[0].value.split(','), function (n) { return parseInt(n) })
        }, {
            name: statsVal[1].year,
            data: $.map(statsVal[1].value.split(','), function (n) { return parseInt(n) })
        }]
    });



    var storesCoordinate = [];

    $('p.hidden').each(function (index) {
        var shop = $.parseJSON($(this).find('shopjson').html());
        storesCoordinate.push({ Latitude: parseFloat(shop['lat']), Longitude: parseFloat( shop['lng'] ) });
        var marker = L.marker([shop['lat'], shop['lng']]).addTo(map);
        marker.bindPopup(getPopupHtml(shop));
        shop_markers.push(marker);
        marker.on({
            click: function (e) {
                getStoreLatestInfo(shop['id']);
            }
        });
    });


});

function getPopupHtml(shop) {
    var html = "<h4>" + shop['name'] + "</h4>";
    html += '<div id="popup-storeDetail" data-id="' + shop['id'] + '"><img src="Public/Styles/images/loading.gif"> 正在获取最新数据</div>';
    html += '<p><a class="btn btn-primary" href="/View-Store.aspx?StoreId=' + shop['id'] + '" title="查看店铺详细信息"><i class="icon-list-alt icon-white"></i></a> <a class="btn btn-inverse" href="/Edit-Store.aspx?storeId=' + shop['id'] + '"  title="编辑店铺" target="_blank"><i class="icon-pencil icon-white"></i></a> <a href="/Manage-Task.aspx" class="btn btn-inverse"><i class="icon-plus icon-white" title="添加任务"></i></a></p>';
    return html;


}
function getStoreLatestInfo(storeId) {
    if (!storeId) {
        storeId = $('#popup-storeDetail').attr('data-id');
    }
    var storedata = { storeId: storeId };
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: 'Public/Services/MapWebService.asmx/GetLastestStoreUpdates',
        contentType: 'application/json',
        data: JSON.stringify(storedata),
        success: function (data) {
            var stats = $.parseJSON(data.d);
            showStoreLatestInfo(stats);

        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            //alert("Status: " + textStatus); alert("Error: " + errorThrown); 
        }

    });
}
function showStoreLatestInfo(data) {
    var str = "";
    if (data.trackRecords) {
        for (var i in data.trackRecords) {
            str += '<p>' + data.trackRecords[i].name + ' 签到 ' + '<span class="time">' + data.trackRecords[i].time + '</span>' + '</p>';
        }
    } else {
        str += '<p>无踩点纪录</p>';
    }
    if (data.photos ) {
        str += '<p id="popup-storeDetail-photos">';
        for (var i in data.photos) {
            str += '<a rel="lightBox"  href="' + data.photos[i].src + '" ><img src="' + data.photos[i].src + '" height="60" /></a>';
        }
        str += '</p>';
    } else {
        str += '<p>最近无照片</p>';
    }
    $('#popup-storeDetail').html(str);
} 

