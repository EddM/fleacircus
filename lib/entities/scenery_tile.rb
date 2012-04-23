class SceneryTile < Tile
  
  
  def initialize(x, y)
    super(x, y)
    @image = Gosu::Image.new(GameWindow.current, "res/graphics/#{@filename}")
    @width, @height = @image.width, @image.height
    @opacity = 255
  end

  def draw
    @image.draw @x, @y, Z::Obstacles, 1.0, 1.0, Gosu::Color.from_ahsv(@opacity, 0, 0, 100)
  end

  def solid?
    false
  end
  
end