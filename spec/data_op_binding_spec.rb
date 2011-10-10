require_relative "../lib/midas"



class MockModel
  include Midas::DataOpBinding
end

describe Midas::DataOpBinding do

  describe Midas::DataOpBinding::ThinProxy do
    include Midas::DataOpBinding

    it "should pass the value tranparently" do
      a = ThinProxy.new(:a)
      a.should == :a
      a.inspect.should == :a.inspect
    end

    it "should be able to replace the value" do
      b = ThinProxy.new(:a)
      b.should == :a
      b.replace_self(:b)
      b.should == :b
    end 

    it "is able to define methods on the object" do
      method_name = :double
      block = lambda{ (self.to_s + self.to_s).to_sym }
      a = ThinProxy.new(:a)
      #version 1 block as callable parameter
      a.define_method(method_name, block)
      a.double.should == :aa
      #version 2 block as block
      b = ThinProxy.new(:b)
      b.define_method(method_name){ (self.to_s + self.to_s).to_sym }
      b.double.should == :bb
    end
  end

  describe "binding methods", Midas::DataOpBinding do
    before :each do
      op_defs = {
        :my_str => {:double => lambda{self + self} },
        :my_sym => {:double => lambda{(self.to_s + self.to_s).to_sym} }
      }

      MockModel.midas_defs = op_defs
      @model = MockModel.new
    end

    it "binds methods" do
      bound_str_val = @model.bind_methods(:my_str, "My Str")
      bound_str_val.double.should == "My StrMy Str"
      bound_sym_val = @model.bind_methods(:my_sym, "my_sym_val")
      bound_sym_val.double.should == :my_sym_valmy_sym_val
      
    end
  end
end
