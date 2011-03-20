require 'test/unit'
require 'lib/hilbert_basis'
require 'lib/unimodular_simplex_generator'

class TestUnimodularSimplexGenerator < Test::Unit::TestCase
  def test_generate_simplices
    h = HilbertBasis.new('1,2,3,4')
    expected = Matrix[[0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0], [1, 1, 1, 1], [1, 1, 2, 2], [1, 2, 3, 3], [1, 2, 3, 4]]
    assert_equal(expected, h.find)
    
    gen = UnimodularSimplexGenerator.new(h)
    assert_equal(18, gen.generate.size)    
  end
end
