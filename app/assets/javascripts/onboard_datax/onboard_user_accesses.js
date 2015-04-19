// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
	$( "#onboard_user_access_start_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#onboard_user_access_end_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
});

$(function (){
	$('#pid_from').change(function(){
      $.get(window.location, $('form').serialize(), null, "script");
  	  return false;
	});
});

// for search
$(function (){
	$('#onboard_user_access_project_id_s').change(function(){
      $.get(window.location, $('form').serialize(), null, "script");
  	  return false;
	});
});