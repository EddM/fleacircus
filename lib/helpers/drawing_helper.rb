module DrawingHelper
  
  def draw_quad_from(x, y, width, height = width, color = Gosu::Color::WHITE, z = Z::Player)
    self.draw_quad x, y, color,
                   x + width, y, color,
                   x, y + height, color,
                   x + width, y + height, color, 
                   z
  end
  
end