class Station

  # Клиентский код может просматривать список поездов на станции и названия станций
  attr_reader :name, :trains

  # Клиентский код может создавать станции
  def initialize(name)
    @name = name
    @trains = []
  end

  # Клиентский код может просматривать список грузовых поездов
  def cargo_trains
    @trains.select { |train| train.type.include? 'cargo' }
  end
  
  # Клиентский код может просматривать список пассажирских поездов
  def passenger_trains
    @trains.select { |train| train.type.include? 'passenger' }
  end

  private

  # Клиентский код не должен сам добавлять или удалять поезда из списка
  attr_writer :trains

  # Метод является внутренним и не входит в интерфейс
  def add_train(train)
    @trains << train
  end

  # Метод является внутренним и не входит в интерфейс
  def send_train(train)
    @trains.delete(train)
  end
end
