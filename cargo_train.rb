class CargoTrain < Train
  def initialize(number)
    super
    @type = 'cargo'
  end

  def add_wagon(wagon)
    return unless wagon.type == 'cargo'
      super
    end
end
