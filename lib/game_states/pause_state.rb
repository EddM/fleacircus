class PauseState < GameState

  def initialize
    @dialog = DialogBox.new("Paused")
  end
  
  def exclusive_draw?
    false
  end
  
  def update
    GameWindow.current.unpause! if GameWindow.current.button_down? Gosu::KbP
  end
  
  def draw
    @dialog.draw
  end
  
end