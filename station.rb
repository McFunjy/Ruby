# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation
  # Клиентский код может просматривать список поездов на станции и названия станций
  attr_reader :name, :trains

  validate :name, :type, String
  validate :name, :presence

  def self.all
    @@all ||= []
  end

  # Клиентский код может создавать станции
  def initialize(name)
    @name = name
    @trains = []
    self.class.all << self
    register_instance
    validate!
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
    validate!
  end

  # Метод используется другим классом
  def send_train(train)
    @trains.delete(train)
  end

  def each_train(&block)
    @trains.each { |train| block.call(train) }
  end

  private

  # Клиентский код не должен сам добавлять или удалять поезда из списка
  attr_writer :trains
end
