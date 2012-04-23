class Monster < ActiveEntity
  
  def initialize(sprite, x, y, range = 50)
    super(x, y)
    @sprite = Gosu::Image.load_tiles(GameWindow.current, "res/graphics/#{sprite}", @width, @height, true)
    @range, @initial = range, x
    @hdir, @distance, @wait_until = 1, 1, -1
    SoundEffectManager.current.register :boing
    
    random_movement
  end
  
  def draw(f_x = 1, f_y = 1)
    @sprite[frame].draw(@x + @x_offset + @x_offset_flip.to_i, @y + @y_offset, Z::Monsters, f_x, f_y)
  end
  
  def update
    super
    
    if mobile?      
      unless @wait_until > Gosu.milliseconds
        if @distance > 0
          if @hdir == 1
            @x += @hdir if fits_right?
          else
            @x += @hdir if fits_left?
          end
        
          @distance -= 1
          @wait_until = random_wait if @distance == 0
        elsif @distance == 0
          random_movement
        end
      end
    end
  end
  
  def distance_from_spawn
    diff = @x - @initial
    diff = (0 - diff) if diff < 0
    diff
  end
  
  def mobile?
    true
  end
  
  def jumpable?
    false
  end
  
  def hurts?
    true
  end
  
  def destroy!
    SoundEffectManager.current.play! :boing
    Level.current.monsters.delete(self)
  end 
  
  protected
  
  def random_movement
    @hdir = [-1, 1][rand(2)]
    @distance = (rand(3) + 1) * 25
  end
  
  def random_wait
    Gosu.milliseconds + ((rand(5) + 1) * 1000)
  end
  
end