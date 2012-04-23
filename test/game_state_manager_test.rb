require "test/unit"
require "../lib/game_state_manager.rb"

class GameStateManagerTest < Test::Unit::TestCase

  def test_stack_push
    manager = GameStateManager.new
    str = String.new
    manager.push(str)
    
    assert_equal manager.active, str
    
    int = 1337
    manager.push(int)
    
    assert_equal manager.active, int
  end
  
  def test_stack
    manager = GameStateManager.new
    str = String.new
    manager.push(str)
    int = 1337
    manager.push(int)
    
    assert_equal 2, manager.stack.size
    assert_equal int, manager.stack[0]
    assert_equal str, manager.stack[1]
  end
  
  def test_stack_pop
    manager = GameStateManager.new
    str = String.new
    manager.push(str)
    int = 1337
    manager.push(int)
    popped = manager.pop
    
    assert_equal int, popped
    assert_equal str, manager.active
  end

end