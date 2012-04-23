class SoundEmitter
  
  def initialize(x, y, file = nil, object = nil, max_distance = 1000, pannable = false)
    @x, @y = x, y
    @object, @max_distance, @pannable = object, max_distance, pannable
    
    if file
      @sound = Gosu::Sample.new(GameWindow.current, "res/audio/#{file}")
      @sample = @sound.play_pan(0.0, 0.0, 1.0, true)
    end
  end
  
  def update
    distance = distance_to_object
    if distance <= @max_distance
      @sample.resume if @sample.paused?
      @sample.pan = pan(distance) if @pannable
      @sample.volume = volume_based_on_distance(distance)
    else
      @sample.pause if @sample.playing?
      @sample.volume = 0.0
    end
  end
  
  def pan(distance = nil)
    distance = distance_to_object unless distance
    
    if @object.x < @x
      0 - volume_based_on_distance(distance)
    elsif @object.x > @x
      volume_based_on_distance(distance)
    else
      0.0
    end
  end
  
  def distance_to_object
    @object.distance_to_point(@x, @y)
  end
  
  def volume_based_on_distance(distance = nil)
    distance = distance_to_object unless distance
    1.0 - (1.0 / (@max_distance / distance))
  end
  
  def in_range?
    distance_to_object <= @max_distance
  end
  
end