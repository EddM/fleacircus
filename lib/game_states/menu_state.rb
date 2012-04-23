class MenuState < GameState
  
  def initialize
    @song = Gosu::Song.new(GameWindow.current, "res/audio/menu.wav")
    @song.play(true)
    
    @background = Gosu::Image.new(GameWindow.current, "res/graphics/circus.png", false)
    @name = Gosu::Image.new(GameWindow.current, "res/graphics/name.png", false)
    
    @spotlight = Gosu::Image.new(GameWindow.current, "res/graphics/spotlight.png", false)
    @spotlights = [(GameWindow::Width * 0.25).to_i, (GameWindow::Width * 0.75).to_i]
    @angles = [45, -0]
    @directions = [0, 1]
    
    @button = Button.new(GameWindow::Width / 2, 300, "New Game") do
      GameStateManager.current.push(GameWindow.current.debug ? LevelState.new(1) : IntroState.new)
    end
  end
  
  def leave
    @song.stop
  end
  
  def needs_cursor?
    true
  end
  
  def update
    @button.update
    adjust_angles
  end
  
  def adjust_angles
    @directions.each_with_index do |dir, i|
      if dir == 0
        @angles[i] -= 1
        @directions[i] = 1 if @angles[i] <= -45
      else
        @angles[i] += 1
        @directions[i] = 0 if @angles[i] >= 45
      end
    end
  end
  
  def draw
    @button.draw
    @background.draw 0, 0, Z::Scenery
    @spotlight.draw_rot @spotlights[0], -100, Z::Scenery, @angles[0], 0.5, 0.0, 1.0, 1.75, 0x33ffffff
    @spotlight.draw_rot @spotlights[1], -100, Z::Scenery, @angles[1], 0.5, 0.0, 1.0, 1.75, 0x33ffffff
    @name.draw((GameWindow::Width / 2) - (@name.width / 2), 125, Z::UI)
  end
  
end