function EmployeeView( domId ){
	this.dom = $('#' + domId);
	this.template = $('#' + 'employeeListTemplate');
	this.controller = null;
	
	this.render = function( data ) {
		this.dom.html('');
		if ( data.length < 1 ) {
			$('<li class="employeeItem">' + '没有找到相关员工' + '</li>').appendTo(this.dom);
		} else {
			this.template.tmpl(data).appendTo(this.dom);
		}
	}
	
	this.addShowAllButton = function() {
		$('<li class="employeeItem">' + '<h4>店铺负责人</h4>' + '</li>').prependTo(this.dom);
		$('<li class="employeeItem">' + '<a class="btn btn-primary" id="showAll">显示全部员工</a>' + '</li>').appendTo(this.dom);
	}
	
	this.highLightItems = function(idArray) {
		this.dom.find('.highLight').removeClass('highLight');
		for (var i in idArray) {
			this.dom.find('[data-id="'+ idArray[i] + '"]').addClass('highLight');
		}
	}
	
	var that = this;
	this.dom.on('click', '#showAll',function(){
			that.controller.showAll();
	});
	this.dom.on('click', '.employeeItem',function(){
		that.dom.find('.highLight').removeClass('highLight');
		$(this).addClass('highLight');
		that.controller.highLightRelatedStores( $(this).attr('data-id') );
	});
	
};

function EmployeeModel( data ){
	if ( data == null ) {
		this.data = [];
	} else {
		this.data = data;
	}
	this.showData = this.data;
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
		this.showData = jsonPath(this.showData, "$..[?(" + queryStr + ")]");
		if ( false == this.showData ) {
				this.showData = [];
		}
	}
	
	this.revert = function() {
		this.showData = this.data;
	}
	
	this.findRelatedStore = function(managerId) {
		return jsonPath(this.showData, "$..[?(@.id=="+managerId+")].store.*");
	}
	
	
};

function EmployeeController( model, view ){
	this.model = model;
	this.view = view;
	this.view.controller = this;
	this.storeController = null;
	
	this.init = function( ) {
		this.update();
	};
	
	this.update = function() {
		this.view.render(this.model.showData);
	};
	
	this.reload = function(data) {
		this.model.data = data;
		this.model.revert();
		this.update();
	}
	
	this.onStoreListChange = function(managerIdArray) {
		this.model.filter = managerIdArray;	
		this.model.applyFilter();
		this.update();
		this.view.addShowAllButton();
	}
	this.showAll = function(){
		this.model.revert();
		this.update();
	}
	this.highLightEmployees = function(employeeIdArray) {
		this.view.highLightItems(employeeIdArray);
	}
	this.highLightRelatedStores = function(managerId) {
		var storeIdArray = this.model.findRelatedStore(managerId);
		this.storeController.highLightStores(storeIdArray);
	}
	
	this.init();
	
};

function StoreView( domId ){
	this.dom = $('#' + domId);
	this.template = $("#storeListTemplate");
	this.controller = null;
	
	this.render = function( data ) {
		this.dom.html('');
		if ( data.length < 1 ) {
			$('<li class="storeItem">' + '没有找到相关店铺' + '</li>').appendTo(this.dom);
		} else {
			this.template.tmpl(data).appendTo(this.dom);
		}
	}
	this.highlightItems = function(idArray) {
		this.dom.find('.highLight').removeClass('highLight');
		for (var i in idArray) {
			this.dom.find('[data-id="'+ idArray[i] + '"]').addClass('highLight');
		}
	}
	var that = this;
	this.dom.on('click', '.storeItem',function(){
		that.dom.find('.highLight').removeClass('highLight');
		$(this).addClass('highLight');
		that.controller.highLightRelatedEmployee( $(this).attr('data-id') );
	});
};
function StoreModel( data ){
	if ( data == null ) {
		this.data = [];
	} else {
		this.data = data;
	}
	this.showData = this.data;
	this.filter = {};
	
	this.applyFilter = function() {
		this.revert();
		var filter = this.filter;
		
		for ( var key in filter ) {
			this.showData = jsonPath(this.showData, "$..[?(@." + key + "=="+ filter[key] +")]");
			if ( false == this.showData ) {
				this.showData = [];
				break;
			}
		}
				
	}
	
	this.revert = function() {
		this.showData = this.data;
	}
	this.findAllRelatedEmployee = function(storeId) {
		return jsonPath(this.showData, "$..[?(@.id=="+storeId+")].manager..id");
	}
};
function StoreController( model, view ){
	this.model = model;
	this.view = view;
	this.view.controller = this;
	this.employeeController = null;
	
	this.init = function( ) {
		this.view.render(this.model.showData);
	};
	
	this.update = function() {
		this.view.render(this.model.showData);
	};
	
	this.reload = function(data) {
		this.model.data = data;
		this.model.revert();
		this.update();
	}
	
	this.removeFilter = function(key) {
		delete this.model.filter[key];
		this.model.applyFilter();
		this.update();
		this.updateEmployees();
	}
	this.onFilterChange = function(opt) {
		for ( var key in opt ) {
			this.model.filter[key] = opt[key];
		}	
		this.model.applyFilter();
		this.update();
		this.updateEmployees();
		
	}
	this.updateEmployees = function() {
		var managers = jsonPath(this.model.showData, "$...manager..id");
		if ( managers == false ) {
			managers = [];
		}
		this.employeeController.onStoreListChange(managers);
	}
	this.highLightStores = function(storeIdArray) {
		this.view.highlightItems(storeIdArray);
	}
	this.highLightRelatedEmployee = function( storeId ) {
		var employeeIdArray = this.model.findAllRelatedEmployee(storeId);
		this.employeeController.highLightEmployees(employeeIdArray);
	}
	this.init();
};


$(function(){
	$.ajax({
		dataType: "json",
		url: "Scripts/data.js?" + (new Date().getTime()),
		success: function( data ) {
			employeeController = new EmployeeController(new EmployeeModel(data.employees), new EmployeeView('employeeList') );
			storeController = new StoreController(new StoreModel(data.stores), new StoreView('storeList'));	
					
			storeController.employeeController = employeeController;
			employeeController.storeController = storeController;
			
			generateTestShops(data.stores);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) { 
             alert("Status: " + textStatus); alert("Error: " + errorThrown); 
        }		
		
	});
	
	initMap();
	
	
	$('#ImportanceLevel').change(function(){
		var id = $(this).find(':selected').val();
		if ( id == '0' ) {
			storeController.removeFilter('lvlId');
		} else {
			storeController.onFilterChange({'lvlId':id});
		}
	});
	$('#ChainStoreNames').change(function(){
		var id = $(this).find(':selected').val();
		if ( id == '0' ) {
			storeController.removeFilter('chnId');
		} else {
			storeController.onFilterChange({'chnId':id});
		}
	});
		
	
});