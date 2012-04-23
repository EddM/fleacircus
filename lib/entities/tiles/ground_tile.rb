class GroundTile < Tile
  
  def initialize(x, y)
    super(x, y)
    @image = Gosu::Image.new(GameWindow.current, "res/graphics/wood.png", true)
  end
  
  def draw
    c = Gosu::Color::WHITE
    @image.draw_as_quad @x, @y, c,
                        @x + @width, @y, c,
                        @x, @y + @height, c,
                        @x + @width, @y + @height, c,
                        Z::Scenery
  end
  
  def solid?
    true
  end
  
end