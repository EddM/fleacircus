class DialogBox

  Color = Gosu::Color::RED
  
  def initialize(text)
    @text = text.split("\n")
    @font = Gosu::Font.new(GameWindow.current, Gosu.default_font_name, 14)
    @max_width = @text.collect { |string| @font.text_width(string) }.max
    
    @width = @max_width + 30
    @height = (@text.size * @font.height) + 30
    
    @x = (GameWindow::Width / 2) - (@width / 2)
    @y = (GameWindow::Height / 2) - (@height / 2)
  end
  
  def draw
    draw_box
    draw_text
  end
  
  def draw_box
    GameWindow.current.draw_quad  @x, @y, Color,
                                  @x + @width, @y, Color,
                                  @x, @y + @height, Color,
                                  @x + @width, @y + @height, Color,
                                  Z::UI
  end
  
  def draw_text
    @text.each_with_index do |line, i|
      @font.draw line.chomp, @x + 15, (@y + 15)  + (i * @font.height), Z::UI
    end
  end
  
end