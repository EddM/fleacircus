class GameState
  
  def update
    raise "Incomplete interface"
  end
  
  def draw
    raise "Incomplete interface"
  end
  
  def enter
  end
  
  def leave
  end
  
  def needs_cursor?
    false
  end
  
  def exclusive_update?
    true
  end
  
  def exclusive_draw?
    true
  end
  
end