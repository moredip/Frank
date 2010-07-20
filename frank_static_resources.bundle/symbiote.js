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
    var overlay = $("div#modal_overlay");
    overlay.width( overlay.parent().width() )
      .height( overlay.parent().height() );

    overlay.show();

    var popup = $('div#chatting_popup');

    popup.css( { left: (overlay.width()/2) - (popup.width()/2),
        top: overlay.height()/2 - popup.height()/2 } );
  },
  hide_chatting_popup: function() {
    $("div#modal_overlay").hide();
  }
}


$(document).ready(function() { 

	$('#dump_button').click( function(){
    //alert('dumping');

    $.ajax({
      type: "POST",
      dataType: "json",
      data: '["DUMMY"]', // a bug in cocoahttpserver means it can't handle POSTs without a body
      url: G.base_url + "/dump",
      success: function(data) {
		$('div#dom_dump').append( JsonTools.convert_json_to_dom( data ) );
		   $("#dom_dump").treeview({
								   collapsed: false
								   });
      },
      error: function(xhr,status,error) {
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
      },
      complete: function(xhr,status) {
        Symbiote.hide_chatting_popup();
      }
    });
  });
});
