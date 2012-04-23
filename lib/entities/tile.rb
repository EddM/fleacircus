class Tile < Entity
  
  Size = 64
  
  def initialize(x, y)
    @x, @y = x, y
    @height = @width = Size
  end
  
  def solid?
    false
  end
  
end