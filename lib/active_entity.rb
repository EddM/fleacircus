class ActiveEntity < Entity
  include FrameHelper

  def initialize(x, y)
    super(x, y)
    @jumping = false
    @jump = 0
    
    @animation_speed = 100
    @last_frame = Gosu::milliseconds
    @frame = 0
    @dir = 1
  end
    
  def update
    if affected_by_gravity? && !@grabbed
      @jump += 1
    
      if on_floor?
        @jumping = false
      else
        if @jump < 0
          apply_upward_trajectory
        elsif @jump > 0
          apply_gravity
        end      
      end
    end
  end
  
  def apply_upward_trajectory
    (-@jump).times do
      if fits_top?
        @y -= 1
      else
        @jump = 0
      end
    end

    @jump += 1
  end
  
  def apply_gravity
    @jump.times do
      if fits_bottom?
        @y += 1
      else
        @jump = 0
      end
    end
  end
  
end