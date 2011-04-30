# Find the unimodular simplices of the hilbert basis
class UnimodularSimplexGenerator
  VERTICES = 5  # Variable to change for higher dimensions
  def initialize(hilbert_basis)
    @hilbert_basis = hilbert_basis
  end
  
  def generate
    results = []
    linenumbers = generate_linenumbers
    submatrices = generate_submatrices
    # for each simplex find the determinant
    submatrices.each_index { |idx|
      linenumber = linenumbers[idx]
      submatrix = submatrices[idx]
      determinant = submatrix.determinant
      # If the determinant is 1 or -1 then it is unimodular
      if determinant.abs == 1         
        results.push(UnimodularSimplex.new(submatrix, linenumber))
      end
    }
    results
  end
  
  protected
    
    # Generate all possible simplices
    def generate_submatrices
      @hilbert_basis.find.to_a.combination(VERTICES).collect{ 
        |x|Matrix.rows(x)}
    end
    
    # Generate all 4 combinations of the line numbers of 
    # the columns vectors of the hilbert basis
    # these serve as reference points for later in the program
    def generate_linenumbers
      (0...@hilbert_basis.basis.to_a.size).to_a.combination(VERTICES).to_a
    end
end

class UnimodularSimplex
  attr_reader :submatrix, :linenumbers
  
  def initialize(submatrix, linenumbers)
    @submatrix = submatrix
    @linenumbers = linenumbers
  end
end