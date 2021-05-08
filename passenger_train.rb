# frozen_string_literal: true

require_relative 'train'

class PassengerTrain < Train
  # Клиентский код может читать тип вагона
  attr_reader :type

  # Создание объекта входит в интерфейс
  def initialize(number)
    super
    @type = 'passenger'
  end
end
