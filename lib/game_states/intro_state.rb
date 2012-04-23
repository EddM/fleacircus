class IntroState < GameState
  
  def initialize(lang = "en")
    @song = Gosu::Song.new(GameWindow.current, "res/audio/intro.mp3")
    @font = Gosu::Font.new(GameWindow.current, Gosu.default_font_name, 18)
    @small_font = Gosu::Font.new(GameWindow.current, Gosu.default_font_name, 12)
    @pip = Gosu::Image.new(GameWindow.current, "res/graphics/big-pip.png", false)
    
    @key_lines = { 2 => :show_pip }
    @fade = :in
    @step = 0
    @dialog = File.readlines("res/dialog/intro_#{lang}.txt").map { |line| line.chomp }
    next_line
    
    @can_skip = false
    
    @opacity = nil
  end
  
  def show_pip
    @can_skip = false

    Timer.in(500) do
      @pip_offset = 0
    end
    
    Timer.in(2000) do
      @can_skip = true
    end
  end
  
  def enter
    Timer.in(1000) do
      @can_skip = true
    end
    
    @opacity = 0
    Timer.in(2000) do
      @song.play(true)
    end
  end
  
  def update
    puts @step
    
    if @pip_offset
      if @pip_offset < 175
        @pip_offset += 2
      end
    end
    
    if @fade == :in
      @opacity += 5
    elsif @fade == :out
      @opacity -= 5
      if @opacity <= 0
        @step += 1
        next_line
        @fade = :in
      end
    end
    
    next! if @can_skip && GameWindow.current.button_down?(Gosu::MsLeft)
  end
  
  def draw
    GameWindow.current.draw_quad 0, 0, 0xff000000,
                                 GameWindow::Width, 0, 0xff000000,
                                 0, GameWindow::Height, 0xff1d1d1d,
                                 GameWindow::Width, GameWindow::Height, 0xff1d1d1d,
                                 Z::UI
    
    if @pip_offset
      @pip.draw((GameWindow::Width * 0.6), (GameWindow::Height - @pip_offset), Z::UI, 1, 1)  
    end
    
    if @opacity
      @line.each_with_index do |line, i|
        @font.draw line, (GameWindow::Width / 2) - (@line_width / 2), (GameWindow::Height / 2) - (@font.height / 2) + (i * @font.height), Z::UI, 1, 1, Gosu::Color.from_ahsv(@opacity, 0, 0, 100)
      end
    end
    
    if @can_skip
      @small_font.draw "Click to continue", 15, (GameWindow::Height - @small_font.height) - 15, Z::UI, 1, 1, 0x55ffffff
    end
  end
  
  def next!
    puts 'next!'
    
    @can_skip = false
    
    if @fade == :in
      @opacity = 255
      @fade = :out
    elsif @fade == :out
      @opacity = 0
      @fade = :in
    end
  end
  
  def next_line
    if @step == @dialog.size
      start_game
    else
      @line = @dialog[@step].split(":")
      @line_width = @line.map { |l| @font.text_width(l) }.max
      @can_skip = true
      
      send(@key_lines[@step]) if @key_lines[@step]
    end
  end
  
  def start_game
    GameStateManager.current.replace(LevelState.new(1))
  end
  
  def leave
    @song.stop
  end
  
end