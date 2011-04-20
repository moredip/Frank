/*jslint browser: true, white: false, devel: true */
/*global window: true, Raphael: true, $: true, _: true */


var symbiote = {};

symbiote.baseUrlFor = function(path){ return window.location.protocol + "//" + window.location.host + "/" + path; };

symbiote.UiLocator = function(){
  var paper = new Raphael( 'ui-locator-view', 370, 720 ),
      viewIndicator = { remove: _.identity },
      screenshotUrl = symbiote.baseUrlFor( "screenshot" ),
      backdrop = { remove: _.identity },
      deviceBackground = paper.rect( 6, 6, 360, 708, 40 ).attr( {
        'fill': 'black',
        'stroke': 'gray',
        'stroke-width': 4,
      });

  paper.circle( 180+6, 655, 34 ).attr( 'fill', '90-#303030-#101010' ); // home button
  paper.rect( 180+6, 655, 22, 22, 5 ).attr({  // square inside home button
    'stroke': 'gray',
    'stroke-width': 2,
  }).translate( -11, -11 ); 

  function showViewLocation( view ) {
    viewIndicator.remove();

    viewIndicator = paper.rect( 
      view.accessibilityFrame.origin.x, 
      view.accessibilityFrame.origin.y, 
      view.accessibilityFrame.size.width, 
      view.accessibilityFrame.size.height
    )
      .attr({
        fill: '#aaff00',
        opacity: 0.8,
        stroke: 'black',
      })
      .translate( 24, 120 );
  }

  function hideViewLocation() {
    viewIndicator.remove();
  }

  function updateBackdrop(){
    var cacheBusterUrl = screenshotUrl+"?"+(new Date()).getTime();
    backdrop.remove();
    backdrop = paper.image( cacheBusterUrl, 24, 120, 320, 480 );
  }

  return {
    showViewLocation: showViewLocation,
    hideViewLocation: hideViewLocation,
    updateBackdrop: updateBackdrop,
  };
};

symbiote.LiveView = function(updateViewFn,updateHeirarchyFn){

  var viewTimer,heirTimer;

  function stop(){
    window.clearInterval(viewTimer);
    window.clearInterval(heirTimer);
  }

  function start(){
    stop(); // stop any existing timer

    viewTimer = window.setInterval( function(){
      updateViewFn();
    }, 700 );
    heirTimer = window.setInterval( function(){
      updateHeirarchyFn();
    }, 2000 );
  }

  return {
    start: start,
    stop: stop
  };
};


$(document).ready(function() { 

  var $domDetails = $('#dom_detail'),
      $domList = $('div#dom_dump > ul'),
      $domAccessibleDump = $('div#accessible-views'),
      $loading = $('#loading'),
      INTERESTING_PROPERTIES = ['class', 'accessibilityLabel', 'tag', 'alpha', 'isHidden'],
      uiLocator = symbiote.UiLocator(),
      liveView;




	$("#list-tabs").tabs();
	$("#inspect-tabs").tabs();

  function selectViewDetailsTab(){
    $("#inspect-tabs").tabs('select', 0);
  }
  function selectLocatorTab(){
    $("#inspect-tabs").tabs('select', 1);
  }


  function isErrorResponse( response ){
    return 'ERROR' === response.outcome;
  }

  function displayErrorResponse( response ){
    alert( "Frank isn't happy: "+response.reason+"\n" +
        "details: "+response.details );
  }

  function showLoadingUI() {
    $loading.show();
  }

  function hideLoadingUI() {
    $loading.hide();
  }


  function displayDetailsFor( view ) {
    console.debug( 'displaying details for:', view );

    var $table = $('<table/>');

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
      if( propertyName === 'subviews' ){ return; }
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
    selectViewDetailsTab();

    $('a',$domList).removeClass('selected');
    $this.addClass('selected');
  }

  function treeElementEntered(){
    var view = $(this).data('rawView');
    uiLocator.showViewLocation( view );
  }

  function treeElementLeft(){
    uiLocator.hideViewLocation();
  }

  function listItemTitleFor( rawView ) {
    var title = ""+rawView['class'];
    if( rawView.accessibilityLabel ) {
      return title + ": '"+rawView.accessibilityLabel+"'";
    }else{
      return title;
    }
  }

  function transformDumpedViewToListItem( rawView ) {
    var title = listItemTitleFor( rawView ),
        viewListItem = $("<li><a>"+title+"</a></li>"),
        subviewList = $("<ul/>");

    $('a',viewListItem).data( 'rawView', rawView );

    _.each( rawView.subviews, function(subview) {
      subviewList.append( transformDumpedViewToListItem( subview ) );
    });
    
    viewListItem.append( subviewList );
    return viewListItem; 
  }

  function updateDumpView( data ) {
    $domList.children().remove();
    $domList.append( transformDumpedViewToListItem( data ) );
    $('a', $domList ).bind( 'click', treeElementSelected );
    $('a', $domList ).bind( 'mouseenter', treeElementEntered );
    $('a', $domList ).bind( 'mouseleave', treeElementLeft );
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
    return _.template( 
        "view:'<%=viewClass%>' marked:'<%=viewLabel%>'", 
        { viewClass: view['class'], viewLabel: view.accessibilityLabel }
        );
  }






  function sendFlashCommand( selector ) {
    var command = {
      query: selector,
      operation: {
        method_name: 'flash',
        arguments: []
      }
    };

    showLoadingUI();
    $.ajax({
      type: "POST",
      dataType: "json",
      data: JSON.stringify( command ),
      url: symbiote.baseUrlFor( "/map" ),
      success: function(data) {
        if( isErrorResponse( data ) ) {
          displayErrorResponse( data );
        }
      },
      error: function(xhr,status,error) {
        alert( "Error while talking to Frank: " + status );
      },
      complete: function(xhr,status) {
        hideLoadingUI();
      }
    });
  }

    function updateAccessibleViews( data ) {
    var accessibleViews = collectAccessibleViews( data ),
        divTemplate = _.template( '<div><a href="#" title="<%=selector%>"><span class="viewClass"><%=viewClass%></span> with label "<span class="viewLabel"><%=viewLabel%></span>"</a></div>' );

    $domAccessibleDump.children().remove();

    _.each( accessibleViews, function( view ) {
      var selector = selectorForAccessibleView(view),
          divHtml = divTemplate({ selector: selector, viewClass: view['class'], viewLabel: view.accessibilityLabel });

      $(divHtml)
        .click( function(){
          sendFlashCommand( selector );
          return false;
        })
        .appendTo( $domAccessibleDump );
    });
  }


  function refreshViewHeirarchy(){
    showLoadingUI();

    $.ajax({
      type: "POST",
      dataType: "json",
      data: '["DUMMY"]', // a bug in cocoahttpserver means it can't handle POSTs without a body
      url: symbiote.baseUrlFor( "/dump" ),
      success: function(data) {
        console.debug( 'dump returned', data );
        updateDumpView( data );
        updateAccessibleViews( data );
      },
      error: function(xhr,status,error) {
        alert( "Error while talking to Frank: " + status );
      },
      complete: function(){
        hideLoadingUI();
      }
    });
  }



	$('#dump_button').click( function(){
    refreshViewHeirarchy();
    uiLocator.updateBackdrop();
  });

  $('#flash_button').click( function(){
    sendFlashCommand( $("input#query").val() );
  });

  
  liveView = symbiote.LiveView( uiLocator.updateBackdrop, refreshViewHeirarchy );

  $("#live-view button").click( function(){
    $(this).toggleClass('down');
    if( $(this).hasClass('down') ){
      liveView.start();
      $(this).text('stop Live View');
    }else{
      liveView.stop();
      $(this).text('start Live View');
    }
  });


  //initial UI setup

	$('#loading').hide();
  
  // do initial DOM dump straight after page has finished loading
  $('#dump_button').click();
  
  // show locator tab by default
  selectLocatorTab();
  
});
