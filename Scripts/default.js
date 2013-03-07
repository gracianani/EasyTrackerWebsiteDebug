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
	
	this.renderSingle = function( index, data ) {
		var item = this.dom.find('.employeeItem')[index];
		item.html(this.template.tmpl(data).html());
	}
	
	this.addShowAllButton = function() {
		$('<li class="employeeItem">' + '<h4>店铺负责人</h4>' + '</li>').prependTo(this.dom);
		$('<li class="employeeItem">' + '<a class="btn btn-primary" id="showAll">显示全部员工</a>' + '</li>').appendTo(this.dom);
	}
	
	var that = this;
	this.dom.on({
		'click #showAll':function(){
			that.controller.showAll();
		}
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
	
	
};

function EmployeeController( model, view ){
	this.model = model;
	this.view = view;
	this.view.controller = this;
	
	this.init = function( ) {
		this.update();
	};
	
	this.update = function() {
		this.view.render(this.model.showData);
	};
	
	
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
	this.init();
	
};

function StoreView( domId ){
	this.dom = $('#' + domId);
	this.template = $("#storeListTemplate");
	
	this.render = function( data ) {
		this.dom.html('');
		if ( data.length < 1 ) {
			$('<li class="storeItem">' + '没有找到相关店铺' + '</li>').appendTo(this.dom);
		} else {
			this.template.tmpl(data).appendTo(this.dom);
		}
	}
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
};
function StoreController( model, view ){
	this.model = model;
	this.view = view;
	this.employeeController = null;
	
	this.init = function( ) {
		this.view.render(this.model.showData);
	};
	
	this.update = function() {
		this.view.render(this.model.showData);
	};
	
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
		employeeController.onStoreListChange(managers);
	}
	this.init();
};

$(function(){
	
	
	var storeFilter = [];
	$.ajax({
		dataType: "json",
		url: "Scripts/data.js?" + (new Date().getTime()),
		success: function( data ) {
			employeeController = new EmployeeController(new EmployeeModel(data.employees), new EmployeeView('employeeList') );
			storeController = new StoreController(new StoreModel(data.stores), new StoreView('storeList'));			
			storeController.employeeController = employeeController;
			
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) { 
             alert("Status: " + textStatus); alert("Error: " + errorThrown); 
        }		
		
	});
	
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