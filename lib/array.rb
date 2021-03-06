# Test to see if all entries in an array are 
# positive, negative or zero
class Array
  def all_positive?
    self.each {|v|
      return false if v < 0
    }
    true
  end
  
  def all_negative?
    self.each {|v|
      return false if v > 0
    }
    true
  end
  
  def all_zero?
    self.each{|v|
      return false if v != 0      
    }
    true
  end  
end