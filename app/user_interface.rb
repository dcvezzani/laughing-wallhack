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

      res = @navigator.process(menu_selection.upcase)

      report(res)

      route(res)
    end
  end

  def self.start
    puts "Cabinet Interface (0.0.1)
##################################

You have clothes to put away and need a cabinet?  No problem.  
Let's get started!

How many drawers do you need?
"
    number_of_drawers = gets.chomp

    unless(number_of_drawers.match(/^\d+$/))
      raise "I expected a number, but you asked for '#{number_of_drawers}' number of drawers.  Sorry; I don't speak that language!"
    end

    puts "<saw> <saw> <pound> <pound> <pound> <the smell of polyeurethane>

Ok.  You're all set.  Enjoy!"

    cabinet = Cabinet.new(number_of_drawers.to_i)
    cabinet.drawers[0] = Drawer.new(Drawer::OPEN, ["red socks"])
    cabinet.drawers[1] = Drawer.new
    cabinet.drawers[2] = Drawer.new(Drawer::OPEN, ["blue pants", "pink shirt", "dirty shoes"])

    runner = UserInterface.new(cabinet).start
  end

  def prompt_user
    puts "\n#{@navigator.menu}"

    menu_selection = gets.chomp
  end
  
  def print(msg)
    puts "\n#{msg}"
  end

  def report(res)
    error_msg = "report should take a hash whose key is either :error or :info and whose value is a string"

    if(res.is_a?(Hash))

      if(res[:error])
        print res[:error]

      elsif(res[:info])
        print res[:info]

      else
        raise error_msg
      end

    else
      raise error_msg
    end
  end

  def route(res)
    error_msg = "route should take a hash"

    if(res.is_a?(Hash))

      if(!res[:error])
        if(@navigator.is_a?(DrawerInterface))
          route_drawer_interface(res)

        else # is_a?(CabinetInterface)
          route_cabinet_interface(res)
        end
      end

    else
      raise error_msg
    end
  end

  def route_drawer_interface(res)
    if(res[:cabinet])
      @navigator = @cabinet_interface
    end
  end

  def route_cabinet_interface(res)
    if(res and res.is_a?(Hash) and res.has_key?(:drawer) and res[:drawer].is_a?(Integer))
      selected_drawer = @cabinet_interface.cabinet.drawer_at(res[:drawer])
      @navigator = DrawerInterface.new(selected_drawer)

    else
      raise "res should be a hash with key :drawer whose value is an Integer"
    end
  end

end

UserInterface.start
