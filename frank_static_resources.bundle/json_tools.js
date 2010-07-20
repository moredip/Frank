

var JsonTools = (function() {
  var module = {};

  function visit_node( node, visitor ) {
    var attr_value;
    for( attr_name in node ) {
      attr_value = node[attr_name];
      if( typeof( attr_value ) == "object" )
      {
        visitor.start_node_visit( attr_name );
        visit_node( attr_value, visitor );
        visitor.end_node_visit();
      }else
        visitor.visit_attribute( attr_name, attr_value );
    }
  };

  function DomGenerationVisitor() {
    this.ul_stack = [$("<ul/>")];
    this.start_node_visit = function( node_name ) {
      var li = $("<li><b>"+node_name+"</b></li>");
      this.curr_ul().append( li );

      var new_ul = $("<ul/>");
      li.append( new_ul );

      this.ul_stack.unshift( new_ul );
    };

    this.visit_attribute = function( name, value ) {
      this.curr_ul().append( $("<li>"+name+": "+value+"</li>") );
    };

    this.end_node_visit = function() {
      this.ul_stack.shift();
    };

    this.curr_ul = function() {
      return this.ul_stack[0];
    }

    this.root_ul = function() {
      return this.ul_stack[this.ul_stack.length-1];
    }
  }



  module.convert_json_to_dom = function( data ) {
    var visitor = new DomGenerationVisitor();
    visit_node( data, visitor );
    return visitor.root_ul();
  };

  return module;
}());
