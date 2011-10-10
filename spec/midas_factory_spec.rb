require_relative "../lib/midas"

describe Midas::Factory do
  before :each do
    @data_ops = {
      :my_str => {:add => lambda{|x| self + x.to_s}},
      :my_sym => {:add => lambda{|x| (self.to_s + x.to_s).to_sym} }
    }
  end


  it "makes a class ready to use midas functionality" do
    MyMidasClass = Midas::Factory.make(@data_ops)
    my_midas = MyMidasClass.new
    bound_str_val = my_midas.bind_methods(:my_str, "Hello")
    bound_sym_val = my_midas.bind_methods(:my_sym, :Hello)
    bound_str_val.add(" World").should == "Hello World"
    bound_sym_val.add(:World).should == :HelloWorld 
  end
end
