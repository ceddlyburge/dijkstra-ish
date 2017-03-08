require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'leg'
require_relative 'route_candidate.rb'

class RouteCandidateTests < Minitest::Test

  def test_distance
    distance_1 = 5
    distance_2 = 6
    route_candidate = RouteCandidate.new [leg_with_distance(distance_1), leg_with_distance(distance_2)]

    assert_equal distance_1 + distance_2, route_candidate.distance
  end

  def test_to_s
    distance_1 = 5
    distance_2 = 6
    route_candidate = RouteCandidate.new [leg('from_1', 'to_1', distance_1), leg('from_2', 'to_2', distance_2)]

    total_distance = distance_1 + distance_2
    assert_equal \
      %Q[\nRoutes\nDistance #{total_distance.to_s}\nfrom_1 to_1 #{distance_1.to_s}\nfrom_2 to_2 #{distance_2.to_s}\nend\n] \
      , route_candidate.to_s
  end

  def test_leg_distance_not_used_for_equality
    leg_1 = leg 'from', 'to', 5
    leg_2 = leg 'from', 'to', 6

    route_candidate_1 = RouteCandidate.new [leg_1]
    route_candidate_2 = RouteCandidate.new [leg_2]

    assert_equal true, route_candidate_1 == route_candidate_2
  end

  def test_leg_from_used_for_equality
    leg_1 = leg 'from', 'to', @unimportant
    leg_2 = leg 'not_from', 'to', @unimportant

    route_candidate_1 = RouteCandidate.new [leg_1]
    route_candidate_2 = RouteCandidate.new [leg_2]

    assert_equal false, route_candidate_1 == route_candidate_2
  end

  def test_leg_to_used_for_equality
    leg_1 = leg 'from', 'to', @unimportant
    leg_2 = leg 'from', 'not_to', @unimportant

    route_candidate_1 = RouteCandidate.new [leg_1]
    route_candidate_2 = RouteCandidate.new [leg_2]

    assert_equal false, route_candidate_1 == route_candidate_2
  end

  def test_ending_point_is_last_to

    leg_1 = leg @unimportant, @unimportant, @unimportant
    leg_2 = leg @unimportant, 'last_to', @unimportant

    route_candidate = RouteCandidate.new [leg_1, leg_2]

    assert_equal leg_2.to, route_candidate.ending_point
  end

  def leg(from, to, distance)
    return Leg.new from, to, distance
  end

  def leg_with_distance(distance)
    return Leg.new @unimportant, @unimportant, distance
  end

  def setup
    @unimportant = 0
  end


end
