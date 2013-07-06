require './app/drawer'

# ########################################################################################
class Cabinet
  attr_reader :drawers

  def initialize(number_of_drawers = 3)
    @drawers = (0...number_of_drawers).map{|i| Drawer.new}
  end
end

