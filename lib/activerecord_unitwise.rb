require 'unitwise'
require "activerecord_unitwise/version"
require "activerecord_unitwise/validators"
require "activerecord_unitwise/glue"

require 'activerecord_unitwise/railtie' if defined?(Rails::Railtie)

module ActiverecordUnitwise
  module ClassMethods
    def unitwise(*attributes, convert_to: nil, default_unit: nil)
      attributes.each do |attribute|
        __define_unitwise_setter attribute,
          convert_to: convert_to,
          default_unit: default_unit
        __define_unitwise_getter attribute
      end
    end

    def __define_unitwise_getter(attribute)
      method = "def #{attribute}
          #{attribute}_scalar && #{attribute}_units ?
            Unitwise(#{attribute}_scalar, #{attribute}_units) : nil
        end
        "
      class_eval method
    end

    def __define_unitwise_setter(attribute, convert_to:, default_unit:)
      method = "def #{attribute}=(value, unit=nil)
        if value.blank?
          self.#{attribute}_scalar = nil
          self.#{attribute}_units  = nil
          return
        end
        unless value.kind_of?(Unitwise::Measurement)
          unless unit || #{default_unit.present?}
            raise 'must provide unit or default unit'
          end
          value = Unitwise(value.to_f, (unit || '#{default_unit}'))
        end
      "
      if convert_to.present?
        method += "
          value = value.convert_to('#{convert_to}')
        "
      end
      method += "
        self.#{attribute}_scalar = value.magnitude
        self.#{attribute}_units  = value.unit.expression
      "
      method += "end"
      class_eval method
    end
  end
end
