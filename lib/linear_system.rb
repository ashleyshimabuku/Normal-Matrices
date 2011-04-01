# Solve a linear system Ax = b
require 'matrix'

class LinearSystem
  def initialize(unimodular_simplex, generic_point)
    @unimodular_simplex = unimodular_simplex
    @generic_point = generic_point
  end

  def solve
    # Find the transpose of A
    transpose = @unimodular_simplex.submatrix.transpose
    coefficients = transpose.to_a.collect! {|row|
      row.collect! {|x| Rational(x)}
    }
    coefficients = Matrix[*coefficients]
    # define b
    constants = Matrix.columns(@generic_point.collect{
      |c| [Rational(c)]}).transpose
    # Find b A^-1
    solutions = coefficients.inverse * constants
    solutions.transpose.to_a.first
  end
end
    