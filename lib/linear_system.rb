# Solve a linear system Ax = b
require 'matrix'

class LinearSystem
  def initialize(unimodular_simplex, generic_point)
    @unimodular_simplex = unimodular_simplex
    @generic_point = generic_point
  end
  
  def solve
    transpose = @unimodular_simplex.submatrix.transpose
    coefficients = transpose.to_a.collect! {|row|
      row.collect! {|x| Rational(x)}
    }
    coefficients = Matrix[*coefficients]
    constants = Matrix.columns(@generic_point.collect{|c| [Rational(c)]}).transpose
    solutions = coefficients.inverse * constants
  end
end
    