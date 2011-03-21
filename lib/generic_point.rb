class GenericPoint
  def initialize(hilbert_basis)
    @hilbert_basis = hilbert_basis
    @random_numbers = Vector.elements(hilbert_basis.find.to_a.size.times.collect{ |x| random })    
  end
  
  def find
    @hilbert_basis.find.transpose.to_a.collect{ |row|
      row_vector = Vector.elements(row.to_a, true)
      row_vector.inner_product @random_numbers
    }
  end
  
  protected
  
    def random
      1 + (10 * rand(0))
    end
end