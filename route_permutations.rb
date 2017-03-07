require_relative "route_extension"
require_relative "route_candidate"
require_relative "leg"

class RoutePermutations
  public
  def distance(desired_route, network_topology)
    found_route = RoutePermutations.new \
        .non_retracing_permutations_from(desired_route.legs[0].from, network_topology) \
        .select{ | route | route == desired_route }.first
    
    return found_route == nil  ? "NO SUCH ROUTE" : found_route.distance
  end

  def shortest_distance(from, to, network_topology)
    shortest_route = shortest_route_candidate(route_candidates_ending_at_to(RoutePermutations.new.non_retracing_permutations_from(from, network_topology), to))
    return shortest_route == nil  ? "NO SUCH ROUTE" : shortest_route.distance
  end

  def all_permutations_capped_at_distance_from(from, max_distance, network_topology)
    route_candidates = initial_route_candidates_starting_at_from(from , network_topology)

    begin
      extensions = \
          extensions_capped_by_distance( max_distance, \
              extensions_that_arent_duplicates(route_candidates, \
                all_possible_leg_extensions(route_candidates, network_topology), \
            ) \
        ) \
        .map{ | route_extension | route_extension.route_candidate}

      route_candidates += extensions
    end while extensions.count > 0 
     
    return route_candidates 
  end

  def all_permutations_capped_at_leg_count_from(from, max_legs, network_topology)
    route_candidates = initial_route_candidates_starting_at_from(from , network_topology)

    begin
      extensions = \
          extensions_capped_by_leg_count(max_legs, \
              extensions_that_arent_duplicates(route_candidates, \
                all_possible_leg_extensions(route_candidates, network_topology), \
            ) \
        ) \
        .map{ | route_extension | route_extension.route_candidate}

      route_candidates += extensions
    end while extensions.count > 0 
     
    return route_candidates 
  end

  def non_retracing_permutations_from(from, network_topology)
    route_candidates = initial_route_candidates_starting_at_from(from , network_topology)

    begin
      extensions = \
          extensions_that_dont_retrace( \
              extensions_that_arent_duplicates(route_candidates, \
                all_possible_leg_extensions(route_candidates, network_topology), \
            ) \
        ) \
        .map{ | route_extension | route_extension.route_candidate}

      route_candidates += extensions
    end while extensions.count > 0 
     
    return route_candidates 
  end

  private
  # I find this method difficult to understand. 
  # For each route_candidate passed in, it finds all the possible leg extensions, and returns these as RouteExtension's. It needs to return all the possible extensions in order for other parts of the code to work.
  def all_possible_leg_extensions(route_candidates, network_topology)
      route_candidates \
      .collect{ | route_candidate | \
        legs_that_extend_route_candidate(network_topology, route_candidate)
        .map { | leg | RouteExtension.new route_candidate.legs, leg} \
      } \
      .flatten.select { | route_extension | route_extension.leg != nil }
  end
  
  def legs_that_extend_route_candidate(network_topology, route_candidate)
      network_topology.select { | leg | leg_extends_route_candidate(leg, route_candidate) }
  end

  def extensions_capped_by_distance(max_distance, route_extensions)
      route_extensions.select{ | route_extension | route_extension.route_candidate.distance < max_distance }
  end

  def extensions_capped_by_leg_count(max_legs, route_extensions)
      route_extensions.select{ | route_extension | route_extension.legs.count <= max_legs }
  end

  def extensions_that_dont_retrace(route_extensions)
      route_extensions.select{ | route_extension | route_extension.retraces_existing_leg == false }
  end

  def extensions_that_arent_duplicates(route_candidates, route_extensions)
     route_extensions.select { | route_extension | route_candidates.find { | route_candidate | route_candidate == route_extension.route_candidate } == nil }
  end

  def leg_extends_route_candidate(leg, route_candidate)
    leg.from == route_candidate.ending_point
  end

  def initial_route_candidates_starting_at_from(from, network_topology)
    network_topology.select { | leg | leg.from == from }.collect { | leg | RouteCandidate.new [leg] }
  end

  def route_candidates_ending_at_to(route_candidates, to)
    route_candidates.select { | route_candidate | route_candidate.ending_point == to }
  end

  def shortest_route_candidate(route_candidates)
    route_candidates.min { | a, b | a.distance <=> b.distance }
  end

end
