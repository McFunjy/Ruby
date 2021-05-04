require_relative 'company'

class CargoWagon
  include Company
  # Клиентский код может читать тип вагона
  attr_reader :type

  # Создание объекта входит в интерфейс
  def initialize
    @type = 'cargo'
  end
end
