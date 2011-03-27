# Find the interior facets
require 'array.rb'

class InteriorFacetGenerator
  FACET_VERTICES_COUNT = 3
  def initialize(hilbert_basis)
    @hilbert_basis = hilbert_basis
  end
  
  def generate
    return @interior_facets if defined? @interior_facets
    # Generate all possible facets by finding every 3 combination of the hilbert basis line numbers
    facets = create_all_facets
    # For each facet create a 4x3 matrix from the transpose of the 3x4 matrix for the line
    # numbers of the hilbert basis corresponding the facet's values

    # Get only the interior facets
    @interior_facets = facets.select { |f|
      # Populate a test equation array with -1 and 1s for each dot product
      # of the vector and a line from the hilbert basis
      test_equation = []
      
      @hilbert_basis.find.to_a.each{|hilbert_basis_line|
        line_vector = Vector.elements(hilbert_basis_line, true)
        
        dot_product = f[:det_vector].inner_product line_vector
        # if the simplex is on the positive side of the facet save a 1
        if dot_product > 0
          test_equation.push(1)
        elsif dot_product < 0 # if on the negative side save a -1
          test_equation.push(-1)        
        end                    
      }
      
      # If the test equation is of mixed signs then this is an interior facet
      !(test_equation.all_negative? || test_equation.all_positive?)
    }    
  end
  
  protected
  
    def create_all_facets
      (0...@hilbert_basis.find.to_a.size).to_a.combination(FACET_VERTICES_COUNT).to_a.collect{|f|
        matrix_4x3 = Matrix.rows(f.collect{|l| @hilbert_basis.find.to_a[l]} ).transpose
        # Generate all 3x3 submatrices combinations from the 4x3 matrix, IN REVERSE!
        # Then create a vector from the determinants of those combinations
        vector_array = matrix_4x3.to_a.combination(3).to_a.reverse.collect{|sub3x3| Matrix.rows(sub3x3).determinant}
        # Reverse the sign of the second and fourth elements of the vector array
        vector_array = [vector_array[0], -1*vector_array[1], vector_array[2], -1*vector_array[3]]
        # Turn it into a Vector object
        vector = Vector.elements(vector_array)
        
        f = {
          :facet => f,
          :det_vector => vector
        }
      }
    end
end
    
    
    