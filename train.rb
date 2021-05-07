# frozen_string_literal: true

require_relative 'company'
require_relative 'instance_counter'
require_relative 'validate'

class Train
  include Company
  include InstanceCounter
  include Validate
  # Клиентский код может просматривать номер, скорость и список вагонов поезда
  attr_reader :number, :speed, :wagons

  NUMBER_FORMAT = /^[а-я\w\d]{3}-?[а-я\w\d]{2}$/i.freeze

  def self.all
    @@all ||= []
  end

  def self.find(number)
    all.find { |train| return train if train.number == number }
  end

  # Клиентский код может создавать опезда
  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    self.class.all << self
    register_instance
    validate!
  end

  # Клиентский код может останавливать поезд
  def stop
    @speed = 0
  end

  # Метод входит в интерфейс
  def add_wagon(wagon)
    return unless @type == wagon.type

    @wagons << wagon if @speed.zero?
  end

  # Метод входит в интерфейс
  def del_wagon(wagon)
    @wagons.delete(wagon) if @speed.zero?
  end

  # Метод входит в интерфейс
  def add_route(route)
    @route = route
    @route.first_stat.add_train(self)
  end

  # Клиентский код может возвращать текущую станцию
  def current_stat
    return @route.first_stat if @route.first_stat.trains.include? self

    return @route.last_stat if @route.last_stat.trains.include? self

    @route.stations.find { |station| station.trains.include? self }
  end

  # Метод входит в интерфейс
  def forward
    return unless destination = next_stat

    current_stat.send_train(self)
    destination.add_train(self)
  end

  # Метод входит в интерфейс
  def backward
    return unless destination = prev_stat

    current_stat.send_train(self)
    destination.add_train(self)
  end

  # Клиентский код может возвращать предыдущую станцию
  def prev_stat
    return if current_stat == @route.first_stat

    return @route.first_stat if current_stat == @route.stations.first

    return @route.stations.last if current_stat == @route.last_stat

    @route.stations[@route.stations.index(current_stat) - 1]
  end

  # Клиентский код может возвращать следующую станцию
  def next_stat
    return if current_stat == @route.last_stat

    return @route.last_stat if current_stat == @route.stations.last

    return @route.stations.first if current_stat == @route.first_stat

    @route.stations[@route.stations.index(current_stat) + 1]
  end

  def each_wagon(&block)
    @wagons.each { |wagon| block.call(wagon) }
  end

  protected

  def validate!
    raise 'У поезда должен быть номер' if @number.nil?
    raise 'Номер поезда должен быть строкой' unless @number.is_a? String
    raise 'Неверный формат номера' if @number !~ NUMBER_FORMAT
  end

  # Клиентский код не может измеять скорость и список вагонов внутренним методом
  attr_writer :speed, :wagons
end
