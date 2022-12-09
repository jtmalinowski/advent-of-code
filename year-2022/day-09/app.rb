require 'Set'

Integer.class_eval do
  def to_unit
    return 1 if self > 0
    return -1 if self < 0
    self
  end
end

Knot = Struct.new(:x, :y) do
  def move(direction)
    case direction
    when "U"
      Knot.new x, y - 1
    when "D"
      Knot.new x, y + 1
    when "L"
      Knot.new x - 1, y
    when "R"
      Knot.new x + 1, y
    else
      raise "wrong direction"
    end
  end

  def is_far?(other); ((self.x - other.x).pow(2) + (self.y - other.y).pow(2)) > 2; end
  def follow(other)
    return self unless is_far?(other)
    Knot.new(x + (other.x - self.x).to_unit, y + (other.y - self.y).to_unit)
  end
end

def run
  input_path = ARGV[0]

  rope = 10.times.map{ Knot.new 0, 0 }
  positions2 = Set.new
  positions9 = Set.new

  File.open(input_path).each do |line|
    match = line.match /([A-Z]) (\d+)/
    direction, steps = match.captures

    steps.to_i.times do
      rope = rope.reduce([]) do |mem, knot|
        mem.push(if mem.empty? then knot.move(direction) else knot.follow(mem.last) end)
      end

      positions2.add rope[1]
      positions9.add rope[9]
    end
  end

  puts positions2.count
  puts positions9.count
end

run
