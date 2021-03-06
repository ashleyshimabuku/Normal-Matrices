require 'test/unit'
require 'hilbert_basis'

class TestHilbertBasis < Test::Unit::TestCase
  def test_find_basis
    h = HilbertBasis.new('1,2,3,4')
    expected = Matrix[[0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0], [1, 1, 1, 1], [1, 1, 2, 2], [1, 2, 3, 3], [1, 2, 3, 4]]
    assert_equal(expected, h.find)
    assert_equal(7, h.find.to_a.size)
  end
end
    