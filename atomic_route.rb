class AtomicRoute
 attr_reader :from, :to, :distance

  # from and to are expected t be string identifiers, distance is expected to be a number
  def initialize(from, to, distance)
    @from = from
    @to = to
    @distance = distance
  end

  def to_s
      "#{@from} #{@to} #{@distance}"
  end

  def == (other_atomic_route)
    other_atomic_route != nil && @from == other_atomic_route.from && @to == other_atomic_route.to && @distance == other_atomic_route.distance    
  end
end
