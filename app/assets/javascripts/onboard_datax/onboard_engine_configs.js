// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
	$( "#onboard_engine_config_start_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#onboard_engine_config_end_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
});

// for search
$(function (){
	$('#onboard_engine_config_project_id_s').change(function(){
      $.get(window.location, $('form').serialize(), null, "script");
  	  return false;
	});
});
