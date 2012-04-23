class OrangeFruit < Pickup
  
  def contact!(player)
    player.orange_fruit!
    super(player)
  end
  
  def image
    @image ||= Gosu::Image.new(GameWindow.current, "res/graphics/orange-fruit.png", false)
  end
  
end