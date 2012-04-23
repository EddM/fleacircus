class SoundEffectManager

  def initialize
    @sound_bank = {}
    @playing = {}
  end
  
  def play(effect)
    snd = @sound_bank[effect.to_sym]
    if snd.is_a?(Array)
      @playing[effect] = snd[rand(snd.size)].play
    else
      @playing[effect] = snd.play
    end
  end
  
  def playing?(effect)
    @playing[effect.to_sym] && @playing[effect.to_sym].playing?
  end
  
  def register(effect_name, sounds = nil)
    if sounds
      @sound_bank[effect_name.to_sym] = sounds.map do |snd|
        Gosu::Sample.new(GameWindow.current, "res/audio/fx/#{snd.to_s}.wav")
      end
    else
      @sound_bank[effect_name.to_sym] = Gosu::Sample.new(GameWindow.current, "res/audio/fx/#{effect_name.to_s}.wav")
    end
  end
  
  def self.current
    @@current ||= SoundEffectManager.new
  end
  
  alias :play! :play
  alias :<< :register
  
end