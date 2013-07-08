require './app/drawer'

# ########################################################################################
class Cabinet
  attr_reader :drawers

  def initialize(number_of_drawers = 3)
    @drawers = (0...number_of_drawers).map{|i| Drawer.new}
  end

  def drawer_at(position)
    if(position and position.is_a?(Integer) and position > 0 and position <= drawers.length)
      # subtract one because our array is zero-based
      drawers[(position-1)]

    else
      raise "there is no drawer at position #{position}; please try a value between and including 1 and #{drawers.length}"
    end
  end
end

