class LevelState < GameState

  DialogOffset = 50
  DialogPadding = 10
  
  attr_accessor :level
  
  def initialize(level = 1)
    @player = Player.new
    @camera = [0, 0]
    
    @score_font = Gosu::Font.new(GameWindow.current, Gosu.default_font_name, 18)
    @heart = Gosu::Image.new(GameWindow.current, "res/graphics/heart.png", false)
    @level = Level.new("level#{level}", @player)
    @player.spawn!(@level.spawn)
    
    if @level.dialog
      @dialog_font = Gosu::Font.new(GameWindow.current, Gosu.default_font_name, 14)
      @dialog = @level.dialog
      @lines = @dialog.split("\n")
      @longest_line = @lines.map { |line| @dialog_font.text_width(line) }.max
      @dialog_width = @longest_line + (2 * DialogPadding)
      @dialog_height = (@lines.size * @dialog_font.height) + (2 * DialogPadding)
    end
  end
  
  def update
    if @dialog
      @dialog = nil if GameWindow.current.button_down?(Gosu::KbReturn)
    else
      GameWindow.current.pause! if GameWindow.current.button_down? Gosu::KbP
      @level.update
      @player.update
      @score = @player.score
    end
    
    @camera = [
      [[@player.x - (GameWindow::Width / 2), 0].max, @level.pixel_width - GameWindow::Width].min,
      [[@player.y - (GameWindow::Height / 2), 0].max, (@level.pixel_height - GameWindow::Height)].min]
  end
  
  def draw
    GameWindow.current.translate(-@camera[0], -@camera[1]) do
      @level.draw
      @player.draw
    end
    
    if @dialog
      x = (GameWindow::Width / 2) - (@dialog_width / 2)
      GameWindow.current.draw_quad(
        x, DialogOffset, 0xff000000,
        x + @dialog_width, DialogOffset, 0xff000000,
        x, DialogOffset + @dialog_height, 0xff000000,
        x + @dialog_width, DialogOffset + @dialog_height, 0xff000000,
        Z::UI
      )
              
      @lines.each_with_index do |line, i|
        @dialog_font.draw line, (GameWindow::Width / 2) - (@longest_line / 2), DialogOffset + DialogPadding + (@dialog_font.height * i), Z::UI
      end
    else
      draw_score
      draw_lives
    end
    
    @level.background.draw parallax_offset(@level.background.width, @level.pixel_width), (GameWindow::Height - @level.background.height), Z::Background
  end
  
  def draw_score
    @score_font.draw @score, GameWindow::Width - @score_font.text_width(@score.to_s) - 20, 20, Z::UI
  end

  def draw_lives
    @player.lives.times do |i|
      @heart.draw GameWindow::Width - 40 - (20 * i), 40, Z::UI
    end
  end
  
  def parallax_offset(width, full_width)
     0 - (width - GameWindow::Width).to_f / (100.0 / (100.0 / (full_width / @camera[0].to_f)))
  end
  
  def needs_cursor?
    !!@dialog
  end
  
end