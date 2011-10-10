require_relative "midas/version"
require_relative "midas/data_op_binding"

module Midas::Factory
  def self.make(data_ops_def, baseClass=Object)
    baseClass.__send__(:include, Midas::DataOpBinding)
    midasClass = Class.new(baseClass)
    midasClass.midas_defs = data_ops_def
    midasClass
  end 

end

