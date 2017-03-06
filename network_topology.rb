class NetworkTopology
  attr_reader :atomic_routes, :error_message
  
  # expecting an array of "AB2" type strings here, where "A" is the from location, "B" is the to location and "2" is the distance 
  def initialize(from_to_distances_as_single_chars)
      @error_message = from_to_distances_as_single_chars
        .select { | from_to_distance | (Integer from_to_distance[2] rescue nil) == nil }
        .map{ | from_to_distance | "Route #{from_to_distance} does not contain a valid distance, as #{from_to_distance[2]} is not a number" }
      
      @atomic_routes = (@error_message != []) ? [] :  from_to_distances_as_single_chars.map { | from_to_distance | AtomicRoute.new from_to_distance[0], from_to_distance[1], from_to_distance[2].to_i } 
  end
end
