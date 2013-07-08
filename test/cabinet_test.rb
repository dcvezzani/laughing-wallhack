require 'test/unit'
require './app/cabinet'
class CabinetTest < Test::Unit::TestCase

    def setup
      @cabinet = Cabinet.new
    end
  
    def test_default_constructor
    	cabinet = Cabinet.new
    	expected = cabinet.drawers.length
    	assert_equal expected, 3
    end

    def test_seeded_constructor
    	cabinet = Cabinet.new(5)
    	expected = cabinet.drawers.length
    	assert_equal expected, 5
    end

    def test_drawer_at_error_bad_input
      assert_raise(RuntimeError){ @cabinet.drawer_at(:bogus) }
    end

    def test_drawer_at_error_bad_range_too_low
      assert_raise(RuntimeError){ @cabinet.drawer_at(0) }
    end

    def test_drawer_at_error_bad_range_too_high
      assert_raise(RuntimeError){ @cabinet.drawer_at(4) }
    end

    def test_drawer_at_good_range_begin
      assert_nothing_raised(){ @cabinet.drawer_at(1) }
    end

    def test_drawer_at_good_range_end
      assert_nothing_raised(){ @cabinet.drawer_at(3) }
    end
end
