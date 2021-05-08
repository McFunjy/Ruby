# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validate'

class Station
  include InstanceCounter
  include Validate
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

  def validate!
    raise 'У станции должно быть название' if @name.nil?
    raise 'Название станции должно быть строкой' unless @name.is_a? String
    raise 'Название должно содеражать не менее 3-х символов' if @name.length < 3

    @trains.each { |train| raise 'На станции могут быть только поезда' unless train.is_a? Train }
  end

  # Клиентский код не должен сам добавлять или удалять поезда из списка
  attr_writer :trains
end
