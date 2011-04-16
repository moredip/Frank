//GLOBALS
var G = {
  base_url: window.location.protocol + "//" + window.location.host
};

var Symbiote = {
  is_error_response: function( response ){
    return 'ERROR' === response.outcome;
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
};

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

  var $domDetails = $('#dom_detail'),
      $domList = $('div#dom_dump > ul'),
      $domAccessibleDump = $('div#accessible-views'),
      INTERESTING_PROPERTIES = ['class', 'accessibilityLabel', 'tag', 'alpha', 'isHidden'];




  function sendFlashCommand( selector ) {
    var command = {
      query: selector,
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
  }



  function displayDetailsFor( view ) {
    console.debug( 'displaying details for:', view );

    $table = $('<table/>');

    function tableRow( propertyName, propertyValue, cssClass ){
      if( propertyValue === null ){
        propertyValue = 'null';
      }else if( typeof propertyValue === 'object' ){ 
        propertyValue = JSON.stringify(propertyValue);
      } 

      return $('<tr/>').addClass(cssClass)
        .append( 
          $('<td/>').text(propertyName),
          $('<td/>').text(propertyValue) )
        .appendTo( $table );
    }

    
    _.each( INTERESTING_PROPERTIES, function(propertyName) {
      if( !view.hasOwnProperty(propertyName) ){ return; }

      var propertyValue = view[propertyName];
      $table.append( tableRow( propertyName, propertyValue, 'interesting' ) );
    });


    _.each( _.keys(view).sort(), function(propertyName) {
      if( propertyName == 'subviews' ){ return }
      if( _.contains( INTERESTING_PROPERTIES, propertyName ) ){ return; } // don't want to include the interesting properties twice

      var propertyValue = view[propertyName];
      $table.append( tableRow( propertyName, propertyValue ) );
    });

    $domDetails.children().remove();
    $table.appendTo( $domDetails );
  }

  function treeElementSelected(){
    var $this = $(this),
        selectedView = $this.data('rawView');
    displayDetailsFor( selectedView );

    $('a',$domList).removeClass('selected');
    $this.addClass('selected');
  }


  function transformDumpedViewToListItem( rawView ) {
    var title = ""+rawView['class'];
    if( rawView.accessibilityLabel )
      title = title + ": '"+rawView.accessibilityLabel+"'";

    var viewListItem = $("<li><a>"+title+"</a></li>"),
    subviewList = $("<ul/>");

    $('a',viewListItem).data( 'rawView', rawView );

    $.each( rawView.subviews, function(i,subview) {
      subviewList.append( transformDumpedViewToListItem( subview ) );
    });
    
    viewListItem.append( subviewList );
    return viewListItem; 
  };


  function updateDumpView( data ) {
    $domList.children().remove();
    $domList.append( transformDumpedViewToListItem( data ) );
    $('a', $domList ).bind( 'click', treeElementSelected );
    $domList.treeview({
                 collapsed: false
                 });
  }

  function collectAccessibleViews( view )
  {
    var accessibleSubElements = _.flatten( _.map( view.subviews, function(subview) {
      return collectAccessibleViews( subview );
    }) );

    if( view.accessibilityLabel ) {
      return [view].concat( accessibleSubElements );
    }else{
      return accessibleSubElements;
    }
  }

  function selectorForAccessibleView( view ) {
    return "view:'"+view.class+"' marked:'" + view.accessibilityLabel + "'";
  }

  function updateAccessibleViews( data ) {
    var accessibleViews = collectAccessibleViews( data );
        	
    $domAccessibleDump.children().remove();

    _.each( accessibleViews, function( view ) {
      var selector = selectorForAccessibleView(view);
      $('<div><a href="#" title="'+selector+'"><span class="viewClass">'+view.class+'</span> with label "<span class="viewLabel">'+view.accessibilityLabel+'</span>"</a></div>')
        .click( function(){
          sendFlashCommand( selector );
          return false;
        })
        .appendTo( $domAccessibleDump );
    });
  }

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
        console.debug( 'dump returned', data );
        updateDumpView( data );
        updateAccessibleViews( data );
        Symbiote.hide_chatting_popup();						   
      },
      error: function(xhr,status,error) {
        $('#loading').hide();
        alert( "Error while talking to Frank: " + status );
      }
    });
  });

  $('#flash_button').click( function(){
    sendFlashCommand( $("input#query").val() );
  });
  
  // do initial DOM dump straight after page has finished loading
  $('#dump_button').click();
  
});
