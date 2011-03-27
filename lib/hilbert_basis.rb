# Use Normaliz to find the hilbert basis of a matrix
require 'matrix'
class HilbertBasis
  NORMALIZ_COMMAND = "/Applications/Normaliz/norm64 -f %s"
  INPUT_FILENAME = "temp/tempfile.in"
  OUTPUT_FILENAME = "temp/tempfile.gen"
  
  attr_reader :cone, :basis
  
  def initialize(cone)
    @cone = cone
  end
  
  def find
    return @basis if defined? @basis
    create_input_file
    run_normalize
    array = IO.readlines(OUTPUT_FILENAME).collect{|line| line.chop!}[2..-1].collect{|x| x.split(/\s/).map{|s| s.to_i}}    
    @basis = Matrix.rows(array)
  end
  
  protected
  
    # Write input file in Normaliz format
    def build_matrix
      "4\n4\n1 0 0 0\n0 1 0 0\n0 0 1 0\n%s\nintegral_closure\n" %  @cone.split(/,/).join(' ')
    end
    
    def create_input_file
      File.open(INPUT_FILENAME, "w"){|file| file.puts build_matrix}
    end
    
    def run_normalize
      $VERBOSE=nil
      system(NORMALIZ_COMMAND % INPUT_FILENAME)
    end      
end