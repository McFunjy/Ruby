# frozen_string_literal: true

require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'route'
require_relative 'station'
require_relative 'train'

class RailRoad
  attr_reader :r, :s, :t

  def initialize
    @r = []
    @s = []
    @t = []
  end

  def menu
    n = nil
    while n != 0
      puts 'Введите 1, если хотите создать станцию, поезд или маршрут'
      puts 'Введите 2, если хотите произвести операции с созданными объектами'
      puts 'Введите 3, если хотите вывести текущие данные об объектах'
      puts 'Введите 0, если хотите закончить программу'
      n = gets.chomp.to_i
      case n
      when 1
        create
      when 2
        operation
      when 3
        data
      end
    end
  end

  def create
    puts 'Введите 1, если хотите создать маршрут'
    puts 'Введите 2, если хотите создать станцию'
    puts 'Введите 3, если хотите создать поезд'
    n = gets.chomp.to_i
    case n
    when 1
      create_route
    when 2
      create_station
    else
      create_train
    end
  end

  def create_route
    puts 'Выберите первую станцию маршрута'
    s1 = choose_station(@s)
    puts 'Выберите последнюю станцию маршрута'
    s2 = choose_station(@s)
    @r << Route.new(@s[s1], @s[s2])
  end

  def create_station
    puts 'Введите название станции'
    name = gets.chomp
    @s << Station.new(name)
  end

  def create_train
    puts 'Введите 1, если хотите создать грузовой поезд'
    puts 'Введите 2, если хотите создать пассажирский поезд'
    n = gets.chomp.to_i
    begin
      puts 'Введите номер поезда'
      number = gets.chomp
      return @t << CargoTrain.new(number) if n == 1

      @t << PassengerTrain.new(number)
    rescue StandardError => e
      puts e.message
      puts 'Попробуйте еще раз'
      retry
      puts 'Поезд успешно создан'
    end
  end

  def create_wagon(type)
    if type == 'cargo'
      puts 'Введите объем вагона'
      volume = gets.chomp.to_i
      CargoWagon.new(volume)
    else
      puts 'Введите кол-во мест в вагоне'
      seats = gets.chomp.to_i
      PassengerWagon.new(seats)
    end
  end

  def operation
    puts 'Введите 1, если хотите добавить станцию в маршрут'
    puts 'Введите 2, если хотите удалить станцию из маршрута'
    puts 'Введите 3, если хотите назначить маршрут поезду'
    puts 'Введите 4, если хотите добавить вагон к поезду'
    puts 'Введите 5, если хотите отцепить вагон от поезда'
    puts 'Введите 6, если хотите переместить поезд'
    puts 'Введите 7, если хотите занять место/объем в вагоне'
    n = gets.chomp.to_i
    case n
    when 1
      r_n = choose_route
      s_n = choose_station(@s)
      @r[r_n].add_station(@s[s_n])
    when 2
      r_n = choose_route
      s_n = choose_station(@r[r_n].stations)
      @r[r_n].del_station(@s[s_n])
    when 3
      t_n = choose_train
      r_n = choose_route
      @t[t_n].add_route(@r[r_n])
    when 4
      t_n = choose_train
      w = create_wagon(@t[t_n].type)
      @t[t_n].add_wagon(w)
    when 5
      t_n = choose_train
      w_n = choose_wagon(@t[t_n])
      @t[t_n].del_wagon(@t[t_n].wagons[w_n])
    when 6
      move
    when 7
      t_n = choose_train
      w_n = choose_wagon(@t[t_n])
      if @t[t_n].type == 'cargo'
        puts 'Введите объем, который нужно занять'
        volume = gets.chomp.to_i
        @t[t_n].wagons[w_n].load(volume)
      else
        @t[t_n].wagons[w_n].take_seat
        puts 'Место успешно занято'
      end
    end
  end

  def move
    t_n = choose_train
    puts 'Введите 1, если хотите переместить поезд вперед'
    puts 'Введите 2, если хотите переместить поезд назад'
    n = gets.chomp.to_i
    return @t[t_n].forward if n == 1

    @t[t_n].backward
  end

  def data
    puts 'Введите 1, если хотите просмотреть список станций маршрута'
    puts 'Введите 2, если хотите просмотреть список поездов на станции'
    puts 'Введите 3, если хотите просмотреть список вагонов поезда'
    n = gets.chomp.to_i
    case n
    when 1
      r_n = choose_route
      puts @r[r_n].first_stat.name
      @r[r_n].stations.each { |station| puts station.name }
      puts @r[r_n].last_stat.name
    when 2
      s_n = choose_station(@s)
      return puts 'На выбранной станции поездов нет' if @s[s_n].trains.empty?

      puts 'Номер поезда   Тип      Кол-во вагонов'
      @s[s_n].each_train { |train| puts "   #{train.number}     #{train.type}         #{train.wagons.count}" }
    else
      t_n = choose_train
      if @t[t_n].type == 'cargo'
        puts 'Номер вагона    Тип     Кол-во свободного/занятого объема'
        @t[t_n].each_waogn do |wagon|
          puts "   #{wagon.number}          #{wagon.type}          #{wagon.available}/#{wagon.occupied}"
        end
      else
        puts 'Номер вагона      Тип       Кол-во свободных/занятых мест'
        @t[t_n].each_waogn do |wagon|
          puts "   #{wagon.number}           #{wagon.type}            #{wagon.free_seats}/#{wagon.occupied}"
        end
      end
    end
  end

  def choose_route
    @r.each_with_index { |route, i| puts "#{i}. #{route.first_stat.name} -> #{route.last_stat.name}" }
    puts 'Введите номер маршрута'
    gets.chomp.to_i
  end

  def choose_station(stations)
    stations.each_with_index { |station, i| puts "#{i}. #{station.name}" }
    puts 'Введите номер станции'
    gets.chomp.to_i
  end

  def choose_train
    @t.each_with_index { |train, i| puts "#{i}. #{train.number}" }
    puts 'Введите номер поезда'
    gets.chomp.to_i
  end

  def choose_wagon(train)
    train.wagons.each_with_index { |wagon, i| puts "#{i}. #{wagon.number}" }
    puts 'Введите номер вагона'
    gets.chomp.to_i
  end

  private

  # Внутренние методы класса
  attr_writer :r, :s, :t
end
