require 'test/unit'
require 'mocha'
require 'debugger'
require './app/user_interface'

module UserInterfaceTestExtention
  def self.extended(obj)
    class << obj
      attr_accessor :cabinet_interface, :navigator
    end
  end
end

class UserInterfaceTest < Test::Unit::TestCase

    def setup
      @cabinet = Cabinet.new
      @interface = UserInterface.new(@cabinet)
      #@interface = UserInterface.new(@cabinet).extend(UserInterfaceTestExtention)
      @msg = "it worked!"
    end

    attr_reader :msg

    def test_default_constructor
      assert_nothing_raised(ArgumentError){ CabinetInterface.new }
    end

    def test_default_constructor_with_cabinet
      CabinetInterface.expects(:new).with(@cabinet)
      @interface = UserInterface.new(@cabinet)
    end

    def test_default_constructor_with_cabinet_nil
      CabinetInterface.expects(:new).with(nil)
      @interface = UserInterface.new
    end

    def test_default_constructor_navigator_with_cabinet_nil
      @interface = UserInterface.new.extend(UserInterfaceTestExtention)
      assert @interface.navigator.is_a?(CabinetInterface)
    end

    def test_default_constructor_navigator
      @interface = UserInterface.new(@cabinet).extend(UserInterfaceTestExtention)
      assert @interface.navigator.is_a?(CabinetInterface)
    end

    def test_report_with_hash_res
      @interface.expects(:print).with(msg)
      @interface.report({info: msg})
    end

    def test_report_with_not_hash_res
      assert_raise(RuntimeError){ @interface.report(:bogus) }
    end

    def test_report_with_hash_res_info
      @interface.stubs(:print).with(msg)
      @interface.report({info: msg})
    end

    def test_report_with_hash_res_error
      @interface.stubs(:print).with(msg)
      @interface.report({error: msg})
    end

    def test_report_with_hash_res_invalid_key
      @interface.stubs(:print).with(msg)
      
      assert_raise(RuntimeError){ @interface.report({bogus: msg}) }
    end

    def test_route_with_not_hash_res
      assert_raise(RuntimeError){ @interface.route(:bogus) }
    end

    def test_route_with_hash_res_error
      @interface.stubs(:print).with(msg)
      @interface.expects(:route_drawer_interface).never
      @interface.expects(:route_cabinet_interface).never
      @interface.route({error: msg})
    end

    def test_route_with_hash_res_and_navigator_drawer_interface_error
      @interface.stubs(:print).with(msg)
      @interface.expects(:route_drawer_interface).never
      @interface.expects(:route_cabinet_interface).never
      @interface.route({error: msg})
    end

    def test_route_with_hash_res_and_navigator_drawer_interface_check_interface_type
      @interface = UserInterface.new(@cabinet).extend(UserInterfaceTestExtention)
      #@interface.navigator = DrawerInterface.new
      @interface.navigator.expects(:is_a?).with(DrawerInterface).returns(true)
      @interface.route({drawer: msg})
    end

    def test_route_with_hash_res_and_navigator_drawer_interface
      @interface = UserInterface.new(@cabinet).extend(UserInterfaceTestExtention)
      #@interface.navigator = DrawerInterface.new
      @interface.navigator.stubs(:is_a?).with(DrawerInterface).returns(true)
      @interface.expects(:route_drawer_interface)
      @interface.expects(:route_cabinet_interface).never
      @interface.route({drawer: msg})
    end

    def test_route_with_hash_res_and_navigator_cabinet_interface
      @interface = UserInterface.new(@cabinet).extend(UserInterfaceTestExtention)
      #@interface.navigator = DrawerInterface.new
      @interface.navigator.stubs(:is_a?).with(DrawerInterface).returns(false)
      @interface.expects(:route_drawer_interface).never
      @interface.expects(:route_cabinet_interface)
      @interface.route({drawer: msg})
    end

    def test_route_drawer_interface
      @interface = UserInterface.new(@cabinet).extend(UserInterfaceTestExtention)
      @interface.route_drawer_interface({cabinet: msg})
      assert @interface.navigator.is_a?(CabinetInterface)
    end

    def test_route_drawer_interface_not_cabinet
      @interface = UserInterface.new(@cabinet).extend(UserInterfaceTestExtention)
      @interface.navigator = nil
      @interface.route_drawer_interface({bogus: msg})
      assert @interface.navigator.nil?
    end

    def test_route_cabinet_interface
      @interface = UserInterface.new(@cabinet).extend(UserInterfaceTestExtention)
      @interface.route_cabinet_interface({drawer: 1})
      assert @interface.navigator.is_a?(DrawerInterface)
    end

    def test_route_cabinet_interface_exception
      assert_raise(RuntimeError){ @interface.route_cabinet_interface(:bogus) }
    end

    def test_route_cabinet_interface_check_second_drawer
      @cabinet = Cabinet.new(3)
      @second_drawer = Drawer.new(Drawer::OPEN, ["red socks"])
      @cabinet.drawers[1] = @second_drawer 
      @interface = UserInterface.new(@cabinet).extend(UserInterfaceTestExtention)
      @interface.route_cabinet_interface({drawer: 2})
      assert_equal @second_drawer.contents, @interface.navigator.drawer.contents
    end
end
