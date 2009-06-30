function myField(item){
	this.type = item.type;
	this.name = item.name;
	if(this.type == "checkbox"){
		this.value = item.checked;
	} else {
		this.value = item.value;
	}
}
myField.prototype.toString = function (){
		return "{type: \"" + this.type + "\", name: \"" + this.name + "\", value: \"" + this.value + "\"}";
}
function myForm(id,item) {
	function getFields(form) {
		var result = new Array();
		f = form.getElementsByTagName("input");
		for (var i = 0; i < f.length; i++){
			var obj = new myField(f[i]);
			result.push(obj);
		}
		return result;
	}
	this.id = id;
	this.fields = getFields(item);
}
myForm.prototype.toString = function () {
		return "{id: " + this.id + ", fields: ["+ this.fields.join(", ") + "]}";
}
function dumpForms(){
	var result = [];
	forms = document.forms;
	for (var i = 0; i < forms.length; i++){
		var obj = new myForm(i,forms[i]);
		result.push(obj);
	}
	return result.toString();
}

function setForms(info){
	for (var i in info.fields){
		var item = info.fields[i];
		var field = document.getElementsByName(item.name);
		if(field.length == 1){
			field = field[0];
			if(item.type == "checkbox"){
				field.checked = item.value;
			} else {
				field.value = item.value;
			}
		}
	}
	document.forms[info.id].submit();
}
