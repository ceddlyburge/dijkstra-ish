require_relative 'test_helper' 
require_relative 'leg'
require_relative 'route_permutations'
require_relative 'network_topology_parser'

class FunctionalDurationTests < Minitest::Test

  def test_duration_a_b_c
    duration = @route_permutations.duration(
        desired_leg(
            [leg('A', 'B'),
             leg('B', 'C')]))

    assert_equal 11, duration
  end

  def test_duration_a_d
    duration = @route_permutations.duration(
        desired_leg([leg('A', 'D')]))

    assert_equal 5, duration
  end

  def test_duration_a_d_c
    duration = @route_permutations.duration(
        desired_leg(
            [leg('A', 'D'),
             leg('D', 'C')]))

    assert_equal 15, duration
  end

  def test_duration_a_e_b_c_d
    duration = @route_permutations.duration(
        desired_leg(
            [leg('A', 'E'),
             leg('E', 'B'),
             leg('B', 'C'),
             leg('C', 'D')]))

    assert_equal 28, duration
  end

  def test_duration_a_e_d
    duration = @route_permutations.duration(
        desired_leg([leg('A', 'E'), leg('E', 'D')]))

    assert_equal 'NO SUCH ROUTE', duration
  end

  def test_trips_c_c_maximum_3_stops
    trips = @route_permutations
              .non_retracing_permutations_from('C')
              .select{ | route_candidate | route_candidate.ending_point == 'C' && route_candidate.legs.count <= 3}
              .count

    assert_equal 2, trips
  end

  # def trips_a_c_exactly_4_stops
  #   trips = @route_permutations
  #               .all_permutations_capped_at_leg_count_from('A', 4)
  #               .select{ | route_candidate | route_candidate.ending_point == 'C' && route_candidate.legs.count == 4}
  #               .count
  #
  #   assert_equal 4, trips
  # end
  #
  # def test_shortest_distance_a_c
  #   distance = @route_permutations.shortest_distance('A', 'C')
  #
  #   assert_equal 9, distance
  # end
  #
  # def test_shortest_distance_b_b
  #   distance = @route_permutations.shortest_distance('B', 'B')
  #
  #   assert_equal 9, distance
  # end

  def test_trips_c_c_duration_under_30
    trips = @route_permutations
                .all_permutations_capped_at_duration_from('C', 35)
                .select{ | route_candidate | route_candidate.ending_point == 'C'}
                .count

    assert_equal 6, trips
  end

  def setup
    @network_topology = NetworkTopologyParser.new.parse %w(AB5 BC4 CD8 DC8 DE6 AD5 CE2 EB3 AE7)
    @route_permutations = RoutePermutations.new @network_topology.legs
  end

  def leg(from, to)
    return Leg.new from, to, 0
  end

  def desired_leg(legs)
    RouteCandidate.new legs
  end

end