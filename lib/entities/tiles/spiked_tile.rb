class SpikedTile < Tile
  
  def initialize(x, y)
    y += 16
    super(x, y)
    @width = 64
    @height = 48
    @image = Gosu::Image.new(GameWindow.current, "res/graphics/spikes.png", true)
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
  
  def contact(player)
    player.hurt!
    player.force_jump
  end
  
end