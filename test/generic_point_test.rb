require 'test/unit'
require 'hilbert_basis'
require 'generic_point'

class TestGenericPoint < Test::Unit::TestCase
  def test_generic_point
    h = HilbertBasis.new('1,2,3,4')
    expected = Matrix[[0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0], [1, 1, 1, 1], [1, 1, 2, 2], [1, 2, 3, 3], [1, 2, 3, 4]]
    assert_equal(expected, h.find)
    assert_equal(7, h.find.to_a.size)
    
    generic_point = GenericPoint.new(h)
    
    assert_equal(h.find.transpose.to_a.size, generic_point.find.size)
  end
end
    