//GLOBALS
var G = {
  base_url: "http://localhost:37265"
};

var Symbiote = {
  is_error_response: function( response ){
    return 'ERROR' == response.outcome;
  },
  display_error_response: function( response ){
    alert( "Frank isn't happy: "+response.reason+"\n"
        +"details: "+response.details );
  },
  display_chatting_popup: function() {
    
    $('#loading').show();
  },
  hide_chatting_popup: function() {
    $('#loading').hide();
  }
}

function classClicked(link){    
    var command = {
      query: "view marked:'" + link.innerHTML + "'",
      operation: {
        method_name: 'flash',
        arguments: []
      }
    };

    Symbiote.display_chatting_popup();
    $.ajax({
      type: "POST",
      dataType: "json",
      data: JSON.stringify( command ),
      url: G.base_url + "/map",
      success: function(data) {
        if( Symbiote.is_error_response( data ) )
          Symbiote.display_error_response( data );
      },
      error: function(xhr,status,error) {
        Symbiote.hide_chatting_popup();
        alert( "Error while talking to Frank: " + status );
      },
      complete: function(xhr,status) {
        Symbiote.hide_chatting_popup();
      }
    });
  }

$(document).ready(function() { 
	$("#tabs").tabs();
	$('#loading').hide();
	$('#dump_button').click( function(){
	 Symbiote.display_chatting_popup();

    $.ajax({
      type: "POST",
      dataType: "json",
      data: '["DUMMY"]', // a bug in cocoahttpserver means it can't handle POSTs without a body
      url: G.base_url + "/dump",
      success: function(data) {
		$('div#dom_dump').html( JsonTools.convert_json_to_dom( data ) );
		   $("#dom_dump").treeview({
								   collapsed: false
								   });
		 Symbiote.hide_chatting_popup();						   
      },
      error: function(xhr,status,error) {
        $('#loading').hide();
        alert( "Error while talking to Frank: " + status );
      }
    });
    
    $.ajax({
      type: "POST",
      dataType: "json",
      data: '["DUMMY"]', // a bug in cocoahttpserver means it can't handle POSTs without a body
      url: G.base_url + "/inspect",
      success: function(data) {
		$('#loading').hide();
		var test = eval(data);
		var html = '<table id="accessibility">';
        html +=	'<tr><th>Marked (accessibilityLabel)</th><th>Class</th></tr>';
        	
		for (index in test)
  		{
  			var elem = test[index];
  			html += '<tr><td><a onClick="javascript: classClicked(this);" href="#">' + elem.label+ '</a></td><td>' + elem.class + '</td></tr>';
  		}
		html += '</table>';
		$('div#access_dump').html(html);
      },
      error: function(xhr,status,error) {
      $('#loading').hide();
        alert( "Error while talking to Frank: " + status );
      }
    });
    
  });

  $('#flash_button').click( function(){
    var command = {
      query: $("input#query").val(),
      operation: {
        method_name: 'flash',
        arguments: []
      }
    };

    Symbiote.display_chatting_popup();
    $.ajax({
      type: "POST",
      dataType: "json",
      data: JSON.stringify( command ),
      url: G.base_url + "/map",
      success: function(data) {
        if( Symbiote.is_error_response( data ) )
          Symbiote.display_error_response( data );
      },
      error: function(xhr,status,error) {
        alert( "Error while talking to Frank: " + status );
        $('#loading').hide();
      },
      complete: function(xhr,status) {
        Symbiote.hide_chatting_popup();
      }
    });
  });
  
  
});
