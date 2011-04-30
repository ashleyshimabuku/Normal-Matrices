# Find the interior facets
require 'array.rb'

class InteriorFacetGenerator
  FACET_VERTICES_COUNT = 4
  def initialize(hilbert_basis)
    @hilbert_basis = hilbert_basis
  end
  
  def generate
    return @interior_facets if defined? @interior_facets
    # Generate all possible facets by finding every 3 
    # combination of the hilbert basis line numbers
    facets = create_all_facets
    
    # Get only the interior facets
    @interior_facets = facets.select { |f|
      # Populate a test equation array with -1 and 
      # 1s for each dot product
      # of the vector and a line from the hilbert basis
      test_equation = []
      
      @hilbert_basis.find.to_a.each{|hilbert_basis_line|
        line_vector = Vector.elements(hilbert_basis_line, true)
        
        # Find determinant of matrix
        # x_1 a_1 b_1 c_1 d_1
        # x_2 a_2 b_2 c_2 d_2
        # x_3 a_3 b_3 c_3 d_3
        # x_4 a_4 b_4 c_4 d_4
        # x_5 a_5 b_5 c_5 d_5
        dot_product = f[:det_vector].inner_product line_vector
        # if the simplex is on the positive side of the facet
        if dot_product > 0
          test_equation.push(1)
        elsif dot_product < 0 # if on the negative side 
          test_equation.push(-1)        
        end                    
      }
      
      # If the test equation is of mixed signs 
      # then this is an interior facet
      !(test_equation.all_negative? || test_equation.all_positive?)
    }    
  end
  
  protected
  
    def create_all_facets
      (0...@hilbert_basis.find.to_a.size).to_a.combination(FACET_VERTICES_COUNT).to_a.collect{|f|
        matrix_5x4 = Matrix.rows(f.collect{
          |l| @hilbert_basis.find.to_a[l]} ).transpose
        # For each facet create a 5x4 matrix from the transpose
        #  of the 4x5 matrix for the line numbers of the hilbert
        # basis corresponding the facet's values
        # This creates a 5x4 matrix
        # a_1 b_1 c_1 d_1
        # a_2 b_2 c_2 d_2
        # a_3 b_3 c_3 d_3
        # a_4 b_4 c_4 d_4
        # a_5 b_5 c_5 d_5
        # Generate all 4x4 submatrices from the 5x4 matrix
        # (IN REVERSE!)
        # Create a vector from the determinants of those combinations
        vector_array = matrix_5x4.to_a.combination(4).to_a.reverse.collect{|sub4x4| Matrix.rows(sub4x4).determinant}
        # Fix the sign
        vector_array = [vector_array[0], -1*vector_array[1], vector_array[2], -1*vector_array[3], vector_array[4]]
        # Turn it into a Vector object
        vector = Vector.elements(vector_array)
        
        f = {
          :facet => f,
          :det_vector => vector
        }
      }
    end
end
    
    
    