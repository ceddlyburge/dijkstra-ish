class RouteCandidate
 attr_accessor :atomic_routes

  # atomic_routes is expected to be an array of AtomicRoute
  def initialize(atomic_routes)
    @atomic_routes = atomic_routes
  end

  def distance
      @atomic_routes.map{ | atomic_route | atomic_route.distance }.inject(:+) 
  end

  def to_s
      %Q[\nRoutes\nDistance #{distance.to_s}\n#{@atomic_routes.join("\n")}\nend\n]
  end

  def ==(other_route_candidate)
    other_route_candidate != nil && @atomic_routes.size == other_route_candidate.atomic_routes.size && @atomic_routes.lazy.zip(other_route_candidate.atomic_routes).all? { |x, y| x.from == y.from && x.to == y.to }
  end
end
