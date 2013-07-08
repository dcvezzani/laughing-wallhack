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
2. show contents
3. place item
4. remove item
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
    puts "\n#{msg}" if !msg.nil?
    
    if(block_given?)
      puts yield
    end

    user_input = gets.chomp
    user_input
  end

  def process(menu_selection)
    # TODO: validate menu_selection is a valid selection for the associated menu
    res = nil

    if(drawer.is_open?)
      res = case(menu_selection)

      ### close ###
      when '1'
        drawer.close
        {drawer: :closed, info: "drawer is now closed"}

      ### show ###
      when '2'
        jabs = ["That's some interesting stuff", "Wow; it looks like it's time to do some cleaning", "A place for everything and everything in its place", "You must be a neat freak or something"]
        jabs_for_one_item = ["How quaint!", "Don't you think that your #{drawer.contents.first} are getting a little lonely?", "Just one little item with plenty of space"]
        jabs_for_no_items = ["<chirp> Did I just hear a cricket?", "A little dusty in here", "So are you going to put anything in here or what?!", "Absolutely nothing going on here", "If you're not going to put anything in here, you might as well close the drawer"]

        jab = if (drawer.contents.length < 1)
                jabs_for_no_items[rand(jabs_for_no_items.length)]
              elsif (drawer.contents.length > 1)
                jabs[rand(jabs.length)]
              else
                jabs_for_one_item[rand(jabs_for_one_item.length)]
              end

        {info: ["Let's see...", drawer.list_content, jab].join("\n")}

      ### place ###
      when '3'
        thing_to_put_into_drawer = prompt_user_for_input("What would you like to put into the drawer for storage?")

        if(drawer.place(thing_to_put_into_drawer))
          {info: "item '#{thing_to_put_into_drawer}' was successfully placed into drawer"}

        else
          {error: "unable to place item '#{thing_to_put_into_drawer}' into drawer"}
        end

      ### remove ###
      when '4'
        thing_to_remove = prompt_user_for_input("What would you like to remove from the drawer?"){
          #a list of contents is presented to the user
          drawer.list_content(true)
        }

        thing_label = thing_to_remove

        if(thing_to_remove.match(/^\d+$/))
          thing_to_remove = thing_to_remove.to_i
          thing_label = drawer.item_at(thing_to_remove)
        end

        if(drawer.remove(thing_to_remove))
          {info: "item '#{thing_label}' was successfully removed from drawer"}

        else
          {error: "unable to remove item '#{thing_to_remove}' from drawer (is it in the drawer?)"}
        end

      when 'C'
        {cabinet: :back, info: "back to cabinet"}

      else
        {error: "invalid selection: '#{menu_selection}'; try again"}
      end

    else
      res = case(menu_selection)

      ### open ###
      when '1'
        drawer.open
        {drawer: :open, info: "drawer is now open"}

      when 'C'
        {cabinet: :back, info: "back to cabinet"}

      else
        {error: "invalid selection: '#{menu_selection}'; try again"}
      end
    end

    res
  end
end

