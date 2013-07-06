require 'test/unit'
require 'mocha'
require 'debugger'
require './app/drawer_interface'
require './test/dummy_interface'

class DrawerInterfaceTest < Test::Unit::TestCase

    def setup
      @drawer = Drawer.new
      @interface = DrawerInterface.new(@drawer)
      @dummy_interface = DummyInterface.new 
    end

    def test_default_constructor_requires_a_drawer
      assert_raise(ArgumentError){ DrawerInterface.new }
    end

    def test_implements_method_menu
      assert_nothing_raised{ @interface.menu }
    end

    def test_implements_method_process
      assert_nothing_raised{ @interface.process('C') }
    end

    def test_selectable_interface_inheritant_must_implement_menu
      assert_raise(RuntimeError){ @dummy_interface.menu }
    end

    def test_selectable_interface_inheritant_must_implement_process
      assert_raise(RuntimeError){ @dummy_interface.process }
    end

    def test_menu_open
      @drawer.open
      @interface = DrawerInterface.new(@drawer)
      @interface.expects(:menu_open).returns "menu is displayed for opened drawer"

      @interface.menu
    end

    def test_menu_open_no_menu_closed
      @drawer.open
      @interface = DrawerInterface.new(@drawer)
      @interface.stubs(:menu_open).returns "menu is displayed for opened drawer"
      @interface.expects(:menu_closed).never

      @interface.menu
    end

    def test_menu_close
      @drawer.close
      @interface = DrawerInterface.new(@drawer)
      @interface.expects(:menu_closed).returns "menu is displayed for closed drawer"

      @interface.menu
    end
    
    def test_menu_close_no_menu_opened
      @drawer.close
      @interface = DrawerInterface.new(@drawer)
      @interface.stubs(:menu_closed).returns "menu is displayed for closed drawer"
      @interface.expects(:menu_open).never

      @interface.menu
    end

    def test_process_when_open_invalid_selection
      @drawer.open
      @interface = DrawerInterface.new(@drawer)
      res = @interface.process("X")
      assert_equal :error, res.keys.first
    end

    def test_process_when_open_action_close
      @drawer.open
      @interface = DrawerInterface.new(@drawer)
      res = @interface.process("1")
      assert_equal :drawer, res.keys.first
    end

    def test_process_when_open_action_place_valid_position
      @drawer.open
      @interface = DrawerInterface.new(@drawer)
      @interface.stubs(:prompt_user_for_input).returns("red socks")
      res = @interface.process("2")
      assert_equal :info, res.keys.first
    end

    def test_process_when_open_action_place_unable_to_place
      @drawer.open
      @drawer.stubs(:place).returns(false)
      @interface = DrawerInterface.new(@drawer)
      @interface.stubs(:prompt_user_for_input).returns("red socks")
      res = @interface.process("2")
      assert_equal :error, res.keys.first
    end

    def test_process_when_open_action_place_prompts_for_user_input
      @drawer.open
      @drawer.stubs(:place).returns(false)
      @interface = DrawerInterface.new(@drawer)
      @interface.expects(:prompt_user_for_input).returns("red socks")
      @interface.process("2")
    end

    def test_process_when_open_action_remove
      @drawer.open
      @drawer.stubs(:list_content).returns("drawer content is listed")
      @drawer.expects(:remove).with("red socks").returns(true)
      @interface = DrawerInterface.new(@drawer)
      @interface.stubs(:prompt_user_for_input).returns("red socks")
      res = @interface.process("3")
      assert_equal :info, res.keys.first
    end
    
    def test_process_when_open_action_remove_fails
      @drawer.open
      @drawer.stubs(:list_content).returns("drawer content is listed")
      @drawer.expects(:remove).with("red socks").returns(false)
      @interface = DrawerInterface.new(@drawer)
      @interface.stubs(:prompt_user_for_input).returns("red socks")
      res = @interface.process("3")
      assert_equal :error, res.keys.first
    end
    
    def test_process_when_open_action_remove_prompts_for_user_input
      @drawer.open
      @drawer.stubs(:list_content).returns("drawer content is listed")
      @drawer.stubs(:remove).with("red socks").returns(true)
      @interface = DrawerInterface.new(@drawer)
      @interface.expects(:prompt_user_for_input).returns("red socks")
      @interface.process("3")
    end
   
    def test_process_when_open_action_back_to_cabinet
      @drawer.open
      @interface = DrawerInterface.new(@drawer)
      res = @interface.process("C")
      assert_equal :cabinet, res.keys.first
    end
    
    def test_process_when_closed_invalid_selection
      @drawer.close
      @interface = DrawerInterface.new(@drawer)
      res = @interface.process("X")
      assert_equal :error, res.keys.first
    end
end
