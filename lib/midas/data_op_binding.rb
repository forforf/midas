module Midas::DataOpBinding
	
  #Provides a very thin wrapper around the data elements using the
  #ThinProxy class. Any method not defined in this class is passed
  #on to the actual data.
  class ThinProxy < BasicObject
    attr_accessor :obj
    def initialize(obj)
      @obj = obj
    end

    def ==(other)
      @obj == other
    end

    def eql?(other)
      @obj.eql? other
    end
    #Allows us to add custom methods to the underlying class
    #We do it this way rather than open up the object itself
    #because some objects (e.g., Symbol objects) don't have the
    #hooks to add new behaviors.
    def define_method(method_name, callable=nil, &block)
      block ||= callable
      metaclass = class << self; self; end
      metaclass.send(:define_method, method_name, block)
    end

    #Another reason for this proxy class is to allow us to replace
    #the underlying object with a new version.
    def replace_self(new_obj)
      @obj = new_obj
    end

    #All other methods go to the actual underlying object
    def method_missing(method, *args, &block)
      obj.send(method, *args, &block)
    end
  end

  ##  module methods
  #This method will bind the keyed data to any operations
  #assigned to that data key. For example:
  #a key is :my_key, assigned to val "my_val" with a data
  #operations definition of
  # :my_key => {:add_reverse => lambda{|x| self + x.reverse} }
  # 
  #  bind_methods(:my_key, "my_val")
  #  creates:  :my_key#add_reverse as a method
  #  running:  :my_key.add_reverse
  #  #=> "my_vallav_ym"
  #
  #  The methods to be bound must be assinged to the @midas_defs instance 
  #  variable of the object (i.e. model).
 

  #This method will assign a class instance variable :midas_defs
  #to the class (or module) including this module.
  def self.included(mod)
    class << mod; attr_accessor :midas_defs; end
  end

  def bind_methods(key, val=nil)
    raise ArgumentError, "Definitions not found, have they been set" unless self.class.midas_defs
    bind_hsh = {}
    proxy_val = ThinProxy.new(val)
    bind_methods = self.class.midas_defs[key]  #form: {method_name => lambda, etc}
    bind_methods.each do |method_name, block|
      proxy_val.define_method(method_name, block)
    end
    #bind_hsh[key] = proxy_val
    #bind_hsh
    proxy_val
  end
end
