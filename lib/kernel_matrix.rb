class KernelMatrix
  INPUT_FILENAME = "temp/tempfile.m2"
  M2_COMMAND = "m2 --script %s"
  M2_TEMPLATE = "f = matrix{%s}; print kernel f;"
  
  attr_reader :kernel
  
	def initialize(hilbert_basis)
		@hilbert_basis = hilbert_basis
	end
	
	def find
	  return @kernel if defined?(@kernel)
	  # Create a Macaualy2 script
	  create_input_file
	  # Call Macaulay2 on the script
	  output = run_m2
	  # Parse the results	  
	  @kernel = Matrix.rows(output.gsub(/image|\|/, '').split("\n").collect{|row| row.split.collect!{|el| el.to_i}})
  end
  
  protected
  
    # Write input file in Macaulay2 format
    def build_matrix
      M2_TEMPLATE % @hilbert_basis.find.transpose.to_a.collect{|row| "{#{row.join(",")}}"}.join(",")
    end
    
    def create_input_file
      File.open(INPUT_FILENAME, "w"){|file| file.puts build_matrix}
    end
    
    def run_m2
      $VERBOSE=nil
      command = M2_COMMAND % INPUT_FILENAME
      `#{command}`
    end
end