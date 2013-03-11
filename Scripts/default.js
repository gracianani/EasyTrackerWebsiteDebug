function EmployeeView( domId ){
	this.dom = $('#' + domId);
	this.template = $('#' + 'employeeListTemplate');
	this.model = new EmployeeModel();
	this.storeView = null;
	
	this.init = function( data ) {
		this.model.data = data;
		this.model.revert();
		this.render();
	};
	this.render = function( ) {
		var data = this.model.filteredData;
		this.dom.html('');
		if ( data.length < 1 ) {
			$('<li class="employeeItem">' + '没有找到相关员工' + '</li>').appendTo(this.dom);
		} else {
			this.template.tmpl(data).appendTo(this.dom);
		}
	}
	
	this.onStoreListChange = function(managerIdArray) {
		this.model.filter = managerIdArray;	
		this.model.applyFilter();
		this.render();
		this.addShowAllButton();
	}
	this.addShowAllButton = function() {
		$('<li class="employeeItem">' + '<h4>店铺负责人</h4>' + '</li>').prependTo(this.dom);
		$('<li class="employeeItem">' + '<a class="btn btn-primary" id="showAll">显示全部员工</a>' + '</li>').appendTo(this.dom);
	}
	this.onShowAllClick = function(){
		this.model.revert();
		this.render();
	}
		
	
	
	this.highLightEmployees = function(idArray) {
		this.dom.find('.highLight').removeClass('highLight');
		for (var i in idArray) {
			this.dom.find('[data-id="'+ idArray[i] + '"]').addClass('highLight');
		}
	}
	this.highLightRelatedStores = function(managerId) {
		var storeIdArray = this.model.findRelatedStore(managerId);
		this.storeView.highLightStores(storeIdArray);
	}	
	
	
	var that = this;
	this.dom.on('click', '#showAll',function(){
			that.onShowAllClick();
	});
	this.dom.on('click', '.employeeItem',function(){
		that.dom.find('.highLight').removeClass('highLight');
		$(this).addClass('highLight');
		that.highLightRelatedStores( $(this).attr('data-id') );
	});
	
};

function EmployeeModel( data ){
	if ( data == null ) {
		this.data = [];
	} else {
		this.data = data;
	}
	this.filteredData = this.data;
	this.filter = [];
	
	this.applyFilter = function() {
		this.revert();
		var queryStr = "";
		for (var i in this.filter) {
			if (i > 0 ) {
				queryStr += '||';
			}
			queryStr += "(@." +'id' + "==" + this.filter[i] +")";
		}
		this.filteredData = jsonPath(this.filteredData, "$..[?(" + queryStr + ")]");
		if ( false == this.filteredData ) {
				this.filteredData = [];
		}
	}
	
	this.revert = function() {
		this.filteredData = this.data;
	}
	
	this.findRelatedStore = function(managerId) {
		return jsonPath(this.filteredData, "$..[?(@.id=="+managerId+")].store.*");
	}
	
	
};


function StoreView( domId ){
	this.dom = $('#' + domId);
	this.template = $("#storeListTemplate");
	this.model = new StoreModel();
	this.employeeView = null;
	
	this.init = function( data ) {
		this.model.data = data;
		this.model.revert();
		this.render();
	}
	this.render = function( ) {
		var data = this.model.filteredData;
		this.dom.html('');
		if ( data.length < 1 ) {
			$('<li class="storeItem">' + '没有找到相关店铺' + '</li>').appendTo(this.dom);
			clearOverlays();
		} else {
			this.template.tmpl(data).appendTo(this.dom);
			mapLoadShopData(this.model.filteredData);
		}
	}
	this.onFilterRevert = function(key) {
		delete this.model.filter[key];
		this.model.applyFilter();
		this.render();
		this.updateEmployeeView();
	}
	this.onFilterChange = function(opt) {
		for ( var key in opt ) {
			this.model.filter[key] = opt[key];
		}	
		this.model.applyFilter();
		this.render();
		this.updateEmployeeView();
		
	}
	this.updateEmployeeView = function() {
		var managers = this.model.findRelatedManager();
		if ( managers == false ) {
			managers = [];
		}
		this.employeeView.onStoreListChange(managers);
	}
	this.highLightStores = function(idArray) {
		this.dom.find('.highLight').removeClass('highLight');
		highLightIndexes = [];
		for (var i in idArray) {
			var highLightIndex = this.dom.find('[data-id="'+ idArray[i] + '"]').addClass('highLight').index();
			if ( highLightIndex > -1 ) {
				highLightIndexes.push(highLightIndex);
			}
		}
		highLightMakersByIndex(highLightIndexes);
	}
	this.highLightStoreManagers = function( storeId ) {
		var managersIdArray = this.model.findRelatedManager(storeId);
		this.employeeView.highLightEmployees(managersIdArray);
	}
	var that = this;
	this.dom.on('click', '.storeItem',function(){
		that.dom.find('.highLight').removeClass('highLight');
		$(this).addClass('highLight');
		that.highLightStoreManagers( $(this).attr('data-id') );
		highLightMakersByIndex( [$(this).index()] );
	});
};
function StoreModel( data ){
	if ( data == null ) {
		this.data = [];
	} else {
		this.data = data;
	}
	this.filteredData = this.data;
	this.filter = {};
	
	this.applyFilter = function() {
		this.revert();
		var filter = this.filter;
		
		for ( var key in filter ) {
			this.filteredData = jsonPath(this.filteredData, "$..[?(@." + key + "=="+ filter[key] +")]");
			if ( false == this.filteredData ) {
				this.filteredData = [];
				break;
			}
		}
				
	}
	this.revert = function() {
		this.filteredData = this.data;
	}
	this.findRelatedManager = function(storeId) {
		if ( storeId == null ) {
			return jsonPath(this.filteredData, "$...manager..id");
		} else {
			return jsonPath(this.filteredData, "$..[?(@.id=="+storeId+")].manager..id");
		}
	}
};

function slideLatest() {
	var latest = $('.latest_block');
	latest.filter(':visible').last().hide();
	latest.last().insertBefore(latest.first()).slideDown();
}

var enterTime = new Date().getTime();
function getTrackingsUpdate( ) {
        var employeeId = '56';
        currentTime = new Date().getTime();
        var data = {
            'elasp': currentTime - enterTime,
            'employeeId': employeeId
        };
		console.log(employeeId);

        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: 'Public/Services/MapWebService.asmx/GetTrackingUpdate',
            contentType: 'application/json',
            data: JSON.stringify(data),
            success: function (msg) {
                if (parseInt(msg.d) > 0) {
                    $(".alert").addClass("alert-block").html('<strong><a href="/Default.aspx">有' + msg.d + '个新位置更新，点击查看</a></strong>').show();
                }
            }
        });
 }

$(function () {
	$('#map_canvas').height($(window).height() - 40);	
	$('#employeeContainer').height($(window).height()-40);
	$('#storeList').height($(window).height()-155);
	
    var storeView = new StoreView('storeList');
    var employeeView = new EmployeeView('employeeList');
    storeView.employeeView = employeeView;
    employeeView.storeView = storeView;
    initMap();

    $.ajax({
        type: 'POST',
        dataType: "json",
        url: "Public/Services/MapWebService.asmx/GetLatestUpdates",
        contentType: 'application/json',
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
		
        success: function (data) {
            var stats = $.parseJSON(data.d);
            storeView.init(stats.stores);
            employeeView.init(stats.employees);

            Spinners.get('#spinner').remove();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert("Status: " + textStatus); alert("Error: " + errorThrown);
        }

    });




    $('#ImportanceLevel').change(function () {
        var id = $(this).find(':selected').val();
        if (id == '0') {
            storeView.onFilterRevert('lvlId');
        } else {
            storeView.onFilterChange({ 'lvlId': id });
        }
    });
    $('#ChainStoreNames').change(function () {
        var id = $(this).find(':selected').val();
        if (id == '0') {
            storeView.onFilterRevert('chnId');
        } else {
            storeView.onFilterChange({ 'chnId': id });
        }
    });
	

    $('.lnk_StorePhotos').each(function () {
		var imgSrc = $(this).children("img").attr('src');
		$(this).attr('href', imgSrc);
	});
	
	$($('.latest_block').get(1)).nextAll().hide();
	setInterval(slideLatest,5000);
	setInterval(getTrackingsUpdate,10000);
	$('#latest').on('selectstart',function(e){
		e.preventDefault();
		return false;
	});
});