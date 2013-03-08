var map;
var enterTime;
var currentTime;

var shopIcon,highLightIcon;
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
    //map.addControl(new L.Control.Layers({ 'Mapnik': mpn, 'MapQuest': qst, 'Google': new L.Google() },{'店铺':shopLayer,'行程':trackLayer}));
}



function mapLoadShopData(data) {
			clearOverlays();
			shops = [];
            $.each(data, function (index, stat) {
                shops.push({
                    'id': stat.id,
                    'name': stat.name,
                    'latlng': stat.latlng,
                    'checkincount': stat.check,
                    'photocount': stat.photo,
					'commentcount':stat.msg
                });
            });
			var bounds = getBounds(shops);
            initShopMarkers(shops);	
			map.fitBounds(bounds);
}
function initShopIcon() {
	shopIcon = new L.Icon.Default();	
	highLightIcon = L.icon({
		iconUrl: 'Public/Styles/images/flag.png',
		shadowUrl: 'Public/Styles/images/flagshadow.png',
		iconSize:     [48, 48], // size of the icon
		shadowSize:   [48, 48], // size of the shadow
		iconAnchor:   [10, 48], // point of the icon which will correspond to marker's location
		shadowAnchor: [10, 48]  // the same for the shadow
	});	
}

function initShopDetailWindow() {
	info = L.control();
	info.setPosition('bottomleft');
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

        var shopMarker = L.marker(shop['latlng'], { icon: shopIcon }).bindPopup(getPopupHtml(shop));
        shopLayer.addLayer(shopMarker);
        shop_markers.push(shopMarker);
        shopMarker.on({
            mouseover: function (e) {
                var props = [];
                props.name = shop['name'];
                props.checkincount = shop['checkincount'];
                //props.records = shop['records'];
				props.records = [];
                info.update(props);
            },
			click:function (e) {
			}
        });
    });
	
}


function clearOverlays() {
    shopLayer.clearLayers();
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

function getPopupHtml(shop) {
	var html = "<h4>" + shop['name'] + "</h4>";
	html += '<p>今日：签到' + shop['checkincount'] + '次'+ ', 照片' + shop['photocount'] + '张' + ', 报告' + shop['commentcount'] + '条</p>';
	html += '<div id="popup-storeDetail"><img src="Public/Styles/images/loading.gif"> 正在获取最新数据</div>';
	html += '<p><a class="btn btn-primary" href="/View-Store.aspx?StoreId=' + shop['id'] + '" title="查看店铺详细信息"><i class="icon-list-alt icon-white"></i></a> <a class="btn btn-inverse" href="/Edit-Store.aspx?storeId=' + shop['id'] + '"  title="编辑店铺" target="_blank"><i class="icon-pencil icon-white"></i></a></p>';
	return html;
	
	
}

function getBounds(dataList) {
	var southWest = new L.LatLng(180, 0);
	var northEast = new L.LatLng(0, 180);
	console.log(dataList);
	for ( var i = 0; i < dataList.length; i++) {
		lat = dataList[i].latlng[0];
		lng = dataList[i].latlng[1];
		
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


function getStoreCheckInInfoWindowHtml(storeId, storeName, createdAt) {
    if (typeof (createdAt) != 'undefined') {
        return "<div><i class='icon-time'></i> <span>" + createdAt + "</span> <br/> <i class='icon-home'></i> <a href='View-Store.aspx?storeId=" + storeId + "'>" + storeName + "</a>  </div>";
    }
    else {
        return "<div><i class='icon-home'></i> <a href='View-Store.aspx?storeId=" + storeId + "'>" + storeName + "</a>  </div>";
    }
}
function highLightMakersByIndex(markerIndexes) {
	for (index in shop_markers) {
        var marker = shop_markers[index];
		if ( marker['status'] == 'active') {
        marker['status'] = 'inactive';
        marker.setIcon(shopIcon);
		}
    }
	for (index in markerIndexes) {
		var marker = shop_markers[markerIndexes[index]];
		marker['status'] = 'active';
		marker.setIcon(highLightIcon);
	}
	if ( markerIndexes.length == 1 ) {
		shop_markers[ markerIndexes[0] ].openPopup();
	}
}

function getStoreLatestInfo(storeId) {
	$.ajax({
		dataType: "json",
		url: "Scripts/data.js?" + (new Date().getTime()),
		success: function( data ) {
			
			
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) { 
             alert("Status: " + textStatus); alert("Error: " + errorThrown); 
        }		
		
	});
}