require 'test/unit'
require 'hilbert_basis'
require 'interior_facet_generator'

class TestInteriorFacetGenerator < Test::Unit::TestCase
  def test_find_interior_facets
    h = HilbertBasis.new('1,2,3,4')
    expected = Matrix[[0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0], [1, 1, 1, 1], [1, 1, 2, 2], [1, 2, 3, 3], [1, 2, 3, 4]]
    assert_equal(expected, h.find)
    assert_equal(7, h.find.to_a.size)
    
    interior_facet_generator = InteriorFacetGenerator.new(h)
    interior_facets = interior_facet_generator.generate
    
    assert_equal(28, interior_facets.size)    
  end
end
    