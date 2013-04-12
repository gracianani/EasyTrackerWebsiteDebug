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
            initShopMarkers(shops);	
			map.fitBounds(getBounds(shop_markers));
			if ( info ) {
				info.update();
			} else {
			initShopDetailWindow();
			}
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
	info.setPosition('bottomright');
	info.onAdd = function (map) {
		this._div = L.DomUtil.create('div', 'info'); // create a div with a class "info"
		this.update();
		return this._div;
	};
	
	// method that we will use to update the control based on feature properties passed
	info.update = function (props) {
		var str = "";
		if (props) {
			if ( props.title ) {
				str+= '<h4>' + props.title + '</h4>';
			}
			if ( props.count ) {
				str+= '<p>选中：' + props.count + '个</p>';
				str += '<p><a class="btn btn-primary" href="javascript:resetFitBounds();"><i class="icon-zoom-out icon-white"></i></a> <a class="btn btn-primary" href="javascript:resetSelection();">取消选择</a></p>';
			}
		} else {
			str += '<h4>您未选择任何店铺</h4><p>店铺总数' + shops.length + '个</p>';
		}
		
	    this._div.innerHTML = str;
	};
	info.addTo(map);
}

function initShopMarkers(shopList) {
    $.each(shopList, function (index, shop) {

        var shopMarker = L.marker(shop['latlng'], { icon: shopIcon }).bindPopup(getPopupHtml(shop));
        shopLayer.addLayer(shopMarker);
        shop_markers.push(shopMarker);
        shopMarker.on({
			click:function (e) {
				getStoreLatestInfo(shop['id']);
			}
        });
    });
	
}


function clearOverlays() {
    shopLayer.clearLayers();
    shop_markers = [];
}



function getPopupHtml(shop) {
	var html = "<h4>" + shop['name'] + "</h4>";
	html += '<p>今日：签到' + shop['checkincount'] + '次'+ ', 照片' + shop['photocount'] + '张' + ', 报告' + shop['commentcount'] + '条</p>';
	html += '<div id="popup-storeDetail" data-id="'+shop['id'] +'"><img src="Public/Styles/images/loading.gif"> 正在获取最新数据</div>';
	html += '<p><a class="btn btn-primary" href="/View-Store.aspx?StoreId=' + shop['id'] + '" title="查看店铺详细信息" target="_blank"><i class="icon-list-alt icon-white"></i></a> <a class="btn btn-inverse" href="/Edit-Store.aspx?storeId=' + shop['id'] + '" target="_blank" title="编辑店铺" target="_blank"><i class="icon-pencil icon-white"></i></a></p>';
	return html;
	
	
}

function getBounds(dataList) {
	var southWest = new L.LatLng(180, 0);
	var northEast = new L.LatLng(0, 180);
	for ( var i = 0; i < dataList.length; i++) {
		lat = dataList[i]._latlng.lat;
		lng = dataList[i]._latlng.lng;
		
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
        return "<div><i class='icon-time'></i> <span>" + createdAt + "</span> <br/> <i class='icon-home'></i> <a href='View-Store.aspx?storeId=" + storeId + "' target='_blank'>" + storeName + "</a>  </div>";
    }
    else {
        return "<div><i class='icon-home'></i> <a href='View-Store.aspx?storeId=" + storeId + "' target='_blank'>" + storeName + "</a>  </div>";
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
	map.closePopup();
	var activeMarkers = [];
	for (index in markerIndexes) {
		var marker = shop_markers[markerIndexes[index]];
		marker['status'] = 'active';
		marker.setIcon(highLightIcon);
		activeMarkers.push(marker);
	}
	if ( markerIndexes.length == 1 ) {
		shop_markers[ markerIndexes[0] ].openPopup();
		getStoreLatestInfo();
	}
	var prop = {};
	if ( markerIndexes.length > 0 ) {
		map.fitBounds(getBounds(activeMarkers));
		prop.count =  markerIndexes.length;
		info.update(prop);
	} else {
		map.fitBounds(getBounds(shop_markers));
		info.update();
	}
	
}
function resetFitBounds(){
	map.fitBounds(getBounds(shop_markers));
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
		error: function(XMLHttpRequest, textStatus, errorThrown) { 
             console.log("Status: " + textStatus); alert("Error: " + errorThrown); 
        }		
		
	});
}
function showStoreLatestInfo(data) {
	var str = "";
	if ( data.trackRecords && (data.trackRecords.length > 0) ) {
		for ( var i in data.trackRecords) {
			str += '<p>'+ data.trackRecords[i].name + ' 签到 ' + '<span class="time">' + data.trackRecords[i].time +'</span>' + '</p>';
		}
	} else {
		str += '<p>无踩点纪录</p>';
	}
	if ( data.photos && (data.photos.length > 0) ) {
		str += '<p id="popup-storeDetail-photos">';
		for ( var i in data.photos) {
			str += '<a rel="lightBox"  href="' + data.photos[i].src +'" ><img src="'+ data.photos[i].src + '" height="60" width="25%" /></a>';
		}
		str += '</p>';
	} else {
		str += '<p>最近无照片</p>';
	}
	
	$('#popup-storeDetail').html(str);
}