# ########################################################################################
class Drawer
  attr_reader :drawer_position, :drawer_contents

  def initialize(position = Drawer::CLOSED, contents = [])
    @drawer_position = position
    @drawer_contents = contents
  end

  OPEN = true
  CLOSED = false

  alias_method :position, :drawer_position
  alias_method :contents, :drawer_contents

  # TODO: change to open!
  def open
  @drawer_position = OPEN
  end

  # TODO: change to close!
  def close
  @drawer_position = CLOSED
  end

  # this better conforms to Ruby style
  # booleans typically have '?' at the end
  # don't need a #is_closed? because !is_open? is the same thing
  def is_open?
    @drawer_position == OPEN
  end

  # place specified item in this drawer
  # if drawer state is OPEN, place item in drawer and return reference to that item
  # else return nil to indicate the item was not placed in drawer
  # 
  # TODO: don't forget to protect your models from attempting to place an item in a non-
  # existent drawer!  That should be done at least at the model layer.
  #
  def place(thing_to_put_into_drawer)
    if (is_open?)
      @drawer_contents << thing_to_put_into_drawer
      return thing_to_put_into_drawer
    else
      return nil
    end
  end

  # show the content of the drawer
  # number each item for reference
  # item removal is still performed using the full item name; not the index reference
  # 
  def list_content(itemized = false)
    if(itemized)
      @drawer_contents.map.with_index{|item, i| "#{i+1}. '#{item}'"}
    else
      @drawer_contents.join(", ")
    end
  end

  # remove specified item from this drawer
  # if drawer state is OPEN, remove item from drawer and return reference to that item
  # else return nil to indicate the item was not removed from drawer
  # 
  def remove(thing_to_remove)
    if (is_open?)
      @drawer_contents.delete(thing_to_remove)
      return thing_to_remove
    else
      return nil
    end
  end

end

