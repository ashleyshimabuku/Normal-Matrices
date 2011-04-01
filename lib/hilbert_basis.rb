# Use Normaliz to find the hilbert basis of a matrix
require 'matrix'
class HilbertBasis
  NORMALIZ_COMMAND = "norm64 -f %s"
  INPUT_FILENAME = "temp/tempfile.in"
  OUTPUT_FILENAME = "temp/tempfile.gen"
  
  attr_reader :cone, :basis
  
  def initialize(cone, supporting_hyperplane=nil)
    @cone = cone.gsub("\n", "").split(/,/) unless cone.nil?
    @supporting_hyperplane = supporting_hyperplane
  end
  
  def find
    # find the hilbert basis of C[a_1,a_2,a_3,a_4]
    return @basis if defined? @basis
    create_input_file_for_cone
    run_normalize
    array = IO.readlines(OUTPUT_FILENAME).collect{
      |line| line.chop!}[2..-1].collect{
      |x| x.split(/\s/).map{|s| s.to_i}}    
    @basis = Matrix.rows(array)
  end
  
  def find_from_hyperplane
    # find the hilbert basis of the normal cone of a vertex of P_0
    return @basis if defined? @basis
    create_input_file_for_hyperplane
    run_normalize
    array = IO.readlines(OUTPUT_FILENAME).collect{
      |line| line.chop!}[2..-1].collect{
      |x| x.split(/\s/).map{|s| s.to_i}}    
    @basis = Matrix.rows(array)
  end
  
  protected
  
    # Write input file in Normaliz format
    def build_matrix_from_cone
      [ "4",
        "4",
        "1 0 0 0",
        "0 1 0 0",
        "0 0 1 0",
        @cone.join(' '),
        "integral_closure"].join("\n")
    end
    
    # Write input file in Normaliz format
    def build_matrix_from_hyperplane
      matrix = [
        @supporting_hyperplane.size,        
        @supporting_hyperplane.first.size,
      ]
      # the normal cone = {-b_i} where b_i is in Gale Diagram
      # b_i is a supporting hyperplane of v
      @supporting_hyperplane.each {|row|
        reversed_signs = row.collect{|el| el * -1 }
        matrix.push(reversed_signs.to_a.join(' '))
      }
      matrix.push("integral_closure")
      matrix.join("\n")
    end
    
    def create_input_file_for_cone
      File.open(INPUT_FILENAME, "w"){
        |file| file.puts build_matrix_from_cone}
    end
    
    def create_input_file_for_hyperplane
      File.open(INPUT_FILENAME, "w"){
        |file| file.puts build_matrix_from_hyperplane}
    end
    
    def run_normalize
      $VERBOSE=nil
      system(NORMALIZ_COMMAND % INPUT_FILENAME)
    end      
end