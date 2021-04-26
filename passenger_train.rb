class PassengerTrain < Train
  def initialize(number)
    super
    @type = 'passenger'
  end

  def add_wagon(wagon)
    return unless wagon.type == 'passenger'
      super
    end
end
