//= require jquery/dist/jquery
//= require chosen-jquery
String.prototype.capitalize = function() {
  return this.replace(/(?:^|\s)\S/g, function(a) { return a.toUpperCase(); });
};
$(function(){
	$(".chosen-select").chosen()
})