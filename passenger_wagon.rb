require_relative 'company'

class PassengerWagon
  include Company
  # Клиентский код может читать тип вагона
  attr_reader :type

  # Создание объекта входит в интерфейс
  def initialize
    @type = 'passenger'
  end
end
