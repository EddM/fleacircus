class Entity
  include GeometryHelper
  
  def initialize(x, y)
    @x, @y = x, y
    @speed = 1
    @y_offset, @x_offset = 0, 0
    @dead = false
  end
  
  def draw
    raise "Incomplete interface"
  end
  
  def update
    raise "Incomplete interface"
  end
  
  def on_floor?
    !fits_bottom?
  end
  
  def fits_top?
    @y >= 0 && !tile_top?
  end
  
  def fits_right?
    (@x < (Level.current.pixel_width - @width)) && !tile_right?
  end
  
  def fits_bottom?
    if @dead
      true
    else
      !(@y >= (Level.current.pixel_height - @height)) && !tile_below?
    end
  end
  
  def fits_left?
    @x >= 0 && !tile_left?
  end
  
  def tile_top?
    Level.current.tiles.any? { |t| 
      ((t.x <= x && t.right >= x) || (t.x <= right && t.right >= right)) && 
      t.bottom == (@y - 1)
    }
  end
  
  def tile_right?
    Level.current.tiles.any? { |t| 
      t.y <= mid_point_y && 
      t.bottom >= mid_point_y && 
      t.x >= right && 
      t.x <= (right + @speed)
    }
  end
  
  def tile_left?
    Level.current.tiles.any? { |t| 
      t.y <= mid_point_y && 
      t.bottom >= mid_point_y && 
      t.right >= (@x - @speed) && t.right <= @x
    }
  end
  
  def tile_below?
    Level.current.tiles.any? { |t| 
      ((t.x <= x && t.right >= x) || (t.x <= right && t.right >= right)) && 
      t.y == (bottom + 1)
    }
  end
  
  def affected_by_gravity?
    true
  end
  
end