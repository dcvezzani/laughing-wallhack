require './app/drawer'
require './app/drawer'

# ########################################################################################
class CabinetInterface < SelectableInterface
  attr_reader :cabinet

  def initialize(cabinet = nil)
    cabinet = Cabinet.new(3) if(cabinet == nil)
  end

  def menu
    itemized_drawers = cabinet.drawers.map.with_index do |drawer, i|
      "#{i}. #{drawer.list_content}"
    end

    "Select drawer: \n#{itemized_drawers}"
  end

  def process(menu_selection)
    # TODO: validate menu_selection is an integer and is a valid selection for the associated menu

    if(menu_selection > 0 and menu_selection <= cabinet.drawers.length)
      {drawer: menu_selection}
    else
      {error: "selected drawer does not exist; select a drawer between 1 and #{cabinet.drawers.length}"}
    end
  end
end

