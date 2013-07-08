require './app/cabinet'
require './app/selectable_interface'

# ########################################################################################
class CabinetInterface < SelectableInterface
  attr_reader :cabinet

  def initialize(cabinet = nil)
    @cabinet = if(cabinet == nil)
      Cabinet.new(3) 
    else
      cabinet
    end
  end

  def menu
    itemized_drawers = cabinet.drawers.map.with_index do |drawer, i|
      "#{i+1}. #{drawer.list_content}"
    end

    "Select drawer: \n  - #{itemized_drawers.join("\n  - ")}"
  end

  def process(menu_selection)
    # TODO: validate menu_selection is an integer and is a valid selection for the associated menu
    
    drawer_position = nil
    if(menu_selection.is_a?(Integer))
      drawer_position = menu_selection
    else
      drawer_position = (!menu_selection.nil? and menu_selection.match(/^\d+$/)) ? menu_selection.to_i : nil
    end

    if(!menu_selection.nil?  and menu_selection.upcase == 'C')
      {cabinet: :back, info: "back to cabinet"}
    elsif(!drawer_position.nil? and drawer_position > 0 and drawer_position <= cabinet.drawers.length)
      {drawer: drawer_position, info: "selecting drawer ##{drawer_position}"}
    else
      {error: "selected drawer does not exist; select a drawer between 1 and #{cabinet.drawers.length}"}
    end
  end
end

