# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validate'

class Route
  include InstanceCounter
  include Validate
  # Клиентский код может читать список станций и первую и последнюю станции
  attr_reader :first_stat, :last_stat, :stations

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

  def validate!
    raise 'Маршрут должен иметь начальную и конечную станции' if @first_stat.nil? || @last_stat.nil?
    raise 'Маршрут должен состоять из станций' unless (@first_stat.is_a? Station) || (@last_stat.is_a? Station)

    @stations.each { |station| raise 'Маршрут должен состоять из станций' unless station.if_a? Station }
  end

  # У клиентского кода не должно быть возможности изменять список станций внутренним методом
  attr_writer :stations
end
