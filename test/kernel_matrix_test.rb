require 'test/unit'
require 'hilbert_basis'
require 'kernel_matrix'
require 'polytope'

class TestKernelMatrix < Test::Unit::TestCase
  def test_find_basis
    h = HilbertBasis.new('1,2,3,4')
    expected = Matrix[[0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0], [1, 1, 1, 1], [1, 1, 2, 2], [1, 2, 3, 3], [1, 2, 3, 4]]
    assert_equal(expected, h.find)
    assert_equal(7, h.find.to_a.size)
    
    kernel_matrix = KernelMatrix.new(h)
    assert_equal(7, kernel_matrix.find.to_a.size)
    assert_equal(3, kernel_matrix.find.to_a.first.size)
    
    polytope = Polytope.new(kernel_matrix)
    polytope.create
    
    assert_equal(kernel_matrix.find.to_a.size, polytope.vertices.to_a.size)
  end
end
    