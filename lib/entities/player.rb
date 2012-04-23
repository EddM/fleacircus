class Player < ActiveEntity

  include FrameHelper

  attr_reader :score, :lives
  
  InitialPosition = { :x => 10, :y => GameWindow::Height - 200 }
  InitialSpeed = 3
  InitialLives = 3

  def initialize(x = InitialPosition[:x], y = InitialPosition[:y])
    super(x, y)
    @score, @invulnerable = 0, -1
    @sprite = Gosu::Image.load_tiles(GameWindow.current, "res/graphics/pip.png", 41, 48, false)
    @width, @height = @sprite[0].width, @sprite[0].height
    @jump_height = 20
    @speed, @lives = InitialSpeed, InitialLives
    @x_offset = 0
    
    SoundEffectManager.current.register :jump, ['jump1', 'jump2']
    SoundEffectManager.current.register :ouch
    SoundEffectManager.current.register :die
  end
  
  def get_pickups
    Level.current.pickups.select { |p| p.intersects?(self) }.each do |p|
      p.contact!(self)
    end
  end
  
  def grab!(fat_spider)
    unless cannot_grab?
      @grabbed = fat_spider
      @jumping = false
    end
  end
  
  def cannot_grab?
    @grab_lock && @grab_lock > Gosu.milliseconds
  end
  
  def update
    unless @dead
      get_pickups
      check_monsters
      check_tile_below
      check_end_level
    
      if !@grabbed
        move
      else
        @x, @y = @grabbed.contact_point[0].floor - (@width / 2), @grabbed.contact_point[1].floor + (@height / 2)
      end
    
      jump if (on_floor? || @grabbed) && GameWindow.current.button_down?(Gosu::KbUp)
    end
    
    super
  end
  
  def check_end_level
    Level.current.end! if intersects_point?(Level.current.exit)
  end
  
  def check_tile_below
    tile_below = Level.current.tile_at(@x, bottom)
    tile_below.contact(self) if tile_below.respond_to?(:contact)
  end
  
  def check_monsters
    monsters = Level.current.monsters.select { |m| m.intersects? self }
    monsters.select { |m| self.intersects_top?(m) && m.jumpable? }.each do |m|
      monsters.delete(m)
      force_jump
      m.destroy!
    end
    
    self.hurt! if monsters.select { |m| m.hurts? }.size > 0
  end
  
  def hurt!
    unless invulnerable?
      if (@lives - 1) <= 0
        die!
      else
        SoundEffectManager.current.play! :ouch
        @invulnerable = Gosu.milliseconds + 2000
        @lives -= 1
        force_jump
      end
    end
  end
  
  def die!
    @dead = true
    SoundEffectManager.current.play! :die
    force_jump
    Timer.in(1500) do
      GameWindow.current.game_over!(@score)
    end
  end
  
  def invulnerable?
    @invulnerable > Gosu.milliseconds
  end
  
  def move
    @moving = false
    if GameWindow.current.button_down?(Gosu::KbLeft)
      @moving = true
      move_left if fits_left?
    end
    
    if GameWindow.current.button_down?(Gosu::KbRight)
      @moving = true
      move_right if fits_right?
    end
  end
  
  def move_left
    @x -= @speed
    @dir = -1
    @x_offset = @width
  end
  
  def move_right
    @x += @speed
    @dir = 1
    @x_offset = 0
  end
  
  def force_jump
    @jumping = false
    jump
  end
  
  def jump
    unless @jumping
      SoundEffectManager.current.play!(:jump) unless SoundEffectManager.current.playing?(:ouch)
      
      if @grabbed
        @grabbed = nil
        @grab_lock = Gosu.milliseconds + 1000
      end
      @jumping = true
      @y -= 1
      @jump = (-@jump_height)
    end
  end
  
  def draw
    @sprite[@moving ? frame : 0].draw @x + @x_offset, @y, Z::Player, @dir, 1.0, (invulnerable? ? 0xffff0000 : 0xffffffff)
  end
  
  def red_fruit!
    @jump_height += 5
    @score += 10
  end
  
  def orange_fruit!
    @score += 10
    @lives += 1
  end
  
  def yellow_fruit!
    @score += 25
  end
  
  def spawn!(point)
    @x, @y = point
  end
  
end