require_relative 'instance_counter'

class Station
  include InstanceCounter
  # Клиентский код может просматривать список поездов на станции и названия станций
  attr_reader :name, :trains

  def self.all
    @@all ||= []
  end

  # Клиентский код может создавать станции
  def initialize(name)
    @name = name
    @trains = []
    self.class.all << self
    register_instance
  end

  # Клиентский код может просматривать список грузовых поездов
  def cargo_trains
    @trains.select { |train| train.type.include? 'cargo' }
  end

  # Клиентский код может просматривать список пассажирских поездов
  def passenger_trains
    @trains.select { |train| train.type.include? 'passenger' }
  end

  # Метод используется другим классом
  def add_train(train)
    @trains << train
  end

  # Метод используется другим классом
  def send_train(train)
    @trains.delete(train)
  end

  private

  # Клиентский код не должен сам добавлять или удалять поезда из списка
  attr_writer :trains
end
