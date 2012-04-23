class Fly < Monster
  
  HoverMax = 15
  
  def initialize(x, y, range = 50)
    @width = 64
    @height = 64
    super("fly.png", x, y, range)
    
    @hover = 0
    @vdir = 1
    
    @emitter = SoundEmitter.new(@x, @y, "fx/buzz.wav", Level.current.player, 500)
  end
  
  def draw
    super(@hdir == -1 ? 1 : -1)
  end
  
  def update
    @emitter.update
    
    if @hdir == -1
      @x_offset_flip = 0 - @width
    else
      @x_offset_flip = 0
    end
    
    if @vdir == 1
      @hover += 1
      @y += 1
    else
      @hover -= 1
      @y -= 1
    end
    
    if @hover == 0
      @vdir = 1
    elsif @hover == 25
      @vdir = 0
    end
    
    unless @wait_until > Gosu.milliseconds
      if @distance > 0
        @x += @hdir
        @distance -= 1
        @wait_until = random_wait if @distance == 0
      elsif @distance == 0
        random_movement
      end
    end
  end
  
end