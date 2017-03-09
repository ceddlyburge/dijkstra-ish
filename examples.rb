require_relative 'network_topology_parser.rb'
require_relative 'route_permutations'

class Examples

    def examples
        distance_a_b_c
        distance_a_d
        distance_a_d_c
        distance_a_e_b_c_d
        distance_a_e_d
        trips_c_c_maximum_3_stops
        trips_a_c_exactly_4_stops
        shortest_distance_a_c
        shortest_distance_b_b
        trips_c_c_distance_under_30
    end

    def distance_a_b_c
        puts %Q[Distance of route A-B-C: #{
            @route_permutations.distance(
                desired_leg(
                    [leg('A', 'B'),
                     leg('B', 'C')]))
            }]
    end

    def distance_a_d
        puts %Q[Distance of route A-D: #{
            @route_permutations.distance(
                desired_leg([leg('A', 'D')]))
            }]
    end

    def distance_a_d_c
        puts %Q[Distance of route A-D-C: #{
            @route_permutations.distance(
                desired_leg(
                    [leg('A', 'D'),
                     leg('D', 'C')]))
            }]
    end

    def distance_a_e_b_c_d
        puts %Q[Distance of route A-E-B-C-D: #{
            @route_permutations.distance(
                desired_leg(
                    [leg('A', 'E'),
                     leg('E', 'B'),
                     leg('B', 'C'),
                     leg('C', 'D')]))
            }]
    end
    
    def distance_a_e_d
        puts %Q[Distance of route A-E-D: #{
            @route_permutations.distance(
                desired_leg([leg('A', 'E'), leg('E', 'D')]))
            }]
    end

    def trips_c_c_maximum_3_stops
        puts %Q[Number of trips starting at C and ending at C with a maximum of 3 stops: #{
            @route_permutations
            .non_retracing_permutations_from('C')
            .select{ | route_candidate | route_candidate.legs.last.to == 'C' && route_candidate.legs.count <= 3}
            .count
        }]
    end

    def trips_a_c_exactly_4_stops
        puts %Q[Number of trips starting at A and ending at C with exactly 4 stops: #{
            @route_permutations
            .all_permutations_capped_at_leg_count_from('A', 4)
            .select{ | route_candidate | route_candidate.legs.last.to == 'C' && route_candidate.legs.count == 4}
            .count
        }]
    end

    def shortest_distance_a_c
        puts %Q[Shortest distance A-C: #{@route_permutations.shortest_distance('A', 'C')}]
    end

    def shortest_distance_b_b
        puts %Q[Shortest distance B-B: #{@route_permutations.shortest_distance('B', 'B')}]
    end

    def trips_c_c_distance_under_30
        puts %Q[Number of trips starting at C and ending at C with distance < 30: #{
            @route_permutations
            .all_permutations_capped_at_distance_from('C', 30)
            .select{ | route_candidate | route_candidate.legs.last.to == 'C'}
            .count
        }]
    end

    def initialize
        @network_topology = NetworkTopologyParser.new File.readlines('network_topology.txt')
        puts @network_topology.legs
        @route_permutations = RoutePermutations.new @network_topology.legs
    end

    def leg(from, to)
      return Leg.new from, to, 0
    end

    def desired_leg(legs)
        RouteCandidate.new legs
    end

end

Examples.new.examples