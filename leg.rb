class Leg
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

  def == (other_leg)
    other_leg != nil && @from == other_leg.from && @to == other_leg.to && @distance == other_leg.distance
  end
end
