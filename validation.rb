# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(*params)
      @validations ||= []
      @validations << {
        attribute: params[0],
        type: params[1],
        param: params[2]
      }
    end
  end

  module InstanceMethods
    def validate!
      validations = self.class.instance_variable_get('@validations')
      validations.each do |validation|
        value = instance_variable_get("@#{validation[:attribute]}")
        send(validation[:type], value, validation[:param])
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def presence(value, _param)
      raise "Атрибут #{value} nil или пустая строка" if value.nil? || value.empty?
    end

    def format(value, param)
      raise "Атрибут #{value} не соответствует формату #{param}" unless param.match(value)
    end

    def type(value, param)
      raise "Атрибут #{value} не соответствует классу #{param}" unless value.is_a?(param)
    end
  end
end
