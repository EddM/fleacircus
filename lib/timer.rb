class Timer
  
  Frequency = 100
  
  def self.tick!
    timers.keys.select { |k| k <= Gosu.milliseconds }.each do |key|
      timers[key].call
      timers.delete(key)
    end
    last_update = Gosu.milliseconds
  end
  
  def self.in(ms, &block)
    timers[Gosu.milliseconds + ms] = block
  end
  
  def self.timers
    @@timers ||= {}
  end
  
  def self.last_update=(val)
    @@last_update = val
  end
  
  def self.last_update
    @@last_update ||= 0
  end
  
end