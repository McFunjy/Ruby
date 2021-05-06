# frozen_string_literal: true

require_relative 'company'

class CargoWagon
  include Company
  # Клиентский код может читать тип вагона
  attr_reader :type, :total_volume, :number

  # Создание объекта входит в интерфейс
  def initialize(total_volume)
    @total_volume = total_volume
    @volume = 0
    @number = rand(100)
    @type = 'cargo'
  end

  def load(volume)
    @volume += volume
  end

  def occupied
    @volume
  end

  def available
    @total_volume - @volume
  end

  private

  attr_accessor :volume
end
