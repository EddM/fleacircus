class RedFruit < Pickup
  
  def contact!(player)
    player.red_fruit!
    super(player)
  end
  
  def image
    @image ||= Gosu::Image.new(GameWindow.current, "res/graphics/red-fruit.png", false)
  end
  
end