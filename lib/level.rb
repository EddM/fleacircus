require 'yaml'

class Level

  attr_reader :tiles, :pickups, :monsters, :background, :map, :player, :exit, :spawn, :dialog, :next_level
  
  def initialize(name, player)
    @@current = self
    
    @player = player
    @pickups, @monsters, @scenery = [], [], []
    
    @data   = parse_data(File.open("res/levels/#{name}.yml"))
    @lines  = File.readlines("res/levels/#{name}.txt").map { |line| line.chomp }
    
    @spawn = [0, 0]
    
    @height = @lines.size
    @width  = @lines.max_by { |l| l.size }.size
    @map = parse_tiles
    @tiles = @map.flatten.compact
    @dialog = @data["opening_dialog"]
    @next_level = @data["next_level"].to_i
    
    @background = Gosu::Image.new(GameWindow.current, "res/#{@data["background"]}", true)
    
    play_music(@data["music"]) if @data["music"]
  end
  
  def parse_data(file)
    data = YAML.load(file.read)
    build_monsters(data['monsters'])

    data
  end
  
  def play_music(music)
    @music = Gosu::Song.new(GameWindow.current, "res/audio/#{music}")
    @music.play(true)
  end
  
  def stop_music
    @music.stop
  end
  
  def build_monsters(monsters)
    monsters.each do |monster|
      loc = monster['loc'].split(",").map { |c| c.to_i }
      case monster['type'].downcase
      when 'fat spider'
        @monsters << FatSpider.new(loc[0], loc[1])
      when 'spider'
        @monsters << Spider.new(loc[0], loc[1])
      when 'fly'
        @monsters << Fly.new(loc[0], loc[1])
      end
    end
  end
  
  def parse_tiles
    Array.new(@width) do |x|
      Array.new(@height) do |y|
        
        case @lines[y][x, 1]
        when "S"
          @spawn = [x * Tile::Size, y * Tile::Size]
          nil
        when "E"
          @exit = [(x * Tile::Size) + 25, (y * Tile::Size) + 25]
          @scenery << ExitTile.new((x * Tile::Size) - 128, (y * Tile::Size) - 192)
          nil
        when "c"
          CanTile.new(x * Tile::Size, y * Tile::Size)
        when "r"
          @pickups << RedFruit.new(x * Tile::Size, y * Tile::Size)
          nil
        when "o"
          @pickups << OrangeFruit.new(x * Tile::Size, y * Tile::Size)
          nil
        when "y"
          @pickups << YellowFruit.new(x * Tile::Size, y * Tile::Size)
          nil
        when "b"
          BoxTile.new(x * Tile::Size, y * Tile::Size)
        when "-"
          GroundTile.new(x * Tile::Size, y * Tile::Size)
        when "^"
          SpikedTile.new(x * Tile::Size, y * Tile::Size)
        when "#"
          @scenery << SpiderWebTile.new(x * Tile::Size, y * Tile::Size)
          nil
        end
        
      end
    end
  end
  
  def tile_at(x, y)
    @map[x / Tile::Size][y / Tile::Size]
  end
  
  def pixel_width
    @pixel_width ||= @width * Tile::Size
  end
  
  def pixel_height
    @pixel_height ||= @height * Tile::Size
  end
  
  def end!
    GameStateManager.current.push EndLevelState.new
  end
  
  def update
    @monsters.each do |m|
      m.update
    end
  end
  
  def draw
    @tiles.each do |tile|
      tile.draw
    end
    
    @pickups.each do |p|
      p.draw
    end
    
    @monsters.each do |m|
      m.draw
    end
    
    @scenery.each do |s|
      s.draw
    end
  end
  
  def self.current
    @@current
  end
  
end