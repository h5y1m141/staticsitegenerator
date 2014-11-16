$.fn.editable.defaults.mode = 'inline';
$.fn.editable.defaults.ajaxOptions = {type: "GET"};
$(document).ready(function(){
	$('#latitude').editable({
		send:'always',
		params: function(params){
			params.companyName = $('#latitude').attr('data-companyName');
			params.latitude    = $('#latitude').attr('data-latitude');
			params.longitude   = $('#latitude').attr('data-longitude');
			return params;
		}, 
		success: function(response,newvalue) {
			if(response){
				console.log("newvalue is" + newvalue);
				// フォーム内の緯度、経度のそれぞれの要素内に埋め込んでいる緯度の情報を更新
				$('#latitude').attr('data-latitude',newvalue);
				$('#longitude').attr('data-latitude',newvalue);
				$('#latitude').text(newvalue);
			}
		}
	});
	$('#longitude').editable({
		send:'always',
		params: function(params){
			params.companyName = $('#latitude').attr('data-companyName');
			params.latitude    = $('#latitude').attr('data-latitude');
			params.longitude   = $('#latitude').attr('data-longitude');

			return params;
		}, 
		success: function(response,newvalue) {
			if(response){
				console.log("newvalue is" + newvalue);
				// フォーム内の緯度、経度のそれぞれの要素内に埋め込んでいる経度情報を更新
				$('#latitude').attr('data-longitude',newvalue);
				$('#longitude').attr('data-longitude',newvalue);

				$('#longitude').text(newvalue);

			}
		}
	});


});
