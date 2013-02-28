
var storeName = '#fv_Store input[id$=tb_StoreName]';
var alias = '#fv_Store input[id$=tb_Alias]';
var street1 = '#fv_Store input[id$=tb_Street1]';
var street2 = '#fv_Store input[id$=tb_Street2]';
var district = '#fv_Store input[id$=tb_District]';
var city = '#fv_Store input[id$=tb_City]';
var provience = '#fv_Store input[id$=tb_Provience]';
var latitude = '#fv_Store input[id$=tb_Latitude]';
var longitude = '#fv_Store input[id$=tb_Longitude]';
var phoneNumber = '#fv_Store input[id$=tb_StorePhoneNumber]';
var firstName = 'input[id$=tb_FirstName]';
var lastName = 'input[id$=tb_LastName]';
var email = 'input[id$=tb_Email]';
var userPhoneNumber = 'input[id$=tb_PhoneNumber]';
var importanceLevel = 'select[id$=ddl_ImportanceLevel]';
var chainStoreId = 'select[id$=ddl_ChainStoreId]';
var managerId = 'select[id$=ManagerId]';

var userName = 'input[id$=tb_UserName]';
var userId = 'input[id$=tb_EmployeeName]';
var storeId = 'input[id$=tb_Store]';
var storeIdList = 'input[id$=hf_storeIdAll]';
var userTaskDescription = '#txt_UserTaskDescription';

var city_editing = 'input[id$=tb_City_%s]';
var street1_editing = 'input[id$=tb_Street1_%s]';
var street2_editing = 'input[id$=tb_Street2_%s]';
var district_editing = 'input[id$=tb_District_%s]';
var latitude_editing = 'input[id$=tb_Latitude]:eq(%s)';
var longitude_editing = 'input[id$=tb_Longitude]:eq(%s)';
var editing_index;
var user_autoComplete;
var store_autoComplete;
var district_autoComplete;
var map;

function getInfoWindowHtml(address, response) {
   
    var btn_set_location = $('<a href="javascript:void(0)" class="btn btn-small btn-info" >选择这个地址</a>').click(function () {
        response(address.geometry.location);
   
    });
    var main_content = $('<div style="width:150px"></div>').html(address.formatted_address);
    return main_content.append(btn_set_location)[0];
    

}

function initMap() {
    map = L.map('map_canvas').setView([39.943600973165736, 116.31285667419434], 13);
    var mpn = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');
    var qst = new L.TileLayer('http://otile1.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png', { attribution: 'Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">' });
    map.addLayer(mpn);
    map.addLayer(qst);
    map.addControl(new L.Control.Layers({ 'Mapnik': mpn, 'MapQuest': qst, 'Google': new L.Google() }));
    
}


function initMap(lat, lng) {
    map = L.map('map_canvas').setView([39.943600973165736, 116.31285667419434], 13);
    var mpn = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');
    var qst = new L.TileLayer('http://otile1.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png', { attribution: 'Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">' });
    map.addLayer(mpn);
    map.addLayer(qst);
    map.addControl(new L.Control.Layers({ 'Mapnik': mpn, 'MapQuest': qst, 'Google': new L.Google() }));
    if (lat != null && typeof (lat) != 'undefined' && lng != null && typeof (lng) != 'undefined') {
        map.setView([$(lat).val(), $(lng).val()], 13);
        var marker = L.marker([$(lat).val(), $(lng).val()], { draggable: true }).addTo(map);
        marker.on('dragend', function (e) {
            $(lat).val(marker.getLatLng().lat);
            $(lng).val(marker.getLatLng().lng);
        });
    }
}

function initTaskEdit() {
    $('.icon-remove').click(function () {
        var storeId = $(this).parent().attr('data-storeId');
        var values = $('input[id$=hf_storeIdAll]').val().split(",");
        var index = $.inArray(storeId, values);
        values.splice(index, 1);
        $('input[id$=hf_storeIdAll]').val(values.join(","));
        $(this).parent().remove();
    });
}

function geocode(response, latLng) {
    var geocoder = new google.maps.Geocoder();
    var lat = $(latLng.lat).val();
    var lng = $(latLng.lng).val();
    var latlng = new google.maps.LatLng(lat, lng);
    geocoder.geocode({ 'latLng': latlng }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            map.setView([lat, lng], 13);
            var marker = L.marker([lat, lng], { draggable: true }).addTo(map);
            var html = getInfoWindowHtml(results[0], response);
            marker.bindPopup(html);
            marker.on('dragend', function (e) {
                $(latLng.lat).val(marker.getLatLng().lat);
                $(latLng.lng).val(marker.getLatLng().lng);
            });
            response(results[0].geometry.location);
        }
    });
}
function reverseGeocode(address, response) {
    var geocoder = new google.maps.Geocoder();

    geocoder.geocode({ 'address': address }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            if (results.length > 0) {
                var i = 0;
                map.setView([results[0].geometry.location.lat(), results[0].geometry.location.lng()], 13);

                for (i = 0; i < results.length; i++) {
                    var marker = L.marker([results[i].geometry.location.lat(), results[i].geometry.location.lng()], { draggable: true }).addTo(map);
                    var html = getInfoWindowHtml(results[i], response);
                    marker.bindPopup(html);
                    marker.on('dragend', function (e) {
                        $(latitude).val(marker.getLatLng().lat);
                        $(longitude).val(marker.getLatLng().lng);
                    });
                    response(results[i].geometry.location);
                }
            }
        } else {
            alert("Geocoder failed due to: " + status);
        }
    });
}

function insert(getdata, data_url, post_back_command_name, ui_dialog) {
    $.ajax({
        url: data_url,
        contentType: 'application/json',
        type: 'Post',
        dataType: 'json',
        data: JSON.stringify(getdata()),
        success: function (d) {
            console.log(d.d);
            var result = d.d;
            if (result.Status == true) {
                $(ui_dialog).dialog('close');
                __doPostBack(post_back_command_name, "");
            }
            else {
                alert(result.Message);
                $('span[id$=cv_UserName]').show();
            }
        }
    });
}

function getUserData() {
    data = { 
        'firstName': $(firstName).val(),
        'lastName': $(lastName).val(),
        'phoneNumber': $(userPhoneNumber).val(),
        'userName': $(userName).val()
    };
    return data;
}

function getStoreData() {
    data = {
        'storeName': $(storeName).val(),
        'alias' : $(alias).val(),
        'street1': $(street1).val(),
        'street2': $(street2).val(),
        'district': $(district).val(),
        'city': $(city).val(),
        'provience': $(provience).val(),
        'latitude': $(latitude).val(),
        'longitude': $(longitude).val(),
        'phoneNumber': $(phoneNumber).val(),
        'importanceLevel': $(importanceLevel).val(),
        'chainStoreId' : $(chainStoreId).val(), 
        'managerId' : $(managerId).val()
    };
    return data;
}
function getTaskData() {
    data = {
        'userId': $(userId).attr('data-value'),
        'storeIdList': $(storeIdList).val(),
        'userTaskDescription': $(userTaskDescription).val()
    };
    return data;
}
function createInsertDialog(ui_dialog, ui_btn_create, options) {
	if ( $(ui_dialog).size() < 1 ) {
		return;
	}
    $(ui_btn_create).click(function () {
        $(ui_dialog).dialog("open");
        if (typeof (options.has_map) != '' && typeof (options.has_map) != 'undefined') {
           
                initMap();
        } 
    });
    $(ui_dialog).dialog({
        autoOpen: false,
        height: options.height,
        width: options.width,
        modal: true,
        buttons: {
            "创建": function () { if (validate(options.validate_group)) { insert(options.data, options.data_url, options.postback_command_name, ui_dialog); } },
            "取消": function () { $(ui_dialog).dialog('close'); }
        }
    });
}

function validate(validategroup) {

    var isvalid = true;
    $.each(Page_Validators, function (index) {

        ValidatorValidate(Page_Validators[index], validategroup);
        if( Page_Validators[index].isvalid == false) {
            isvalid = false;
        }
    });
    return isvalid;
}
function bindAutoComplete(ui, url_data, append, appendStoresByUser) {
    return $(ui).bind("keydown", function (event) {

        if (event.keyCode === $.ui.keyCode.TAB || event.keyCode === $.ui.keyCode.ENTER) {
            event.preventDefault();
        }
    }).autocomplete({
        delay: 0,
        source: function (request, response) {
            $.ajax({
                type: "POST",
                url: url_data,
                dataType: "json",
                data: JSON.stringify({
                    'maxRows': 12,
                    'name_startsWith': request.term
                }),
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    var candidates = $.parseJSON(data.d);
                    response($.map(candidates, function (item) {
                        return { label: item.Text, value: item.Text, id: item.Value }
                    }));
                }
            });
        },
        select: function (event, data) {
            $(ui).attr('data-value', data.item.id);
            if (typeof (append) != 'undefined' && append == true) {
                if ($.inArray(data.item.id.toString(), $('input[id$=hf_storeIdAll]').val().split(",")) == -1) {
                    $(ui).parentsUntil('table').find('div.storeNames').append($('<span class="label label-warning" ></span>').html(data.item.value + ' <i class="icon-remove icon-white"></i>'));
                    var values = $('input[id$=hf_storeIdAll]').val().split(",");
                    values.push(data.item.id.toString());
                    $('input[id$=hf_storeIdAll]').val(values.join(","));
                }
                $('input[id$=tb_Store]').val('');
                event.preventDefault();
            }
            if (typeof (appendStoresByUser) != 'undefined' && appendStoresByUser == true) {
                $.ajax({
                    type: "POST",
                    url: "Public/Services/Manage.asmx/GetTasksByEmployeeId",
                    dataType: "json",
                    data: JSON.stringify({ 'userId': data.item.id }),
                    contentType: "application/json; charset=utf-8",
                    success: function (taskData) {
                        var stores = $.parseJSON(taskData.d);
                        var storeIds = [];
                        $.each(stores, function (index, value) {
                            storeIds.push(value.StoreId);

                            $(ui).parentsUntil('table').find('div.storeNames').append($('<span class="label label-warning" style="float:left;margin-bottom:2px"></span>').html(value.StoreName + ' <i class="icon-remove icon-white"></i>'));
                        });
                        $('input[id$=hf_storeIdAll]').val(storeIds.join(",")); initTaskEdit();
                    }
                });
            }
        }
    });
}

(function () {
    createInsertDialog('#fv_Employee', 'a[id$=btn_CreateUser]', {
        width:350, 
        height:360, 
        data: getUserData, 
        data_url: 'Public/Services/Manage.asmx/Insert',
        postback_command_name : 'InsertUser',
        validate_group: 'insertuser'});
    createInsertDialog('#fv_Store', 'a[id$=btn_CreateStore]' ,{
        width:760, 
        height:Math.round($(window).height() * 0.8),
        data: getStoreData,
        data_url: 'Public/Services/Manage.asmx/InsertStore',
        postback_command_name : 'InsertStore',
        validate_group: 'insertstore',
        has_map: true});
    createInsertDialog('#fv_EmployeeTask', 'a[id$=btn_CreateUserTask]', {
        width:500, 
        height:420,
        data: getTaskData,
        data_url: 'Public/Services/Manage.asmx/InsertUserTask',
        postback_command_name : 'InsertUserTask',
        validate_group: 'insertusertask'});

    $('.ddl-menu-item').click(function() {
        
        $('#txt_UserTaskDescription').val( $('#txt_UserTaskDescription').val() + '* '+ $(this).html() + '\n') ;
    });
})($);



$(document).ready(function () {

    var anchorname = location.hash;
    if (anchorname != undefined && anchorname != null && anchorname != '') {
        var tabname = anchorname.replace('#', '#tab_');
        $(tabname).tab('show');
    }

    district_autoComplete = bindAutoComplete('input[id$=tb_District]', "Public/Services/Manage.asmx/GetDistricts");
    user_autoComplete = bindAutoComplete('input[id$=tb_EmployeeName]', "Public/Services/Manage.asmx/GetEmployeeName", false, true);
    store_autoComplete = bindAutoComplete('input[id$=tb_Store]', "Public/Services/Manage.asmx/GetStoreName", true);
    $('#btn_locateStore').live('click', function () {
        if ($(latitude).val() != '' && $(longitude).val() != '') {
            geocode(setLatLng, { 'lat': latitude, 'lng': longitude });
        }
        else {
            reverseGeocode($(city).val() + $(district).val() + $(street1).val() + $(street2).val(), setLatLng);
        }
    });

    $('#btn_GetAddress').live('click', function () {
        var rawaddress = trim($('#ipt_RawAddress').val());
        if (rawaddress != '') {
            setAddress(rawaddress);
        }
    });


});
function trim(raw) {
	return raw.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}
function setAddress(rawaddress) {
	var country, province, city, district, street='', housenumber='';
	reg_country = /中国/;
	reg_province = /[\u4e00-\u9fa5]+?省/;
	reg_city = /[\u4e00-\u9fa5]+?市(?!场)/;
	reg_district = /[\u4e00-\u9fa5]+?区/;
    reg_dao = /[\u4e00-\u9fa5]+?道/;
    reg_hutong = /[\u4e00-\u9fa5]+?胡同/;
    reg_nongtang = /[\u4e00-\u9fa5]+?弄堂/;
    reg_jie = /[\u4e00-\u9fa5]+?街/;
    reg_xiang = /[\u4e00-\u9fa5]+?巷/;
    reg_lu = /[\u4e00-\u9fa5]+?路/;
    reg_cun = /[\u4e00-\u9fa5]+?村/;
    reg_zhen = /[\u4e00-\u9fa5]+?镇/;
	reg_li = /[\u4e00-\u9fa5]+?[东|西|南|北]里/;
    reg_hao = /^[甲|乙|丙|0-9|-]+?号(楼)?/;
    reg_point = /[\u4e00-\u9fa5]+?(?:广场|酒店|饭店|宾馆|中心|大厦|百货|大楼|商城|市场|家园|花园|山庄|佳园|写字楼|小区)/;
    reg_ditie = /[地|城]铁[\u4e00-\u9fa5]+?线(?:[\u4e00-\u9fa5]+?站)?/;
	
	country = rawaddress.match(reg_country);
	if ( country != null ) {
		rawaddress = getSlicedAddress(rawaddress, country[0]);
	}
	
	province = rawaddress.match(reg_province);
	if ( province != null ) {
		rawaddress = getSlicedAddress(rawaddress, province[0]);
	}
	
	city = rawaddress.match(reg_city);
	if ( city != null ) {
		rawaddress = getSlicedAddress(rawaddress, city[0]);
	}
	
	district = rawaddress.match(reg_district);
	if ( district != null ) {
		rawaddress = getSlicedAddress(rawaddress, district[0]);
		$('input[id$=tb_District]').val(district[0]);
	}
	dao = rawaddress.match(reg_dao);
	if ( dao != null ) {
		rawaddress = getSlicedAddress(rawaddress, dao[0]);
		street += dao[0] + ' ';
	}
	
	hutong = rawaddress.match(reg_hutong);
	if ( hutong != null) {
		rawaddress = getSlicedAddress(rawaddress, hutong[0]);
		street += hutong[0] + ' ';
	}
	
	nongtang = rawaddress.match(reg_nongtang);
	if (nongtang != null) {
	rawaddress = getSlicedAddress(rawaddress, nongtang[0]);
	street += nongtang[0] + ' ';
	}

	jie = rawaddress.match(reg_jie);
	if (jie != null) {
	rawaddress = getSlicedAddress(rawaddress, jie[0]);
	street += jie[0] + ' ';
	}
	
	xiang = rawaddress.match(reg_xiang);
	if (xiang != null) {
	rawaddress = getSlicedAddress(rawaddress, xiang[0]);
	street += xiang[0] + ' ';
	}
	
	lu = rawaddress.match(reg_lu);
	if (lu != null) {
	rawaddress = getSlicedAddress(rawaddress, lu[0]);
	street += lu[0] + ' ';
	}
	cun = rawaddress.match(reg_cun);
	if (cun != null) {
	rawaddress = getSlicedAddress(rawaddress, cun[0]);
	street += cun[0] + ' ';
	}
	zhen = rawaddress.match(reg_zhen);
	if (zhen != null) {
	rawaddress = getSlicedAddress(rawaddress, zhen[0]);
	street += zhen[0] + ' ';
	}
	li = rawaddress.match(reg_li);
	if (li != null) {
		rawaddress = getSlicedAddress(rawaddress, li[0]);
		street += li[0];
	}
	hao = rawaddress.match(reg_hao);
	if (hao != null) {
	rawaddress = getSlicedAddress(rawaddress, hao[0]);
	housenumber += hao[0] + ' ';
	}	
	point = rawaddress.match(reg_point);
	if (point != null) {
	rawaddress = getSlicedAddress(rawaddress, point[0]);
	housenumber += point[0] + ' ';
	}
	ditie = rawaddress.match(reg_ditie);
	if (ditie != null) {
	rawaddress = getSlicedAddress(rawaddress, ditie[0]);
	housenumber += ditie[0] + ' ';
	}
	
	housenumber += rawaddress;

	$('input[id$=MainContent_tb_Street1]').val(street);
	$('input[id$=MainContent_tb_Street2]').val(housenumber);
	
	$('#btn_locateStore').click();
	
	
}
function getSlicedAddress(rawaddress, recognisedaddress) {
	return rawaddress.slice(rawaddress.search(recognisedaddress) + recognisedaddress.length, rawaddress.length);
}

function getLatLng(index) {
    editing_index = index;
    geocode(setLatLngEditing, { 'lat': sprintf(latitude_editing, editing_index), 'lng': sprintf(longitude_editing, editing_index) });
  //reverseGeocode($(sprintf(city_editing, index)).val() + $(sprintf(district_editing, index)).val() + $(sprintf(street1_editing, index)).val() + $(sprintf(street2_editing, index)).val(), setLatLngEditing);
}

function setLatLng(latlng)
{
    $(latitude).val(latlng.lat());
    $(longitude).val(latlng.lng());
}

function setLatLngEditing(latlng) {
    $(sprintf(latitude_editing, editing_index)).val(latlng.lat());
    $(sprintf(longitude_editing, editing_index)).val(latlng.lng());
}

function DropDownListToPills(listSelector) {
		var dropDown = $(listSelector);
		var pillsId = dropDown.attr('id') + "-pills";
		
		var pills = $('<ul></ul>').attr('class','nav nav-pills').attr('id',pillsId);
		
		dropDown.find('option').each(function(){
			$this = $(this);
			var liClass = '';
			if ($this.is(':selected')) {
				liClass = 'active';
			}
			$('<li class="'+ liClass +'"><a href="javascript:void(0)" data-value="'+$this.val()+'">'+ $this.html()+'</a></li>').appendTo(pills);
		});
		dropDown.hide();
		dropDown.after(pills);
		
		$('#'+pillsId+' a').click(function (e) {
		  e.preventDefault();
		  dropDown.find('option[value="'+$(this).attr('data-value')+'"]').attr('selected',true);
		  dropDown.change();
		})
}