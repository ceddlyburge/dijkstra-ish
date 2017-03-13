require_relative 'test_helper' 
require_relative 'leg'
require_relative 'route_extension.rb'
require_relative 'route_candidate.rb'

class RouteExtensionTests < Minitest::Test

  def test_retraces_existing_leg_true_if_extension_leg_in_original_legs
    route_extension = RouteExtension.new [a_leg, a_different_leg], a_leg

    assert_equal true, route_extension.retraces_existing_leg
  end

  def test_retraces_existing_leg_false_if_extension_leg_absent_from_original_legs
    route_extension = RouteExtension.new [a_leg, a_leg], a_different_leg

    assert_equal false, route_extension.retraces_existing_leg
  end

  def test_route_candidate_nil_if_extension_leg_nil
    route_extension = RouteExtension.new [], nil

    assert_nil route_extension.route_candidate
  end

  def test_route_candidate_contains_original_legs_and_extension_leg
    route_extension = RouteExtension.new [a_leg], a_different_leg
    route_candidate = RouteCandidate.new [a_leg, a_different_leg]

    assert_equal route_candidate, route_extension.route_candidate
  end

  def a_leg
    return Leg.new 'from', 'to', 1
  end

  def a_different_leg
    return Leg.new 'from', 'not_to', 1
  end

  def setup
    @unimportant = 0
  end

end
