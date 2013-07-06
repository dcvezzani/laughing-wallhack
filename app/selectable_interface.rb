# ########################################################################################
class SelectableInterface
  def initialize
    raise "Can't create an instance of SelectableInterface; create a model that inherits from this"
  end

  def menu
    raise "Please create #menu for the class that inherits from SelectableInterface"
  end

  def process
    raise "Please create a handler #process for the class that inherits from SelectableInterface"
  end
end

