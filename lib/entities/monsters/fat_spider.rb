class FatSpider < Monster
  
  WebLength = 160
  
  def initialize(x, y, web_length = WebLength)
    @width, @height = 128, 64
    super("fat-spider.png", x, y, nil)
    @animation_speed = 750
    @web = Gosu::Image.new(GameWindow.current, "res/graphics/web.png", true)
    @web_angle, @web_dir, @web_length = 135, 0, web_length
    @y_offset = 32
  end
  
  def check_player_collision
    point = contact_point
    Level.current.player.grab!(self) if Level.current.player.intersects_point?(point[0], point[1])
  end
  
  def contact_point
    [mid_point_x + Gosu.offset_x(@web_angle, @web_length), mid_point_y + Gosu.offset_y(@web_angle, @web_length)]
  end
  
  def update
    check_player_collision
    adjust_angle
  end
  
  def adjust_angle
    if @web_dir == 0
      @web_angle -= 1
      @web_dir = 1 if @web_angle <= 135
    else
      @web_angle += 1
      @web_dir = 0 if @web_angle >= 225
    end
  end
  
  def draw
    super
    @web.draw_rot mid_point_x, bottom, Z::Scenery, @web_angle, 0.5, 1.0
  end
  
  def draw_debug
    p = contact_point
    GameWindow.current.draw_quad  p[0], p[1], Gosu::Color::RED,
                                  p[0] + 10, p[1], Gosu::Color::RED,
                                  p[0], p[1] + 10, Gosu::Color::RED,
                                  p[0] + 10, p[1] + 10, Gosu::Color::RED,
                                  Z::Debug
  end
  
  def mobile?
    false
  end
  
  def hurts?
    false
  end
  
  def affected_by_gravity?
    false
  end
  
end