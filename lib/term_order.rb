require 'mathn'

class TermOrderBatch
  attr_reader :term_orders
  
  SAGE = "/Applications/sage/sage"
  SAGE_INPUT_FILE = "temp/temp.sage"
  
  def initialize
    @term_orders = []
  end
  
  def << (term_order)
    @term_orders << term_order
  end
  
  def run
    File.delete(SAGE_INPUT_FILE) if File.exists?(SAGE_INPUT_FILE)
    @term_orders.each{|term_order|      
      command = format_command(term_order.supporting_hyperplane.size.to_s, term_order.v_vector.size.to_s, term_order.supporting_hyperplane, term_order.v_vector)
      File.open(SAGE_INPUT_FILE, "a") do |file|
        file.puts command
      end
    }
    
    results = `#{SAGE} #{SAGE_INPUT_FILE}`
    
    results = results.split("\n").collect{|line| line.chop!}    
    
    @term_orders.zip(results).each{|term_order, result|
      term_order.find(result)
    }
    
    @term_orders
  end

  protected  
    def format_command(rows, columns, basis, vector)
        basis = basis.transpose
        vector = vector.to_a
        "M = MatrixSpace(QQ,#{columns},#{rows}); A = M(#{basis}); V = VectorSpace(QQ,#{columns});b = V(#{vector}); print octave.solve_linear_system(A,b);"
    end
  
end

class TermOrder
  attr_reader :v_vector, :supporting_hyperplane, :kernel_matrix, :term_order
  
  def initialize(v_vector, supporting_hyperplane, kernel_matrix, hilbert_basis)
    @v_vector = v_vector
    @supporting_hyperplane = supporting_hyperplane
    @kernel_matrix = kernel_matrix
    @hilbert_basis = hilbert_basis
  end
  
  def find(result)
    @term_order if defined? @term_order
    
    result = result.gsub(/\[|\]|\s/,'').split(',').collect!{|el|Rational(el)}
    denominators = result.collect{|r| r.denominator}
    multiplier = lcm(*denominators)
    solution = result.collect{|el| (el * multiplier).to_i}
    
    kernel_matrix_indices = @supporting_hyperplane.collect{|row|
      @kernel_matrix.find.to_a.index(row)
    }
    
    @term_order = []  
    
    solution.each_index{|idx|
        if kernel_matrix_indices.index(idx)
          @term_order << solution[idx]
        else
          @term_order << 0
        end
    }
    
    while @term_order.size < @hilbert_basis.basis.row_vectors.size
      @term_order << 0
    end
    
    @term_order
  end
  
  protected
      
    def lcm(first, *rest)
      rest.inject(first) { |l, n| l.lcm(n) }
    end
  
end
