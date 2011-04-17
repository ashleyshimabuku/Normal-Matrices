# Find toric ideal of A
class ToricIdealGenerator
  GROEBNER_COMMAND = "groebner temp/foo"
  INPUT_FILENAME = "temp/foo.mat"
  COST_FILENAME = "temp/foo.cost"
  OUTPUT_FILENAME = "temp/foo.gro"
  
  def initialize(hilbert_basis, term_order)
    @normal_matrix = hilbert_basis.find.transpose
    @term_order = term_order
  end

  # find toric ideal of the normal matrix  
  def find
    return @toric_ideal if defined? @toric_ideal
    create_cost_file
    create_input_file
    run_groebner

    array = IO.readlines(OUTPUT_FILENAME)[1..-1]
    
    array.collect!{ |line|
      line.split(' ').collect{|el| el.to_i}
    }
    
    @toric_ideal = Matrix.rows(array)
  end

  def create_input_file
    File.open(INPUT_FILENAME, "w"){|file|      
      file.puts "#{@normal_matrix.row_size} #{@normal_matrix.column_vectors.size}"
      @normal_matrix.row_vectors.each {|row|
        file.puts row.to_a.join(' ')
      }
    }
  end

  def create_cost_file
    File.open(COST_FILENAME, "w"){|file|
      file.puts "1 #{@term_order.size}"
      file.puts @term_order.join(' ')
    }
  end
  
  def run_groebner
    $VERBOSE=nil
    system(GROEBNER_COMMAND % INPUT_FILENAME)
  end      
end