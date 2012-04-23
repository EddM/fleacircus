class EndLevelState < GameState

  Text = "Level Complete!"

  def initialize
    @opacity = 0
    @font = Gosu::Font.new(GameWindow.current, Gosu.default_font_name, 24)
    @text_width = @font.text_width(Text)
    @button = Button.new((GameWindow::Width / 2), 200, "Continue") do
      GameStateManager.current.pop
      GameStateManager.current.pop
      GameStateManager.current.push LevelState.new(Level.current.next_level)
    end
  end

  def update
    @button.update
  end
  
  def draw
    color = Gosu::Color.from_ahsv(@opacity, 0, 0, 0)
    GameWindow.current.draw_quad 0, 0, color,
                                 GameWindow::Width, 0, color,
                                 0, GameWindow::Height, color,
                                 GameWindow::Width, GameWindow::Height, color,
                                 Z::UI
    if @opacity > 0
      @font.draw Text, (GameWindow::Width / 2) - (@text_width / 2), 150, Z::UI
      @button.draw
    end
  end
  
  def enter
    Timer.in(500) do
      @opacity = 75
    end
  end
  
  def exclusive_draw?
    false
  end
  
  def needs_cursor?
    true
  end
  
end