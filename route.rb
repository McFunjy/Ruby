# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'

class Route
  include InstanceCounter
  include Validation
  # Клиентский код может читать список станций и первую и последнюю станции
  attr_reader :first_stat, :last_stat, :stations

  validate :first_stat, :type, Station
  validate :last_stat, :type, Station

  # Создание объекта входит в интерфейс
  def initialize(first_stat, last_stat)
    @first_stat = first_stat
    @last_stat = last_stat
    @stations = []
    register_instance
    validate!
  end

  # Добавление станции входит в интерфейс
  def add_station(station)
    @stations.insert(-1, station)
  end

  # Удаление входит в интерфейс
  def del_station(station)
    @stations.delete(station)
  end

  private

  # У клиентского кода не должно быть возможности изменять список станций внутренним методом
  attr_writer :stations
end
