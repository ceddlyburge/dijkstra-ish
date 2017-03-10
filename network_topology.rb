class NetworkTopology
  attr_reader :errors, :legs

  # legs is expected to be an arry of Leg
  def initialize(errors, legs)
    @errors = errors
    @legs = legs
  end
end
