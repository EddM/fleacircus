module FrameHelper
  
  def frame
    if (Gosu::milliseconds - @last_frame) > @animation_speed
      @last_frame = Gosu::milliseconds
      @frame += 1
      if @frame >= @sprite.size
        @frame = 0
      end
    end
    
    @frame
  end
  
end