require_relative 'route_extension'
require_relative 'route_extensions'
require_relative 'route_candidate'
require_relative 'leg'

class RoutePermutations
  attr_reader :network_topology

  # network_topology is expected to be an array of Leg
  def initialize(network_topology)
    @network_topology = network_topology
  end

  def distance(desired_route)
    found_route = non_retracing_permutations_from(desired_route.legs[0].from) \
        .select{ | route | route == desired_route }.first
    
    return found_route == nil  ? 'NO SUCH ROUTE' : found_route.distance
  end

  def shortest_distance(from, to)
    shortest_route = shortest_route_candidate(route_candidates_ending_at_to(non_retracing_permutations_from(from), to))
    return shortest_route == nil  ? 'NO SUCH ROUTE' : shortest_route.distance
  end

  def all_permutations_capped_at_distance_from(from, max_distance)
    route_candidates = initial_route_candidates_starting_at_from(from)

    begin
      new_route_candidates = RouteExtensions.new(@network_topology, route_candidates)
                       .all_possible_single_leg_extensions
                       .that_arent_duplicates
                       .capped_by_distance(max_distance)
                       .route_candidates

      route_candidates += new_route_candidates
    end while new_route_candidates.count > 0

    return route_candidates
  end

  def all_permutations_capped_at_leg_count_from(from, max_legs)
    route_candidates = initial_route_candidates_starting_at_from(from)

    begin
      new_route_candidates = RouteExtensions.new(@network_topology, route_candidates)
                                 .all_possible_single_leg_extensions
                                 .that_arent_duplicates
                                 .capped_by_leg_count(max_legs)
                                 .route_candidates

      route_candidates += new_route_candidates
    end while new_route_candidates.count > 0

    return route_candidates
  end

  def non_retracing_permutations_from(from)
    route_candidates = initial_route_candidates_starting_at_from(from)

    begin
      new_route_candidates = RouteExtensions.new(@network_topology, route_candidates)
                                 .all_possible_single_leg_extensions
                                 .that_arent_duplicates
                                 .that_dont_retrace
                                 .route_candidates

      route_candidates += new_route_candidates
    end while new_route_candidates.count > 0

    return route_candidates
  end

  private
  def initial_route_candidates_starting_at_from(from)
    @network_topology.select { | leg | leg.from == from }.collect { | leg | RouteCandidate.new [leg] }
  end

  def route_candidates_ending_at_to(route_candidates, to)
    route_candidates.select { | route_candidate | route_candidate.ending_point == to }
  end

  def shortest_route_candidate(route_candidates)
    route_candidates.min { | a, b | a.distance <=> b.distance }
  end

end
