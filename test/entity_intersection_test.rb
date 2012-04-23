require "test/unit"
require "../lib/entity.rb"

class EntityIntersectionTest < Test::Unit::TestCase
  
  def test_top_intersection
    Entity.send(:public, *Entity.protected_instance_methods) 
    e1 = BasicEntity.new(10, 10, 100, 50)
    e2 = BasicEntity.new(20, 20, 40, 75)
    e3 = BasicEntity.new(90, 25, 50, 50)
    
    assert e1.intersects?(e2)
    assert e1.intersects_top?(e2)
    assert e1.intersects_top?(e3)
    assert !e2.intersects?(e3)
  end

end