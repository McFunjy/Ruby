# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*args)
      args.each do |arg|
        var_arg = "@#{arg}".to_sym
        var_arg_history = "@#{arg}_history".to_sym
        define_method(arg) { instance_variable_get(var_arg) }
        define_method("#{arg}_history".to_sym) { instance_variable_get(var_arg_history) }
        define_method("#{arg}=".to_sym) do |value|
          instance_variable_set(var_arg, value)
          arg_history = instance_variable_get(var_arg_history) || []
          instance_variable_set(var_arg_history, arg_history << value)
        end
      end
    end

    def strong_attr_accessor(arg, arg_class)
      var_arg = "@#{arg}".to_sym
      define_method(arg) { instance_variable_get(var_arg) }
      define_method("#{arg}=".to_sym) do |value|
        raise TypeError, "Переменная должна быть класса #{arg_class}" unless value.is_a?(arg_class)

        instance_variable_set(var_arg, value)
      end
    end
  end
end
