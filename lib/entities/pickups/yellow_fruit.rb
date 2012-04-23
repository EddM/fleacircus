class YellowFruit < Pickup
  
  def contact!(player)
    player.yellow_fruit!
    super(player)
  end
  
  def image
    @image ||= Gosu::Image.new(GameWindow.current, "res/graphics/yellow-fruit.png", false)
  end
  
end