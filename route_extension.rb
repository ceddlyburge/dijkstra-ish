class RouteExtension
  attr_reader :original_legs, :extension_leg

  # legs is expected to be an array of Leg, leg is expected to be a single Leg
  def initialize(original_legs, extension_leg)
    @original_legs = original_legs
    @extension_leg = extension_leg
  end

  def route_candidate
    RouteCandidate.new @original_legs + [@extension_leg] if @extension_leg != nil
  end

  def retraces_existing_leg
    @original_legs.select { | leg | leg == @extension_leg } != []
  end

end
