require 'test/unit'
require 'mocha'
require 'debugger'
require './app/cabinet_interface'

class DrawerInterfaceTest < Test::Unit::TestCase

    def setup
      @cabinet = Cabinet.new
      @interface = CabinetInterface.new(@cabinet)
    end

    def test_default_constructor
      assert_nothing_raised(ArgumentError){ CabinetInterface.new }
    end

    def test_implements_method_menu
      assert_nothing_raised{ @interface.menu }
    end

    def test_implements_method_process
      assert_nothing_raised{ @interface.process('C') }
    end

    def test_process_when_open_action_drawer_in_range
      res = @interface.process("1")
      assert_equal :drawer, res.keys.first
    end

    def test_process_when_open_action_drawer_out_of_range
      res = @interface.process("9")
      assert_equal :error, res.keys.first
    end

    def test_process_when_open_action_back_to_cabinet
      res = @interface.process("C")
      assert_equal :cabinet, res.keys.first
    end
   
    def test_process_when_closed_invalid_selection
      res = @interface.process("X")
      assert_equal :error, res.keys.first
    end
end
