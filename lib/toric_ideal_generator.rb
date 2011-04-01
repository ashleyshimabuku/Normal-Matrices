# Find toric ideal of A
class ToricIdealGenerator
  MACAULAY2_COMMAND = "groebner %s"
  INPUT_FILENAME = "temp/tempfile.mat"
  OUTPUT_FILENAME = "temp/tempfile.gro"
  
  def initialize(normal_matrix)
    @normal_matrix = normal_matrix
  end
  
  def find
    # find toric ideal of the normal matrix
    return @toric_ideal if defined? @toric_ideal
    create_input_file
    run_macaulay2
    array = IO.readlines(OUTPUT_FILENAME).collect{
      |line| line.chop!}[2..-1].collect{
      |x| x.split(/\s/).map{|s| s.to_i}}    
    @toric_ideal = Matrix.rows(array)
  end

  def create_input_file
    File.open(INPUT_FILENAME, "w"){|file| file.puts }
  end

  def run_macaulay2
    $VERBOSE=nil
    system(MACAULAY2_COMMAND % INPUT_FILENAME)
  end      
end