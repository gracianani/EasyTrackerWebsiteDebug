function EmployeeView( domId ){
	this.dom = $('#' + domId);
	this.template = $("#employeeListTemplate");
	
	this.render = function( data ) {
		this.dom.html('');
		this.template.tmpl(data).appendTo( this.dom );
	}
	
	this.renderSingle = function( index, data ) {
		var item = this.dom.find('.employeeItem')[index];
		item.html(this.template.tmpl(data).html());
	}
	
};

function EmployeeModel( data ){
	if ( data == null ) {
		this.data = [];
	} else {
		this.data = data;
	}
	
	this.findItem = function( key, value ) {
		$.each(this.data, function(index){
			if ( this[key] == value ) {
				this['show'] = 1;
			} else {
				this['show'] = 0;
			}
		});
	}
	
};

function EmployeeController( model, view ){
	this.model = model;
	this.view = view;
	
	this.init = function( ) {
		this.update();
	};
	
	this.update = function() {
		this.view.render(this.model.data);
	};
	
};



function StoreView( domId ){
	this.dom = $('#' + domId);
	this.template = $("#storeListTemplate");
	
	this.render = function( data ) {
		this.dom.html('');
		this.template.tmpl(data).appendTo( this.dom );
	}
};
function StoreModel( data ){
	if ( data == null ) {
		this.data = [];
	} else {
		this.data = data;
	}
	
	this.findItem = function( key, value ) {
		$.each(this.data, function(index){
			if ( this[key] == value ) {
				this['show'] = 1;
			} else {
				this['show'] = 0;
			}
		});
	}
	this.revert = function() {
		$.each(this.data, function(index){
			this['show'] = 1;
		});
	}
};
function StoreController( model, view ){
	this.model = model;
	this.view = view;
	
	this.init = function( ) {
		this.view.render(this.model.data);
	};
	
	this.update = function() {
		this.view.render(this.model.data);
	};
};

$(function(){
	
	var employees,employeeController,stores, storeController;
	var employeesView = new EmployeeView('employeeList');
	var storeView = new StoreView('storeList');
	$.ajax({
		dataType: "json",
		url: "Scripts/data.js?" + (new Date().getTime()),
		success: function( data ) {
			employees = new EmployeeModel(data.employees);
			employeeController = new EmployeeController(employees, employeesView);
			employeeController.init();
						
			stores = new StoreModel(data.stores);
			storeController = new StoreController(stores, storeView);
			storeController.init();
			
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) { 
             alert("Status: " + textStatus); alert("Error: " + errorThrown); 
        }		
		
	});
	
	$('#ImportanceLevel').change(function(){
		var id = $(this).find(':selected').val();
		if ( id == '0' || id=='') {
			storeController.model.revert();
		} else {
			storeController.model.findItem('lvlId', id);
		}
		storeController.update();
	});
		
	
});