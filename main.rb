require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'route'
require_relative 'station'
require_relative 'train'

class RailRoad
  def menu
    n = nil
    while n != 0
      puts 'Введите 1, если хотите создать станцию, поезд, вагон или маршрут'
      puts 'Введите 2, если хотите произвести операции с созданными объектами'
      puts 'Введите 3, если хотите вывести текущие данные об объектах'
      puts 'Введите 0, если хотите закончить программу'
      n = gets.chomp.to_i
      case n
      when 1
        puts 'Введите 1, если хотите создать маршрут'
        puts 'Введите 2, если хотите создать станцию'
        puts 'Введите 3, если хотите создать поезд'
        puts 'Введите 4, если хотите создать вагон'
        n = gets.chomp.to_i
        case n
        when 1
          puts 'Введите первую станцию маршрута'
          name1 = gets.chomp
          s1 = Station.new(name1)
          puts 'Введите последнюю станцию маршрута'
          name2 = gets.chomp
          s2 = Station.new(name2)
          r = Route.new(s1, s2)
        when 2
          puts 'Введите название станции'
          name1 = gets.chomp
          s1 = Station.new(name1)
        when 3
          puts 'Введите 1, если хотите создать грузовой поезд'
          puts 'Введите 2, если хотите создать пассажирский поезд'
          n = gets.chomp.to_i
          puts 'Введите номер поезда'
          number = gets.chomp.to_i
          if n == 1
            t = CargoTrain.new(number)
          else
            t = PassengerTrain.new(number)
          end
        else
          puts 'Введите 1, если хотите создать грузовой вагон'
          puts 'Введите 2, если хотите создать пассажирский вагон'
          n = gets.chomp.to_i
          if n == 1
            w = CargoWagon.new
          else
            w = PassengerWagon.new
          end
        end
      when 2
        puts 'Введите 1, если хотите добавить станцию в маршрут'
        puts 'Введите 2, если хотите удалить станцию из маршрута'
        puts 'Введите 3, если хотите назначить маршрут поезду'
        puts 'Введите 4, если хотите добавить вагон к поезду'
        puts 'Введите 5, если хотите отцепить вагон от поезда'
        puts 'Введите 6, если хотите переместить поезд'
        n = gets.chomp.to_i
        case n
        when 1
          r.add_station(s1)
        when 2
          r.del_station(s1)
        when 3
          t.add_route(r)
        when 4
          t.add_wagon(w)
        when 5
          t.del_wagon(w)
        when 6
          puts 'Введите 1, если хотите переместить поезд вперед'
          puts 'Введите 2, если хотите переместить поезд назад'
          n = gets.chomp.to_i
          if n == 1
            t.forward
          else
            t.backward
          end
        end
      when 3
        puts 'Введите 1, если хотите просмотреть список станций маршрута'
        puts 'Введите 2, если хотите просмотреть список поездов на станции'
        n = gets.chomp.to_i
        if n == 1
          puts r.first_stat.name
          r.stations.each { |station| puts station.name }
          puts r.last_stat.name
        else
          s1.trains.each { |train| puts train.number }
        end
      end
    end
  end
end
