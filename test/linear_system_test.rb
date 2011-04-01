require 'test/unit'
require 'array'
require 'hilbert_basis'
require 'unimodular_simplex_generator'
require 'linear_system'
require 'generic_point'

class TestLinearSystem < Test::Unit::TestCase
  def test_solve_linear_system
    h = HilbertBasis.new('1,2,3,4')
    expected = Matrix[[0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0], [1, 1, 1, 1], [1, 1, 2, 2], [1, 2, 3, 3], [1, 2, 3, 4]]
    assert_equal(expected, h.find)
    
    gen = UnimodularSimplexGenerator.new(h)
    assert_equal(18, gen.generate.size)    
    
    generic_point = GenericPoint.new(h)
    
    l = LinearSystem.new(gen.generate.first, generic_point.find)
    assert_equal(gen.generate.first.submatrix.to_a.size, l.solve.to_a.size)
  end
end
