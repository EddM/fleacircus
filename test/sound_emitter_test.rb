require "test/unit"
require "rubygems"
require "gosu"
require "../lib/audio/sound_emitter.rb"

class Point
  attr_accessor :x, :y
  
  def initialize(x, y)
    @x, @y = x, y
  end
  
  def distance_to_point(px, py)
    Gosu.distance(mid_point_x, mid_point_y, px, py)
  end
  
  def mid_point_x; @x; end
  def mid_point_y; @y; end
end

class SoundEmitterTest < Test::Unit::TestCase
  
  def test_sound_emitter_volume
    obj = Point.new(150, 150)
    emitter = SoundEmitter.new(50, 50, nil, obj)
    
    assert emitter.in_range?
    assert_equal 141, emitter.distance_to_object.to_i
    
    volume = emitter.volume_based_on_distance
    obj.x = 200
    obj.y = 175
    new_volume = emitter.volume_based_on_distance
    
    assert_equal 195, emitter.distance_to_object.to_i
    assert (volume > new_volume), "old: #{volume}, new: #{new_volume}"
    
    obj.x = 9000
    obj.y = 9000
    
    assert !emitter.in_range?
  end
  
  def test_sound_emitter_pan
    obj = Point.new(100, 100)
    emitter = SoundEmitter.new(200, 100, nil, obj, 200)
    
    assert_equal -0.5, emitter.pan
    
    obj.x = 300

    assert_equal 0.5, emitter.pan
  end

end