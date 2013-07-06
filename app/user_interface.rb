require './app/cabinet_interface'
require './app/drawer_interface'

# ########################################################################################
class UserInterface

  def initialize(cabinet = nil)
    @cabinet_interface = CabinetInterface.new(cabinet)
    @navigator = @cabinet_interface
  end
  
  def start
    while(true)
      menu_selection = prompt_user

      res = @navigator.process(menu_selection.to_i)

      report(res)

      route(res)
    end
  end

  def prompt_user
    puts @navigator.menu
    menu_selection = gets.chomp
  end

  def report(res)
    if(res.is_a?(Hash))

      if(res[:error])
        puts res[:error]

      else
        puts res[:info]
      end

    end
  end

  def route(res)
    if(res.is_a?(Hash))

      if(!res[:error])
        if(@navigator.is_a?(DrawerInterface))
          route_drawer_interface(res)

        else # is_a?(CabinetInterface)
          route_cabinet_interface
        end
      end

    end
  end

  def route_drawer_interface
    if(res[:cabinet])
      @navigator = @cabinet_interface
    end
  end

  def route_cabinet_interface
    selected_drawer = cabinet.drawers(res[:drawer])
    @navigator = DrawerInterface.new(selected_drawer)
  end

end


