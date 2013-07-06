module MyColors
  RED = 31
  GREEN = 32

  def self.colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end
end

def colorize(*args)
  MyColors::colorize(*args)
end

