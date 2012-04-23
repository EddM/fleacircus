class GameStateManager
  
  attr_reader :stack
  
  def initialize
    @stack = []
  end
  
  def active
    @stack[0]
  end
  
  def replace(state)
    pop
    push(state)
  end
  
  def pop
    active.leave if active
    @stack.delete_at(0)
  end
  
  def push(state)
    active.leave if active
    @stack.insert(0, state)
    state.enter
    state
  end
  
  def self.current
    @@current ||= GameStateManager.new
  end
  
end