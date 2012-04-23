class GameWindow < Gosu::Window
  include DrawingHelper
  
  attr_accessor :debug
  
  Width   = 640
  Height  = 480
  
  def initialize
    super(Width, Height, false)
    @@current = self
    self.caption = "Flea Circus"
    
    @debug = false
    @debug_font = Gosu::Font.new(self, Gosu.default_font_name, 10)
    
    GameStateManager.current.push MenuState.new
  end
  
  def update
    if Gosu.milliseconds >= (Timer.last_update + Timer::Frequency)
      Timer.tick!
    end
    
    GameStateManager.current.active.update
    
    i = 1
    while GameStateManager.current.stack[i] && !GameStateManager.current.stack[i].exclusive_update?
      GameStateManager.current.stack[i].update
      i += 1
    end
    
    quit if button_down? Gosu::KbEscape
  end
  
  def draw
    draw_debug if @debug
    GameStateManager.current.active.draw
    
    i = 1
    while GameStateManager.current.stack[i] && !GameStateManager.current.stack[i - 1].exclusive_draw?
      GameStateManager.current.stack[i].draw
      i += 1
    end
  end
  
  def pause!
    GameStateManager.current.push PauseState.new
  end
  
  def unpause!
    GameStateManager.current.pop
  end
  
  def game_over!(score)
    GameStateManager.current.push GameOverState.new(score)
  end
  
  def bottom(offset = 0)
    Height - offset
  end
  
  def draw_debug
    draw_quad 8, 8, Gosu::Color::BLACK,
              70, 8, Gosu::Color::BLACK,
              8, 42, Gosu::Color::BLACK,
              70, 42, Gosu::Color::BLACK,
              Z::Debug
    
    @debug_font.draw "#{Gosu.fps} FPS", 12, 10, Z::Debug
    @debug_font.draw "#{Gosu.milliseconds}", 12, 20, Z::Debug
    @debug_font.draw "#{Level.current.player.x},#{Level.current.player.y}", 12, 30, Z::Debug if GameStateManager.current.active.is_a?(LevelState)
  end
  
  def needs_cursor?
    GameStateManager.current.active ? GameStateManager.current.active.needs_cursor? : false
  end
  
  def quit
    puts "Bye!"
    exit
  end
  
  def self.current
    @@current
  end
  
  def self.setup!
    GameWindow.new
  end
  
end