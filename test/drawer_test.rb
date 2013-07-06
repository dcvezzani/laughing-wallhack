require 'test/unit'
#require 'debugger'
require './app/drawer'

class DrawerTest < Test::Unit::TestCase
    def test_default_constructor_drawer_should_be_closed
    	drawer = Drawer.new
    	assert_equal Drawer::CLOSED, drawer.position
    end

    def test_default_constructor_content_should_be_an_empty_array
    	drawer = Drawer.new
    	assert_equal [], drawer.contents
    end

    def test_main_constructor_with_the_drawer_open
    	drawer = Drawer.new(Drawer::OPEN)
    	assert_equal Drawer::OPEN, drawer.position
    end

    def test_main_constructor_with_a_populated_array
    	drawer = Drawer.new(Drawer::OPEN, [1,2,3])
    	assert_equal [1,2,3], drawer.contents
    end

    def test_place_item
    	drawer = Drawer.new(Drawer::OPEN)
      drawer.place("red socks")
    	assert_equal ["red socks"], drawer.contents
    end

    def test_place_item_returns_item_last_added
    	drawer = Drawer.new(Drawer::OPEN)
      added_item = drawer.place("red socks")
    	assert_equal "red socks", added_item
    end

    def test_dont_place_item_when_closed
    	drawer = Drawer.new(Drawer::CLOSED)
      drawer.place("red socks")
    	assert_equal [], drawer.contents
    end

    def test_list_content
    	drawer = Drawer.new(Drawer::OPEN)
      %w{red_socks white_shirt blue_pants}.each{|item| drawer.place item }
    	assert_equal "red_socks, white_shirt, blue_pants", drawer.list_content
    end

    def test_list_content_when_itemized
    	drawer = Drawer.new(Drawer::OPEN)
      %w{red_socks white_shirt blue_pants}.each{|item| drawer.place item }
expected = <<-EOL
1. 'red_socks'
2. 'white_shirt'
3. 'blue_pants'
EOL
    	assert_equal expected.split(/\n/), drawer.list_content(true)
    end

    def test_remove
    	drawer = Drawer.new(Drawer::OPEN)
      %w{red_socks white_shirt blue_pants}.each{|item| drawer.place item }
      drawer.remove("red_socks")

    	assert !drawer.contents.include?("red_socks")
    end

    def test_remove_returns_removed_item
    	drawer = Drawer.new(Drawer::OPEN)
      %w{red_socks white_shirt blue_pants}.each{|item| drawer.place item }
      removed_item = drawer.remove("red_socks")

    	assert_equal "red_socks", removed_item
    end

    def test_
    	drawer = Drawer.new()
    	#assert_equal drawer.contents, [1,2,3]
    end

    def test_
    	drawer = Drawer.new()
    	#assert_equal drawer.contents, [1,2,3]
    end

    def test_
    	drawer = Drawer.new()
    	#assert_equal drawer.contents, [1,2,3]
    end

    def test_
    	drawer = Drawer.new()
    	#assert_equal drawer.contents, [1,2,3]
    end
end

