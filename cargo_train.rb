require_relative 'train'

class CargoTrain < Train
  # Клиентский код может читать тип вагона
  attr_reader :type

  # Создание объекта входит в интерфейс
  def initialize(number)
    super
    @type = 'cargo'
  end
end
