class RouteExtension
  attr_reader :legs, :leg

  # legs is expected to be an array of Leg, leg is expected to be a single Leg
  def initialize(legs, leg)
    @legs = legs
    @leg = leg
  end

  def route_candidate
    RouteCandidate.new @legs + [@leg] if @leg != nil
  end

  def services_town(town)
    @legs.find { | leg | leg.from == town or leg.to == town } != nil
  end

  def retraces_existing_leg
    legs.select { | leg | leg == @leg } != []
  end

end
