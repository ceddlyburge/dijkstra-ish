require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'leg'
require_relative 'network_topology_parser.rb'

class LegTests < Minitest::Test
  def test_to_s
    leg = Leg.new 'from', 'to', 5

    assert_equal 'from to 5', leg.to_s
  end

  def test_all_fields_used_for_equality
    leg_1 = Leg.new 'from', 'to', 5
    leg_2 = Leg.new 'from', 'to', 5

    assert_equal leg_1, leg_2
  end

  def test_from_used_for_equality
    leg_1 = Leg.new 'from', 'to', 5
    leg_2 = Leg.new 'not_from', 'to', 5

    refute_equal leg_1, leg_2
  end

  def test_to_used_for_equality
    leg_1 = Leg.new 'from', 'to', 5
    leg_2 = Leg.new 'from', 'not_to', 5

    refute_equal leg_1, leg_2
  end

  def test_distance_used_for_equality
    leg_1 = Leg.new 'from', 'to', 5
    leg_2 = Leg.new 'from', 'to', 6

    refute_equal leg_1, leg_2
  end

end
