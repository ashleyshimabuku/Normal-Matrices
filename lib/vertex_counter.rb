# Use Azove to find the number of 0/1 vertices
class VertexCounter
  def initialize(first_equation, facets, hilbert_basis, unimodular_simplices)
    @first_equation = first_equation
    @facets = facets
    @hilbert_basis = hilbert_basis
    @unimodular_simplices = unimodular_simplices
  end
  
  # For each interior facet write an equation 
  # 0 = sum x_i - sum x_j for x_i on the positive side and x_j on the negative side of the facet
  def count
    facet_equations = @facets.collect{|facet|
      facet_equation = [0]
      @unimodular_simplices.each{|simplex|
        difference = simplex.linenumbers - facet[:facet]
        if difference.size == 1 
          hilbert_line = Vector.elements(@hilbert_basis.basis.to_a[difference.first])
          facet_basis_dot_product = facet[:det_vector].inner_product hilbert_line

          if facet_basis_dot_product > 0
            facet_equation.push(-1)
          elsif facet_basis_dot_product < 0
            facet_equation.push(1)              
          end              
        else
          facet_equation.push(0)
        end  
      }
      
      facet_equation
    }.keep_if{|equation| !equation.all_zero?}
    
    # Generate 0 <= x_i <= 1 for all x_i
    lower_bounds = Matrix.diagonal(*@unimodular_simplices.size.times.collect{|x| 1}).to_a.collect!{|row|row.unshift(0)}
    upper_bounds = Matrix.diagonal(*@unimodular_simplices.size.times.collect{|x| -1}).to_a.collect!{|row|row.unshift(1)}
    
    # Write input file in Azove format
    @INPUT_FILENAME = "count.ine"
    File.open(@INPUT_FILENAME, "w") {|file|
      file.puts @INPUT_FILENAME
      file.puts "H-representation"
      file.printf "linearities %d %s\n", facet_equations.size+1, (1..facet_equations.size+1).to_a.join(' ')
      file.puts "begin"
      file.printf "%d %d integer\n", facet_equations.size+1+(2*@unimodular_simplices.size), @unimodular_simplices.size+1
      file.puts @first_equation.join(' ')
      facet_equations.each{|eq| file.puts eq.join(' ')}
      lower_bounds.each{|b| file.puts b.join(' ')}
      upper_bounds.each{|b| file.puts b.join(' ')}
      file.puts "end"
    }
    
    # output is stderr    
  	output = `azove2 -c count.ine 2>&1`;
  	
    vertices_count = /Number of 0\/1 vertices = (\d+)/.match(output).captures.first
    
  end
end

    