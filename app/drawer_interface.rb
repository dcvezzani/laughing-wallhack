require './app/drawer'
require './app/selectable_interface'

# ########################################################################################
class DrawerInterface < SelectableInterface
  attr_reader :drawer

  def initialize(drawer)
    @drawer = drawer
  end

  def menu
    if(drawer.is_open?)
      menu_open
    else
      menu_closed
    end
  end

  def menu_open
out = <<-EOL
1. close
2. place item
3. remove item
C. back to cabinet
EOL
  end

  def menu_closed
out = <<-EOL
1. open
C. back to cabinet
EOL
  end

  def prompt_user_for_input(msg=nil, &blk)
    puts msg if !msg.nil?
    if(block_given?)
      puts yield
    end

    gets.chomp
  end

  def process(menu_selection)
    # TODO: validate menu_selection is a valid selection for the associated menu
    res = nil

    if(drawer.is_open?)
      res = case(menu_selection)

      ### close ###
      when '1'
        drawer.close
        {drawer: :close}

      ### place ###
      when '2'
        thing_to_put_into_drawer = prompt_user_for_input("What would you like to put into the drawer for storage?")

        if(drawer.place(thing_to_put_into_drawer))
          {info: "item '#{thing_to_put_into_drawer}' was successfully placed into drawer ###{drawer.position}"}

        else
          {error: "unable to place item '#{thing_to_put_into_drawer}' into drawer ###{drawer.position}"}
        end

      ### remove ###
      when '3'
        thing_to_remove = prompt_user_for_input("What would you like to remove from the drawer?"){
          #a list of contents is presented to the user
          drawer.list_content(true)
        }

        if(drawer.remove(thing_to_remove))
          {info: "item '#{thing_to_remove}' was successfully removed from drawer ###{drawer.position}"}

        else
          {error: "unable to remove item '#{thing_to_put_into_drawer}' from drawer ###{drawer.position}"}
        end

      when 'C'
        {cabinet: :back}

      else
        {error: "invalid selection: '#{menu_selection}'; try again"}
      end

    else
      res = case(menu_selection)

      ### open ###
      when '1'
        drawer.open
        {drawer: :open}

      when 'C'
        {cabinet: :back}

      else
        {error: "invalid selection: '#{menu_selection}'; try again"}
      end
    end

    res
  end
end

