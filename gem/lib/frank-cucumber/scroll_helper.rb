module Frank
module Cucumber

module ScrollHelper

  def scroll_view_to_top( selector )
    frankly_map( selector, "FEX_scrollToTop" )
  end

  def scroll_view_to_bottom( selector )
    frankly_map( selector, "FEX_scrollToBottom" )
  end

  def scroll_view_to_position( selector, x, y )
    frankly_map( selector, "FEX_setContentOffsetX:y:", x.to_i, y.to_i)
  end

  def scroll_table_view( selector, row, section = 0)
    frankly_map(selector, "FEX_scrollToRow:inSection:", row.to_i, section.to_i)
  end

end

end end
