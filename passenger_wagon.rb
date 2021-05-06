# frozen_string_literal: true

require_relative 'company'

class PassengerWagon
  include Company
  # Клиентский код может читать тип вагона
  attr_reader :type, :total_seats, :number

  # Создание объекта входит в интерфейс
  def initialize(total_seats)
    @total_seats = total_seats
    @occupied_seats = 0
    @number = rand(100)
    @type = 'passenger'
  end

  def take_seat
    @occupied_seats += 1
  end

  def occupied
    @occupied_seats
  end

  def free_seats
    @total_seats - @occupied_seats
  end

  private

  attr_accessor :occupied_seats
end
