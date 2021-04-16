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
    f_t = []
    self.trains.each do |train|
      if train.type == "freight"
        f_t << train
      end
    end
    return f_t
  end

  def passenger_trains
    p_t = []
    self.trains.each do |train|
      if train.type == "passenger"
        p_t << train
      end
    end
    return p_t
  end

  def send_train(number)
    self.trains.each do |train|
      if train.number == number
        self.trains.delete(train)
      end
    end
  end

end

class Route
  attr_accessor :stations
  attr_reader :first_stat, :last_stat

  def initialize(first_stat, last_stat)
    @first_stat = first_stat
    @last_stat = last_stat
    @stations = [first_stat, last_stat]
  end

  def add_station(station)
    @stations.pop
    @stations << station
    @stations << @last_stat
  end

  def del_station(station)
    @stations.delete(station)
  end

  def get_stations
    puts @stations
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
    @route.stations[0].add_train(self)
  end

  def forward
    for i in 0..@route.stations.size
      if @route.stations[i].trains.include? self
        @route.stations[i].trains.delete(self)
        @route.stations[i+1].trains << self
        break
      end
    end
  end

  def backward
    for i in 0..@route.stations.size
      if @route.stations[i].trains.include? self
        @route.stations[i].trains.delete(self)
        @route.stations[i-1].trains << self
        break
      end
    end
  end

  def current_stat
    for i in 0..@route.stations.size
      if @route.stations[i].trains.include? self
        puts @route.stations[i-1]
        puts @route.stations[i]
        puts @route.stations[i+1]
        break
      end
    end
  end

end
