class Polytope
  INPUT_FILENAME = "temp/tempfile.polymake"
  POLYMAKE_COMMAND = "polymake %s VERTICES"
  
  attr_accessor :vertices
  
  def initialize(kernel_matrix)
    @kernel_matrix = kernel_matrix
  end
  
  def create
    return @vertices if defined?(@vertices)
    # write Polymake input file for P_0 polytope
    create_input_file
    # find the vertices of P_0 polytope
    output = run_polymake
    @vertices = Matrix.rows(output.split("\n").slice(1..-1).collect!{|row| row.split.slice(1..-1).collect!{|e| Rational(e)}})
  end
  
  def find_supporting_hyperplanes
    # for each vertex find dot product with each row of kernel_matrix
    # collect them into sets of hyperplanes        
    @vertices.row_vectors.collect{|polytope_row| 
      kernel_rows = @kernel_matrix.kernel.row_vectors.select{ |kernel_row|
        polytope_row.inner_product(kernel_row) == -1
      }
    }
  end
  
  protected

    # Write input file in Polymake format
    def build_matrix
      @kernel_matrix.find.to_a.collect{|row| "1 #{row.join(" ")}"}.join("\n")
    end

    def create_input_file
      File.open(INPUT_FILENAME, "w") { |file| 
        file.puts "INEQUALITIES"
        file.puts build_matrix
      }
    end

    def run_polymake
      $VERBOSE=nil
      command = POLYMAKE_COMMAND % INPUT_FILENAME
      `#{command}`
    end
end