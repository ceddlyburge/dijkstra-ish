require_relative 'route_extension'

class RouteExtensions
  # network_topology is expected to be a NetworkTopology, route_candidates is expected to be an array of RouteCandidate and extensions is expected to be an array of RouteExtension
  def initialize(network_topology, route_candidates, extensions = [])
    @network_topology = network_topology
    @route_candidates = route_candidates
    @extensions = extensions
  end

  def route_candidates
    @extensions.map{ | extension | extension.route_candidate}
  end

  def all_possible_single_leg_extensions
    copy_self_with_new_extensions all_possible_leg_extensions
  end

  def capped_by_distance(max_distance)
    copy_self_with_new_extensions @extensions.select{ | route_extension | route_extension.route_candidate.distance < max_distance }
  end

  def capped_by_leg_count(max_legs)
    copy_self_with_new_extensions @extensions.select{ | route_extension | route_extension.original_legs.count <= max_legs }
  end

  def that_dont_retrace
    copy_self_with_new_extensions @extensions.select{ | route_extension | route_extension.retraces_existing_leg == false }
  end

  def that_arent_duplicates
    copy_self_with_new_extensions @extensions.select { | route_extension | @route_candidates.find { | route_candidate | route_candidate == route_extension.route_candidate } == nil }
  end

  private
  def copy_self_with_new_extensions(extensions)
    RouteExtensions.new @network_topology, @route_candidates, extensions
  end

  # I find this method difficult to understand.
  # For each route_candidate passed in, it finds all the possible leg extensions, and returns these as RouteExtension's. It needs to return all the possible extensions in order for other parts of the code to work.
  def all_possible_leg_extensions
    @route_candidates \
      .collect{ | route_candidate | \
        legs_that_extend_route_candidate(route_candidate)
      .map { | leg | RouteExtension.new route_candidate.legs, leg} \
      } \
      .flatten.select { | route_extension | route_extension.extension_leg != nil }
  end

  def legs_that_extend_route_candidate(route_candidate)
    @network_topology.select { | leg | leg.from == route_candidate.ending_point }
  end

end