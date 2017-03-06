class RouteExtension
  attr_reader :atomic_routes, :atomic_route

  # atomic_routes is expected to be an array of AtomicRoute, atomic_route is expected to be a single AtomicRoute
  def initialize(atomic_routes, atomic_route)
    @atomic_routes = atomic_routes
    @atomic_route = atomic_route
  end

  def route_candidate
    RouteCandidate.new @atomic_routes + [@atomic_route] if @atomic_route != nil
  end

  def services_town(town)
    @atomic_routes.find { | atomic_route | atomic_route.from == town or atomic_route.to == town } != nil
  end

  def retraces_existing_atomic_route
    atomic_routes.select { | atomic_route | atomic_route == @atomic_route } != []
  end

end
