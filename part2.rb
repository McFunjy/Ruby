class Station
  attr_accessor :trains
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    self.trains << train  
  end

  def freight_trains
    self.trains.select {|train| train.type.include? "freight"}
  end

  def passenger_trains
    self.trains.select {|train| train.type.include? "passenger"}
  end

  def send_train(train)
    self.trains.delete(train)
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

  def get_stations
    puts @first_stat
    puts @stations
    puts @last_stat
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
    self.speed = 0
  end

  def add_van
    if self.speed == 0
      @num_van += 1
    end
  end

  def del_van
    if self.speed == 0
      @num_van -= 1
    end
  end

  def set_route(route)
    @route = route
    @route.first_stat.add_train(self)
  end

  def forward
    curr_stat = @route.stations.find {|station| station.trains.include? self}
    curr_stat.trains.delete(self)
    num_stat = @route.stations.index(curr_stat)
    @route.stations[num_stat+1].trains << self
  end

  def backward
    curr_stat = @route.stations.find {|station| station.trains.include? self}
    curr_stat.trains.delete(self)
    num_stat = @route.stations.index(curr_stat)
    @route.stations[num_stat-1].trains << self
  end

  def current_stat
    curr_stat = @route.stations.find {|station| station.trains.include? self}
    num_stat = @route.stations.index(curr_stat)
    return @route.stations[num_stat-1], @route.stations[num_stat], @route.stations[num_stat+1]
  end

end
