
class Time
  def self.stamp
    Time.now.utc.stamp
  end
  
  def stamp
    to_i * 1_000_000 + usec
  end
end
        
