require 'minitest/autorun'
require_relative 'leg'
require_relative 'route_permutations'

class RoutePermutationsTests < Minitest::Test
  def test_single_leg
    assert_equal 5, @route_permutations.shortest_distance("A", "B", [route("A", "B", 5)])
    assert_equal 12.5, @route_permutations.shortest_distance("A", "B", [route("A", "B", 12.5)])
    assert_equal -1, @route_permutations.shortest_distance("A", "B", [route("A", "B", -1)])
  end

  def test_missing_single_leg
    assert_equal @no_such_route, @route_permutations.shortest_distance("A", "B", [route("B", "A", @unimportant)])
  end
  
  def test_pick_second_leg
    assert_equal 4, @route_permutations.shortest_distance("B", "C", 
      [route("A", "B", @unimportant),
       route("B", "C", 4)])
  end

  def test_pick_first_leg
    assert_equal 5, @route_permutations.shortest_distance("A", "B", 
     [route("A", "B", 5), 
      route("B", "C", @unimportant)])
  end

  def test_two_part_route
    assert_equal 5 + 4, @route_permutations.shortest_distance("A", "C", [route("A", "B", 5), route("B", "C", 4)])
  end

  def test_pick_shortest_two_part_route
    assert_equal 6 + 1, @route_permutations.shortest_distance("A", "D", 
        [route("A", "B", 5), route("B", "D", 4),
         route("A", "C", 6), route("C", "D", 1)])
  end

  def test_indirect_route_shortest
    assert_equal 2 + 1, @route_permutations.shortest_distance("A", "C", 
        [route("A", "C", 15), 
         route("A", "B", 2), 
         route("B", "C", 1)])
  end

  def test_four_part_route
    assert_equal 15 + 2 + 1 + 12, @route_permutations.shortest_distance("A", "E", 
    [route("A", "B", 15), 
     route("B", "C", 2), 
     route("C", "D", 1), 
     route("D", "E", 12)])
  end

  def test_circular_route_to_start
    assert_equal 1 + 4, @route_permutations.shortest_distance("A", "A", 
        [route("A", "B", 1), 
         route("B", "A", 4)])
  end

  def test_circular_route_to_point_on_route
    assert_equal 8 + 3, @route_permutations.shortest_distance("A", "C", 
        [route("A", "B", 8), 
         route("B", "C", 3),
         route("C", "B", 6)])
  end

  def test_multiple_routes_are_followed_from_a_node_after_from
    assert_equal 1 + 2 + 3, @route_permutations.shortest_distance("A", "E", 
        [route("A", "B", 1), 
         route("B", "C", 50),
         route("B", "D", 2),
         route("C", "E", 50),
         route("D", "E", 3)])
  end

  def test_distance_of_specified_route
    assert_equal 1 + 2, @route_permutations.distance(
        desired_routes([desired_route("A", "B"), 
                        desired_route("B", "D")]), 
        [route("A", "B", 1), 
         route("C", "E", 50),
         route("B", "D", 2),
         route("D", "E", 3)])
  end

  def test_distance_of_specified_circular_route
    assert_equal 1 + 3, @route_permutations.distance(
        desired_routes([desired_route("A", "B"), 
                        desired_route("B", "A")]), 
        [route("A", "B", 1), 
         route("B", "A", 3)])
  end

  def test_distance_of_invalid_specified_route
    assert_equal @no_such_route, @route_permutations.distance(
        desired_routes([desired_route("A", "D")]), 
        [route("A", "B", 1), 
         route("D", "E", 3)])
  end

  def test_permutate_routes_up_to_2_stops
    maximum_stops = 2

    assert_equal( 
        [desired_routes([desired_route("A", "B")]), \
         desired_routes([desired_route("A", "B"), desired_route("B", "A")]), \
         desired_routes([desired_route("A", "B"), desired_route("B", "A"), desired_route("A", "B")])],  
        @route_permutations \
            .all_permutations_capped_at_leg_count_from("A", maximum_stops,
                                                       [route("A", "B", @unimportant),
                 route("B", "A", @unimportant)])
    )
  end

  def test_permutate_routes_up_to_3_stops
    maximum_stops = 3

    assert_equal( 
        [desired_routes([desired_route("C", "E")]), \
         desired_routes([desired_route("C", "E"), desired_route("E", "C")]), \
         desired_routes([desired_route("C", "E"), desired_route("E", "C"), desired_route("C", "E")]), 
         desired_routes([desired_route("C", "E"), desired_route("E", "C"), desired_route("C", "E"), desired_route("E", "C")])],
        @route_permutations \
            .all_permutations_capped_at_leg_count_from("C", maximum_stops,
                                                       [route("C", "E", @unimportant),
                 route("E", "C", @unimportant)])
    )
  end

  def test_permutate_routes_up_to_distance_30
    maximum_distance = 30

    assert_equal( 
        [desired_routes([desired_route("A", "B")]), \
         desired_routes([desired_route("A", "B"), desired_route("B", "A")]), \
         desired_routes([desired_route("A", "B"), desired_route("B", "A"), desired_route("A", "B")])],  
        @route_permutations \
            .all_permutations_capped_at_distance_from("A", maximum_distance, 
                [route("A", "B", 14), 
                 route("B", "A", 1)])
    )
  end

  def test_permutate_routes_up_to_distance_6
    maximum_distance = 7

    assert_equal( 
        [desired_routes([desired_route("C", "E")]), \
         desired_routes([desired_route("C", "E"), desired_route("E", "C")]), \
         desired_routes([desired_route("C", "E"), desired_route("E", "C"), desired_route("C", "E")]), 
         desired_routes([desired_route("C", "E"), desired_route("E", "C"), desired_route("C", "E"), desired_route("E", "C")])],
        @route_permutations \
            .all_permutations_capped_at_distance_from("C", maximum_distance, 
                [route("C", "E", 2), 
                 route("E", "C", 1)])
    )
  end

  def setup
    @unimportant = 0
    @route_permutations = RoutePermutations.new
    @no_such_route = "NO SUCH ROUTE"
  end

  def route from, to, distance
    return Leg.new from, to, distance
  end

  def desired_route from, to
    return Leg.new from, to, 0
  end

  def desired_routes legs
      RouteCandidate.new legs
  end

end
