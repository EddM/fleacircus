class Button
  include GeometryHelper
  
  attr_accessor :opacity
  
  Padding = 0.2
  
  def initialize(x, y, text, size = 24, &block)
    @font = Gosu::Font.new(GameWindow.current, Gosu.default_font_name, size)
    
    text_width = @font.text_width((@text = text))
    @padding = [(text_width * Padding), (size * Padding)]
    @width = text_width + (@padding[0] * 2)
    @height = size + (@padding[1] * 2)
    
    @x, @y = x - (@width / 2), y - (@height / 2)
    
    @action = block
    @pressed = false
    @opacity = nil
    
    update
  end
  
  def hover?
    intersects_point?(GameWindow.current.mouse_x, GameWindow.current.mouse_y)
  end
  
  def draw
    GameWindow.current.draw_quad @x, @y, @back_color,
                                 @x + @width, @y, @back_color,
                                 @x, @y + @height, @back_color,
                                 @x + @width, @y + @height, @back_color,
                                 Z::UI
                                 
    @font.draw @text, @x + @padding[0], @y + @padding[1], Z::UI, 1, 1, @text_color
  end
  
  def update
    if @opacity
      @back_color = hover? ? Gosu::Color.from_ahsv(@opacity, 0, 0, 20) : Gosu::Color.from_ahsv(@opacity, 0, 0, 0) 
      @text_color = hover? ? Gosu::Color.from_ahsv(@opacity, 120, 1.0, 1.0) : Gosu::Color.from_ahsv(@opacity, 0, 0, 1.0) 
    else
      @back_color = hover? ? 0xff333333 : Gosu::Color::BLACK 
      @text_color = hover? ? 0xff00ff00 : Gosu::Color::WHITE
    end
      
    if !@pressed && GameWindow.current.button_down?(Gosu::MsLeft) && hover?
      @pressed = true
      @action.call
    end
  end
  
end