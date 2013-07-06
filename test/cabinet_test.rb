require 'test/unit'
require './app/cabinet'
class CabinetTest < Test::Unit::TestCase
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
end
