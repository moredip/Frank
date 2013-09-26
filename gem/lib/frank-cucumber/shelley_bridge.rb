##Author: Chuck
##Shelley bridge to make a string query system (like sql) into a more fun and usable objecty moduley system.

#Selector Modules
#The 'S' Stands for 'Shelley'
#Houses the modules used to generate various selector queries for various views and custom queries
module SSelector
  #Generic selector class
  #Holds the strings used to translate the programmatic approach to Shelley's odd string query system.
  #Provides the base selector() and wrap() methods used to generate a full query to send through Frank
  #  to the Shelley engine running in the Frank server.
  module Selector
    PARENT_OPTS = [:parent, :up]
    DESCENDANT_OPTS = [:descendant, :down]
    ACCEPTED_SELECTOR_KEYS = [:class_name, :view, :marked, :loose, :index]
    ACCEPTED_WRAP_KEYS = [:direction] << ACCEPTED_SELECTOR_KEYS

    #Internal helpers
    class << self
      def _wrap_helper(direction)
        if PARENT_OPTS.include? direction
          parent_view
        elsif DESCENDANT_OPTS.include? direction
          descendant_view
        end
      end
    end

    #Returns the view query string
    def self.view(label=nil)
      if label
        "view:'|#{label}|'"
      else
        'view'
      end
    end

    #Returns the separator value for the query string
    def self.separator
      ' '
    end

    #Returns the index query string
    def self.index(index=0)
      "index:#{index}"
    end

    #Returns the marked query string
    def self.marked(label, loose=false)
      if loose
        "marked:'|#{label}|'"
      else
        "markedExactly:'|#{label}|'"
      end
    end

    #Returns the parent query string
    def self.parent_view
      'parent'
    end

    #Returns all descendants of a view
    def self.descendant_view
      'descendant'
    end

    #Generates and returns a query string for desired query
    # view(:'class_title') (marked(Exactly):'|accessibility_title|') (index:value_here)
    # () shows the option separation of potential outputs. so the minimum this outputs always is: 'view'
    #   and the maximum is: "view:'UIView' markedExactly:'|this is text|' index:0"
    # You can learn Shelley too! FrankProject/lib/Shelley
    # Send a :view or :class_name, a :marked (with or without :loose matching), and an :index (all optional)
    #   and I will form a selector query string for you!
    def self.selector(options={})
      options = Selector.sanitize options
      #Append the query built :view (minimally 'view') to output
      class_view = view options[:class_name]
      view = options[:view] || class_view
      output = view
      #Add the query built :marked if it has one
      if options[:marked]
        output += separator+marked(options[:marked], options[:loose])
      end
      #Add the selector's query built :index if it has one (differs from parent/descendant index)
      if options[:index]
        output += separator+index(options[:index])
      end
      output
    end

    #Wraps a set of selectors for traversal up or down the stack
    #Given an array of wrappables for traversal, generate a wrapped selector query of selectors
    #Acceptable inputs include the following:
    #  Query object, MultiQuery object, Options hash
    #The input can let you step up and down the tree globally, or through the use of a :direction key injected into
    #  the options hash (or resulting options hash if its a query or multiquery)
    #Example input: [TableCell.make, Label.make("hi")], :descendant
    #  Will output: tableViewCell descendant label markedExactly:'hi'
    #Using an array inside the array with param 1 set to a direction, you can override the global direction for that
    #  one selector, such that, with global_direction as ':parent':
    #Example input: Selector.wrap([Label.make("hi"), TableCell.make, [Label.make("second_label"), :descendant], TableCell.make])
    #  Will output: label markedExactly:'hi' parent tableViewCell descendant label markedExactly:'second_label' parent tableViewCell
    def self.wrap(selectors=[], global_direction=:parent)
      raise 'Selectors must be an array!' if !selectors.is_a? Array
      output = ''
      #Loop through the selectors wrapping them all to a single query
      selectors.each_with_index do |selector_options, i|
        if selector_options.is_a? Array
          if i > 0
            output += append_separator(output) + _wrap_helper(selector_options[1])
          end
          if selector_options[0].is_a?(Query) || selector_options[0].is_a?(MultiQuery)
            output += append_separator(output) + selector_options[0].selector
          else
            output += append_separator(output) + selector(selector_options[0])
          end
        else
          if selector_options.is_a? Query
            if i > 0
              output += append_separator(output) + _wrap_helper(selector_options.options[:direction] ? selector_options[:direction] : global_direction)
            end
            output += append_separator(output) + selector_options.selector
          elsif selector_options.is_a? MultiQuery
            if i > 0
              output += append_separator(output) + _wrap_helper(global_direction)
            end
            output += append_separator(output) + selector_options.selector
          else
            if i > 0
              output += append_separator(output) + _wrap_helper(selector_options[:direction] ? selector_options[:direction] : global_direction)
            end
            output += append_separator(output) + selector(selector_options)
          end
        end
      end
      output.chomp(separator)
    end

    #Determine if a separator should be placed at the end of a query string
    #Returns a separator if one is needed, a blank string if otherwise.
    def self.append_separator(input)
      if input != '' && !input.end_with?(separator)
        separator
      else
        ''
      end
    end

    #So that SSelector::Selector doesn't complain, sanitize the inputs
    #There is no return, this will direct edit the options hash
    def self.sanitize(options={})
      #We may want both view and class_name for information purposes in the module/class that extends us,
      #  but we should still conform to the query we are wrapping.
      options = options.clone
      if options.has_key? :view
        if options[:view] == nil
          options.delete :view
        else
          options.delete :class_name
        end
      end
      if options[:descendant] && options[:parent]
        options.delete :descendant
      end
      options
    end

  end

  #Query
  #This is the base module that provides all of the useful functionality needed to interact with
  #SSelector::Selector. It can be used in convenience modules to build up partial queries, full queries,
  #  and be able to spit out selector strings as needed. This holds all potential Query information in what is known as
  #  an 'Options Hash'. This hash is defined in SSelectors::Selector.selector as well as valid inputs print out if
  #  you use puts SSelector::Selectors::ACCEPTED_SELECTOR_KEYS.
  #There are multiple ways a Query can be made or built up, see the 'make' routines for information on that.
  module MQuery
    attr_reader :options
    @options = nil
    #Make up an options hash. To be used when extended by other modules (convenience object methods for example)
    #Returns and builds up an options hash. If one was provided as the input, it will spit it back out as a new object.
    #If @options is defined with an options hash, return the @options hash with a merge of args 0,1,2 with 0=marked, 1=loose, 2=index
    #If no @options is defines, returns the global Query.make function call. (See Query.make)
    # make('accessibility_text', false, 4), make('accessibility_text'), make('accessibility_text', nil, 3), make("accessibility_text, true")
    #  Will output @options.merged with:
    #  {:marked=>'accessibility_text', :loose=>false, :index=>4}, {:marked=>'accessibility_text'}, {:marked=>'accessibility_text', :index=>3}, etc
    def make(*input)
      if @options
        output = @options.clone
        if input[0].is_a? String
          input.each_with_index do |string, i|
            case i
              when 0
                output[:marked] = string
              when 1
                output[:loose] = string
              when 2
                output[:index] = string
            end
          end
        elsif input[0].is_a? Hash
          output.merge! input[0]
        end
      else
        output = MQuery.make(*input)
      end
      output
    end

    #Make up an options hash. To be used when Global access to make an options hash is needed, ie not an module extension
    #Returns and builds up an options hash. If one was provided as the input, it will spit it back out as a new object.
    # Query.make('UIButton', 'accessibility_text'), Query.make('UIScrollview'), Query.make('UILabel', 'goose', true)
    #  Will output:
    #  {:class_name=>'UIButton', :marked=>'accessibility_label'}, {:class_name=>'UILabel', :marked=>'goose', :loose=>true}, etc
    def self.make(*input)
      output = Hash.new
      if input[0].is_a? String
        input.each_with_index do |string, i|
          case i
            when 0
              output[:class_name] = string
            when 1
              output[:marked] = string
            when 2
              output[:loose] = string
            when 3
              output[:index] = string
          end
        end
      end
      if input[0].is_a? Hash
        output.merge! input[0]
      end
      output
    end

    #Since this uses 'make', (not self.make), you can use all valid inputs to 'make' to form a selector string.
    #To be used when extended by another module, such as a convenience selector module.
    #Returns a selector string formed by mixing *options with @options to form a final output.
    #Label.select is an extention of Query. It uses selector to build up a label selector string for you with your options
    # Label.selector 'accessibility_text'
    #  Will output: label markedExactly:'accessibility_text'
    #Query uses this to output selector for you in object form. You can also feed options such as above and below here.
    # hi = Query.new(Label.make 'accessibility_text')
    # hi.selector
    #  Will output: label markedExactly:'accessibility_text'
    #You can also feed it an options hash, which will merge your options in with whatever known options are in the module
    # Label.selector({:marked=>'accessibility_text'})
    #  Will output: label markedExactly:'accessibility_text'
    #More examples provided in the Query class definition
    def selector(*options)
      options = make(*options)
      Selector.selector options
    end

    #Returns a built Selector.view selector string if :view or :class_name is defined.
    def view
      if @options && @options.has_key?(:view)
        @options[:view]
      elsif @options && @options.has_key?(:class_name)
        Selector.view @options[:class_name]
      end
    end

    #Returns a built Selector.marked selector string if :marked is defined.
    def marked
      if @options && @options.has_key?(:marked)
        Selector.marked @options[:marked], @options[:loose]
      end
    end

    #Returns a built Selector.index string if :index is defined. Nothing otherwise.
    def index
      if @options && @options.has_key?(:index)
        Selector.index @options[:index]
      end
    end

    #Returns a built Selector.parent_view or Selector.descendant_view if :direction is defined with a valid input.
    def direction
      if @options && @options.has_key?(:direction)
        Selector._wrap_helper @options[:direction]
      end
    end

    #When used in a class, populate options with the input provided from '.new'
    def initialize(*options)
      @options = make(*options)
    end

    #Override to_s
    def to_s
      "\"#{selector}\""
    end

    #Override inspect
    def inspect
      @options
    end

  end

  #Multi Query.
  #Currently only to be used in class definitions
  #This stores an array of options hashes, with optional :direction parameters in them
  #  to traverse up and down part of the selector tree.
  #There is also a global :direction definition which defines if options hashes
  #  should be wrapped to traverse up or down by default.
  module MMultiQuery
    #@selectors is the array of options hashes to be used in the query,
    #@direction is the global direction the wrapping of the hashes into selectors should traverse
    attr_reader :selectors, :direction
    #Possible inputs for when calling 'add'
    POSITION_FRONT = [:first, :front, :beginning]
    POSITION_END = [:last, :end, :back]

    #When used in a class, populate @selectors and @direction as needed.
    #You can provide a number of inputs to populate this, such as a list of Query, MultiQuery, options hash, array
    #See the MultiQuery class definition for more information on the ways to initiate and populate these variables.
    def initialize(*selectors)
      @selectors = Array.new
      @direction = nil
      if selectors.empty?
        #Hmmm.. :(
      elsif selectors[0].is_a?(Array) && selectors.length == 1
        #Selectors[0] is an array of selectors, flatten that so that it becomes selectors.
        selectors = selectors[0]
      elsif selectors[0].is_a?(Array) && selectors.length == 2
        #Selectors[0] is an array of selectors, flatten that so that it becomes selectors.
        # You also provided a global direction!
        @direction = selectors[1]
        selectors = selectors[0]
      end
      #Iterate over the selectors. Pull out options hashes from classes as needed.
      selectors.each do |selector|
        #If you provide an array as a selector, this means you have a selector along with a direction.
        #The selector can be either an options hash, Query object, or MultiQuery object
        #Put selector[0] into selectors and inject a :direction with selector[1] as appropriate.
        if selector.is_a? Array
          if selector[0].is_a? Query
            #You provided a Query class, pull out the options hash and put :direction into it before
            #  adding it to @selectors
            @selectors << selector[0].options.merge(:direction=>selector[1])
          elsif selector[0].is_a? MultiQuery
            #You provided a MultiQuery class. Populate @selectors with its version of @selectors
            #Also inject a :direction in to the first item in the array of MultiQuery's selectors
            #  This sticks with the guideline that if you provided a multiquery, you dont want to mess with the
            #    parents/descendents in that mutiquery, except to append to it ours, which means editing the
            #    the first options hash.
            @selectors.concat selector[0].selectors
            @selectors[@selectors.length-selector[0].selectors.length][:direction] = selector[1]
          else
            #inject :direction into the options hash then merge into selectors
            @selectors << selector[0].merge(:direction=>selector[1])
          end
        elsif selector.is_a? Query
          #You did not provide an array as a selector, just a Query, pull out the options hash and append it
          @selectors << selector.options
        elsif selector.is_a? MultiQuery
          #You provided a MultiQuery object. Pull out the multiple selectors and append
          @selectors.concat selector.selectors
        else
          #You provided an options hash. Append it.
          @selectors << selector
        end
      end
    end

    #Build up a selector string consisting of all of the options hashes in @selectors
    #Use wrap to achieve this with option @direction, or regular selector if we are just an array of one
    def selector
      if @selectors.length > 1
        if @direction
          Selector.wrap @selectors, @direction
        else
          Selector.wrap @selectors
        end
      else
        Selector.selector @selectors[0]
      end
    end

    #Add an options hash to a given position front or back
    def add(selector, position=POSITION_END[0])
      if POSITION_FRONT.include? position
        @selectors.unshift selector
      elsif POSITION_END.include? position
        @selectors << selector
      elsif position.is_a? Integer
        @selectors.insert(position, selector)
      end
    end

    #Remove an options hash using the options hash as the identifier or an index position
    def remove(options)
      if options.is_a? Hash
        @selectors.delete_if {|obj| options == obj}
      elsif options.is_a? Integer
        @selectors.delete_at options
      end
    end

    #Replace an options hash with another based on match or index as original param
    def replace(original, replacement)
      if original.is_a? Hash
        @selectors[@selectors.index(original)] = replacement
      elsif original.is_a? Integer
        @selectors[original] = replacement
      end
    end

    #Edit an options hash with another based on match or index as original param
    def edit(original, edit)
      if original.is_a? Hash
        @selectors[@selectors.index(original)].merge! edit
      elsif original.is_a? Integer
        @selectors[original].merge! edit
      end
    end

    #Override to_s
    def to_s
      "\"#{selector}\""
    end

    #override inspect
    def inspect
      @direction ? @selectors.to_s+" Direction: #{@direction}" : @selectors.to_s
    end
  end

  #Wrapped selectors class.
  #This can be a wrap of any of the following inputs:
  #  MultiQuery, Query, Options hash
  #And can be formatted using the following formats
  #  #List of valid inputs, such that (No global direction, which means default (parent/up)
  #    #obj1 = MultiQuery.new(Query.new('UIScrollView'), {:view=>'hi'}, MultiQuery.new(Query.new('UIScrollView'), Label.make("hi")), Label.make("whoah"))
  #    #puts obj1.selector
  #      #=view:'|UIScrollView|' parent hi parent view:'|UIScrollView|' parent label markedExactly:'|hi|' parent label markedExactly:'|whoah|'
  #  #List of valid inputs, with Array dictacting tree travsersal per selector/options hash
  #    #obj2 = MultiQuery.new(Label.make("hi"), [Label.make("no"), :descendant], Label.make("YAY"), obj1)
  #    #puts obj2.selector
  #      #=label markedExactly:'|hi|' descendant label markedExactly:'|no|' parent label markedExactly:'|YAY|' parent view:'|UIScrollView|'
  #      #  parent hi parent view:'|UIScrollView|' parent label markedExactly:'|hi|' parent label markedExactly:'|whoah|'
  #  #Array of valid inputs, such as obj1 or obj2 above, and global tree direction (for when one isn't provided)
  #  #  The direction param is optional so long as param one is an array using the formatting as noted above in obj1 and obj2
  #    #obj3 = MultiQuery.new([Label.make("gobble"), Query.new('nop', 'blop'), [Label.make("Wewt"), :up], Label.make("newt")], :down)
  #    #puts obj3.selector
  #      #=label markedExactly:'|gobble|' descendant view:'|nop|' markedExactly:'|blop|' parent label markedExactly:'|Wewt|' descendant label markedExactly:'|newt|'
  class MultiQuery
    include SSelector::MMultiQuery
  end

  #Generic selector class.
  #The class implementation of SSelector::Query
  #This class lets you build and save a Shelley Query for use later.
  #See SSelectors::Query for usages, there are many funs!
  #  #Provide an options hash (using label convenience module)
  #    #hi = Query.new Label.make "hi"
  #    #puts hi.selector
  #      #=label markedExactly:'|hi|'
  #  #Or provide a standard options hash
  #    #hi = Query.new({:class_name=>'UIScrollView', :index=>5})
  #    #puts hi.selector
  #      #=view:'|UIScrollView|' index:5
  #  #Or, for convenience, provide a class / text combo, or nil to exclude one or the other
  #    #hi = Query.new 'UIScrollView', 'accessibility_text'
  #    #puts hi.selector
  #      #=view:'|UIScrollView|' markedExactly:'|accessibility_text|'
  class Query
    extend SSelector::MQuery
    include SSelector::MQuery
    #When used through class global methods, this is our options hash
    @options = nil
    #When used in an object, make options hash during init
    def initialize(*options)
      @options = nil
      super
    end
    #convenience access to the static options hash
    def self.options
    end
  end



  #Label selector class
  #Example usage:
  #  Label.make 'accessibility_label'
  #  Will output an options hash of: {:view=>'label', :marked=>'accessibility_label'}
  # Label.selector 'accessibility_label'
  # OR Label.selector({:marked=>'accessibility_label'})
  #  Will output: label markedExactly:'accessibility_label'
  class Label
    #This is an extension of Query. We inherit all the happiness that Query provides, making definition simple!
    extend SSelector::MQuery
    include SSelector::MQuery
    #Constant options hash parameters that defines the Label module as a label.
    OPTIONS = {
        :view => 'label',
        :class_name => 'UILabel'
    }
    #When used through class global methods, this is our options hash
    @options = OPTIONS.clone
    #When used in an object, make options hash during init
    def initialize(*options)
      @options = OPTIONS.clone
      super
    end
    #convenience access to the static options hash
    def self.options
      OPTIONS.clone
    end
  end

  #And the rest...
  #ScrollView
  class ScrollView
    extend SSelector::MQuery
    include SSelector::MQuery
    OPTIONS = {
        :view => nil,
        :class_name => 'UIScrollView'
    }
    @options = OPTIONS.clone
    def initialize(*options)
      @options = OPTIONS.clone
      super
    end
    def self.options
      OPTIONS.clone
    end
  end

  #TableView
  class TableView
    extend SSelector::MQuery
    include SSelector::MQuery
    OPTIONS = {
        :view => 'tableView',
        :class_name => 'UITableView'
    }
    @options = OPTIONS.clone
    def initialize(*options)
      @options = OPTIONS.clone
      super
    end
    def self.options
      OPTIONS.clone
    end
  end

  #CollectionView
  class CollectionView
    extend SSelector::MQuery
    include SSelector::MQuery
    OPTIONS = {
        :view => nil,
        :class_name => 'UICollectionView'
    }
    @options = OPTIONS.clone
    def initialize(*options)
      @options = OPTIONS.clone
      super
    end
    def self.options
      OPTIONS.clone
    end
  end

  #Collection view cell
  class CollectionCell
    extend SSelector::MQuery
    include SSelector::MQuery
    OPTIONS = {
        :view => nil,
        :class_name => 'UICollectionViewCell'
    }
    @options = OPTIONS.clone
    def initialize(*options)
      @options = OPTIONS.clone
      super
    end
    def self.options
      OPTIONS.clone
    end
  end

  #Table view cell
  class TableCell
    extend SSelector::MQuery
    include SSelector::MQuery
    OPTIONS = {
        :view => 'tableViewCell',
        :class_name => 'UITableViewCell'
    }
    @options = OPTIONS.clone
    def initialize(*options)
      @options = OPTIONS.clone
      super
    end
    def self.options
      OPTIONS.clone
    end
  end

  #Button selectors
  class Button
    extend SSelector::MQuery
    include SSelector::MQuery
    OPTIONS = {
        :view => 'button',
        :class_name => 'UIButton'
    }
    @options = OPTIONS.clone
    def initialize(*options)
      @options = OPTIONS.clone
      super
    end
    def self.options
      OPTIONS.clone
    end
  end
end
