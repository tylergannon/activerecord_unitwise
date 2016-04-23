module ActiverecordUnitwise
  module Glue
    def self.included(base)
      base.extend ClassMethods
      base.send :include, Validators
    end
  end
end
