require_relative 'network_topology'

class NetworkTopologyParser
  # expecting an array of "AB2" type strings here, where "A" is the from location, "B" is the to location and "2" is the distance
  def parse(from_to_distances_as_single_chars)
    @from_to_distances_as_single_chars = from_to_distances_as_single_chars

    (validate_legs.length > 0) ? NetworkTopology.new(validate_legs, []) : NetworkTopology.new([], create_legs)
  end

  private
  # the first two characters in the string can be anything, and will be used to indicate from and to
  # the third character must be a number
  # to make it more robust we could also check that the string length was exactly 3.
  def validate_legs
    @from_to_distances_as_single_chars
        .collect { | from_to_distance | validate_leg(from_to_distance) }
        .select { | error | error != nil }
  end

  def validate_leg(from_to_distance)
    if from_to_distance.length != 3
      %Q[Invalid Route "#{from_to_distance}": Route must be 3 characters long]
    end

    if (Integer from_to_distance[2] rescue nil) == nil
      %Q[Invalid Route "#{from_to_distance}": Third character of route must be a number]
    end
  end

  def create_legs
    @from_to_distances_as_single_chars.collect { | from_to_distance | create_leg(from_to_distance) }
  end

  def create_leg(from_to_distance)
    Leg.new from_to_distance[0], from_to_distance[1], from_to_distance[2].to_i
  end

end
