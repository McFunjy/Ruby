class Station
  attr_accessor :trains
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def freight_trains
    @trains.select { |train| train.type.include? 'freight' }
  end

  def passenger_trains
    @trains.select { |train| train.type.include? 'passenger' }
  end

  def send_train(train)
    @trains.delete(train)
  end
end

class Route
  attr_accessor :stations
  attr_reader :first_stat, :last_stat

  def initialize(first_stat, last_stat)
    @first_stat = first_stat
    @last_stat = last_stat
    @stations = []
  end

  def add_station(station)
    @stations.insert(-1, station)
  end

  def del_station(station)
    @stations.delete(station)
  end
end

class Train
  attr_accessor :speed
  attr_reader :number, :num_van, :type

  def initialize(number, type, num_van)
    @number = number
    @type = type
    @num_van = num_van
  end

  def stop
    @speed = 0
  end

  def add_van
    @num_van += 1 if @speed.zero?
  end

  def del_van
    @num_van -= 1 if @speed.zero?
  end

  def add_route(route)
    @route = route
    @route.first_stat.add_train(self)
  end

  def current_stat
    return @route.first_stat if @route.first_stat.trains.include? self

    return @route.last_stat if @route.last_stat.trains.include? self

    @route.stations.find { |station| station.trains.include? self }
  end

  def forward
    return unless destination = next_stat

    current_stat.trains.delete(self)
    destination.trains << self
  end

  def backward
    return unless destination = prev_stat

    current_stat.trains.delete(self)
    destination.trains << self
  end

  def prev_stat
    return if current_stat == @route.first_stat

    return @route.first_stat if current_stat == @route.stations.first

    return @route.stations.last if current_stat == @route.last_stat

    @route.stations[@route.stations.index(current_stat) - 1]
  end

  def next_stat
    return if current_stat == @route.last_stat

    return @route.last_stat if current_stat == @route.stations.last

    return @route.stations.first if current_stat == @route.first_stat

    @route.stations[@route.stations.index(current_stat) + 1]
  end
end
