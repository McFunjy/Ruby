require-relative 'train'
require-relative 'station'
require-relative 'route'

while n != 0
  puts 'Введите 1, если хотите создать станцию, поезд, вагон или маршрут'
  puts 'Введите 2, если хотите произвести операции с созданными объектами'
  puts 'Введите 3, если хотите вывести текущие данные об объектах'
  puts 'Введите 0, если хотите закончить программу'
  n = gets.chomp.to_i
  if n == 1
    puts 'Введите 1, если хотите создать маршрут'
    puts 'Введите 2, если хотите создать станцию'
    puts 'Введите 3, если хотите создать поезд'
    puts 'Введите 4, если хотите создать вагон'
    n = gets.chomp.to_i
    if n == 1
      puts 'Введите первую станцию маршрута'
      name1 = gets.chomp
      s1 = Station.new(name1)
      puts 'Введите последнюю станцию маршрута'
      name2 = gets.chomp
      s2 = Station.new(name2)
      r = Route.new(s1, s2)
    elsif n == 2
      puts 'Введите название станции'
      name1 = gets.chomp
      s1 = Station.new(name1)
    elsif n == 3
      puts 'Введите 1, если хотите создать грузовой поезд'
      puts 'Введите 2, если хотите создать пассажирский поезд'
      n = gets.chomp.to_i
      if n == 1
        puts 'Введите номер поезда'
        number = gets.chomp.to_i
        t = CargoTrain.new(number)
      else
        puts 'Введите номер поезда'
        number = gets.chomp.to_i
        t = PassengerTrain.new(number)
      end
    else
      puts 'Введите 1, если хотите создать грузовой вагон'
      puts 'Введите 2, если хотите создать пассажирский вагон'
      n = gets.chomp.to_i
      if n == 1
        w = CargoWagon.new()
      else
        w = PassengerWagon.new()
      end
    end
  elsif n == 2
    puts 'Введите 1, если хотите добавить станцию в маршрут'
    puts 'Введите 2, если хотите удалить станцию из маршрута'
    puts 'Введите 3, если хотите назначить маршрут поезду'
    puts 'Введите 4, если хотите добавить вагон к поезду'
    puts 'Введите 5, если хотите отцепить вагон от поезда'
    puts 'Введите 6, если хотите переместить поезд'
    n = gets.chomp.to_i
    if n == 1
      r.add_station(s1)
    elsif n == 2
      r.del_station(s1)
    elsif n == 3
      t.add_route(r)
    elsif n == 4
      t.add_wagon(w)
    elsif n == 5
      t.del_wagon(w)
    elsif n == 6
      puts 'Введите 1, если хотите переместить поезд вперед'
      puts 'Введите 2, если хотите переместить поезд назад'
      n = gets.chomp.to_i
      if n == 1
        t.forward
      else
        t.backward
      end
    end
  elsif n == 3
    puts 'Введите 1, если хотите просмотреть список станций маршрута'
    puts 'Введите 2, если хотите просмотреть список поездов на станции'
    n = gets.chomp.to_i
    if n == 1
      puts r.first_stat
      puts r.stations
      puts r.last_stat
    else
      puts s1.stations
    end
  end
end