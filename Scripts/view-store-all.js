
$(document).ready(function () {
    
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




    var cm_mapMarkers = [];
    var storesCoordinate = [];

    $('p.hidden').each(function (index) {
    storesCoordinate.push({ Latitude: parseFloat($(this).find('lat').html()), Longitude: parseFloat($(this).find('lng').html()) });
    var point = new google.maps.LatLng(storesCoordinate[index].Latitude, storesCoordinate[index].Longitude);
    var marker = cm_createMarker(map, point, "", cm_createInfoWindowHtml_withName($(this).siblings().has('i').find('a').html(), $(this).siblings().has('i').find('a').attr('href')), index + 1, 3);
    cm_mapMarkers.push(marker);
    });
    
});