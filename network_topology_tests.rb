require "minitest/autorun"
require_relative "atomic_route"
require_relative "network_topology.rb"

class NetworkTopologyTests < Minitest::Test
    def test_singe_atomic_route
        topology = NetworkTopology.new ["AB5"]

        assert_equal [route("A", "B", 5)], topology.atomic_routes
    end

    def test_two_atomic_routes
        topology = NetworkTopology.new ["AB5", "BC4"]

        assert_equal [route("A", "B", 5),
                      route("B", "C", 4)], 
                      topology.atomic_routes
    end

    def test_three_atomic_routes
        topology = NetworkTopology.new ["DE6", "AD5", "CE2"]

        assert_equal [route("D", "E", 6),
                      route("A", "D", 5),
                      route("C", "E", 2)], 
                      topology.atomic_routes
    end

    def test_invalid_input
        topology = NetworkTopology.new ["DE5", "AD5", "CE?"]
        
        assert_equal [], topology.atomic_routes
        refute_equal "", topology.error_message
    end

    def route from, to, distance
        return AtomicRoute.new from, to, distance
    end

end
