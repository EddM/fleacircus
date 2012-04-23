class GameOverState < GameState

  Message = "Game Over"
  
  def initialize(score)
    @score = score
    @music = Gosu::Song.new(GameWindow.current, "res/audio/sadtimes.mp3")
    @shade_opacity = 0
    @shade = Gosu::Color.from_ahsv(@shade_opacity, 0, 0, 0)
    @text_opacity = 0
    
    @font = Gosu::Font.new(GameWindow.current, Gosu.default_font_name, 32)
    @text_width = @font.text_width(Message)
    
    @button = Button.new(GameWindow::Width / 2, 300, "OK :(") do
      GameWindow.current.quit
    end
    @button.opacity = @text_opacity
  end
  
  def enter
    Level.current.stop_music
    Timer.in(1000) do
      @music.play
    end
  end
  
  def update
    unless @shade_opacity >= 175
      @shade_opacity += 1
      @shade = Gosu::Color.from_ahsv(@shade_opacity, 0, 0, 0)
    end
    
    unless @text_opacity >= 255
      @text_opacity += 1
      @color = Gosu::Color.from_ahsv(@text_opacity, 255, 255, 255)
    end
    
    @button.opacity = @text_opacity
    @button.update
  end
  
  def draw
    GameWindow.current.draw_quad  0, 0, @shade,
                                  GameWindow::Width, 0, @shade,
                                  0, GameWindow::Height, @shade,
                                  GameWindow::Width, GameWindow::Height, @shade,
                                  Z::UI
                                  
    @font.draw Message, (GameWindow::Width / 2) - (@text_width / 2), 200, Z::UI, 1, 1, @color
    @button.draw
  end
  
  def exclusive_draw?
    false
  end
  
  def needs_cursor?
    true
  end
  
end