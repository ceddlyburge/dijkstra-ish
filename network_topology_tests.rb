require 'minitest/autorun'
require_relative 'leg'
require_relative 'network_topology_parser.rb'

class NetworkTopologyTests < Minitest::Test
    def test_singe_leg
        topology = NetworkTopologyParser.new ["AB5"]

        assert_equal [route("A", "B", 5)], topology.original_legs
    end

    def test_two_legs
        topology = NetworkTopologyParser.new ["AB5", "BC4"]

        assert_equal [route("A", "B", 5),
                      route("B", "C", 4)], 
                      topology.legs
    end

    def test_three_legs
        topology = NetworkTopologyParser.new ["DE6", "AD5", "CE2"]

        assert_equal [route("D", "E", 6),
                      route("A", "D", 5),
                      route("C", "E", 2)], 
                      topology.legs
    end

    def test_invalid_input
        topology = NetworkTopologyParser.new ["DE5", "AD5", "CE?"]
        
        assert_equal [], topology.legs
        refute_equal "", topology.error_message
    end

    def route from, to, distance
        return Leg.new from, to, distance
    end

end
