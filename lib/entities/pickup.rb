class Pickup < Entity

  def initialize(x, y)
    @x, @y = x, y
    @height = Tile::Size
    @width = Tile::Size
    
    SoundEffectManager.current << :chomp
  end
  
  def draw
    image.draw(@x + ((Tile::Size / 2) - (image.width / 2)), @y + ((Tile::Size / 2) - (image.height / 2)), Z::Pickups)
  end
  
  def contact!(player)
    SoundEffectManager.current.play :chomp
    destroy!
  end
  
  def destroy!
    Level.current.pickups.delete(self)
  end
  
end