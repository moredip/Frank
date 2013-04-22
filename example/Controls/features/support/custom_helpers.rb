module CustomHelpers
  def element_is_fully_in_view( selector )
    results = frankly_map( selector, 'FEX_isFullyWithinWindow' )
    return false if results.empty?
    raise 'more than one element matched selector' if results.count > 1
    results.first
  end

  def scroll_table_view_to_reveal_cell_with_contents( table_view_selector, cell_mark )
    cell_selector = "#{table_view_selector} tableViewCell view marked:'#{cell_mark}' first"
    # let's be optimistic
    return if element_is_fully_in_view( cell_selector )

    wait_for_element_to_exist( table_view_selector )
    num_cells = frankly_map( table_view_selector, 'numberOfRowsInSection:', 0 ).first
    (0...num_cells).each do |cell_index|
      scroll_table_view( table_view_selector, cell_index )
      sleep 0.1 # :(
      return if element_is_fully_in_view( cell_selector )
    end

    raise "could not find cell marked '#{cell_mark}' in the table view"
  end
end

World( CustomHelpers )
