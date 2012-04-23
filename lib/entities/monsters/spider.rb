class Spider < Monster

  def initialize(x, y, range = 50)  
    @width = 64
    @height = 32  
    super("spider.png", x, y, range)
  end
  
  def jumpable?
    true
  end
  
end