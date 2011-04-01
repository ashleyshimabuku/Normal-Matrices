# Find a generic point that lives inside the hilbert basis
class GenericPoint
  def initialize(hilbert_basis)
    @hilbert_basis = hilbert_basis
    @random_numbers = Vector.elements(hilbert_basis.find.to_a.size.times.collect{ |x| random })    
  end
  
  # Find generic point p = r_1 c_1 + ... _ r_n c_n 
  # where r_i is random number vector and 
  # c_i is column vector of hilbert basis
  def find
    @hilbert_basis.find.transpose.to_a.collect{ |row|
      row_vector = Vector.elements(row.to_a, true)
      row_vector.inner_product @random_numbers
    }
  end
  
  protected
  
    # Generate rational random numbers between 1 and 10
    def random
      1 + (10 * rand(0))
    end
end