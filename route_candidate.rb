class RouteCandidate
 attr_accessor :legs

  # legs is expected to be an array of Leg
  def initialize(legs)
    @legs = legs
  end

  def distance
      @legs.map{ | leg | leg.distance }.inject(:+)
  end

  def to_s
      %Q[\nRoutes\nDistance #{distance.to_s}\n#{@legs.join("\n")}\nend\n]
  end

  def ==(other_route_candidate)
    other_route_candidate != nil && @legs.size == other_route_candidate.legs.size && @legs.lazy.zip(other_route_candidate.legs).all? { |x, y| x.from == y.from && x.to == y.to }
  end
end
