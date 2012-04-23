module GeometryHelper

  def self.included(b)
    b.class_eval do
      attr_reader :x, :y, :width, :height
    end
  end
  
  def distance_to_point(px, py)
    Gosu.distance(mid_point_x, mid_point_y, px, py)
  end
  
  def intersects?(ent)
    !(ent.x > right || ent.right < x || ent.y > bottom || ent.bottom < y )
  end
  
  def intersects_point?(p_x, p_y = 0.0)
    p_x, p_y = p_x if p_x.is_a?(Array)
    p_x > x && p_x < right && p_y > y && p_y < bottom
  end
  
  def intersects_top?(ent)
    bottom >= ent.y && bottom < ent.bottom && (x >= ent.x || right >= ent.x)
  end
  
  def mid_point_x
    x + (width / 2)
  end
  
  def mid_point_y
    y + (height / 2)
  end
  
  def right
    x + width
  end
  
  def bottom
    y + height
  end
  
end