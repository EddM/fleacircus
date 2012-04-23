class StaticTile < Tile

  def initialize(x, y)
    super(x, y)
    @image = Gosu::Image.new(GameWindow.current, "res/graphics/#{@filename}")
    @width, @height = @image.width, @image.height
  end

  def draw
    @image.draw @x, @y, Z::Obstacles
  end

  def solid?
    true
  end
  
end