class RouteCandidate
 attr_reader :legs

  # legs is expected to be an array of Leg
  def initialize(legs)
    @legs = legs
  end

  def distance
    @legs.map{ | leg | leg.distance }.inject(:+)
  end

 def duration
   duration_in_transit + duration_stopped_at_station
 end

 def duration_in_transit
   @legs.map{ | leg | leg.distance }.inject(:+)
 end

 def duration_stopped_at_station
   ((@legs.count() -1) * 2)
 end

 def starting_point
   @legs.first.from
 end

 def ending_point
   @legs.last.to
  end

  def to_s
    %Q[\nRoutes\nDistance #{distance.to_s}\n#{@legs.join("\n")}\nend\n]
  end

  def ==(other_route_candidate)
    other_route_candidate != nil && @legs.size == other_route_candidate.legs.size && @legs.lazy.zip(other_route_candidate.legs).all? { |x, y| x.from == y.from && x.to == y.to }
  end
end
