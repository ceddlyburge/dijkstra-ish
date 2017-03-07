class RouteExtension
  attr_reader :original_legs, :leg

  # legs is expected to be an array of Leg, leg is expected to be a single Leg
  def initialize(original_legs, leg)
    @original_legs = original_legs
    @leg = leg
  end

  def route_candidate
    RouteCandidate.new @original_legs + [@leg] if @leg != nil
  end

  def retraces_existing_leg
    @original_legs.select { | leg | leg == @leg } != []
  end

end
