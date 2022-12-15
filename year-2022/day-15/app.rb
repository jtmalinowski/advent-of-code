require 'json'

Sensor = Struct.new(:x, :y, :range) do
  def xs_range_for_y(given_y)
    dist_y = (given_y - y).abs
    return nil unless dist_y <= range
    [x - range + dist_y, x + range - dist_y]
  end
end

class Object
  def pipe
    yield self
  end
end

def run
  row_y = 10 if ARGV[0] == 'input-test'
  row_y = 2_000_000 if ARGV[0] == 'input'

  cap = 20 if ARGV[0] == 'input-test'
  cap = 4_000_000 if ARGV[0] == 'input'

  ranges_row_y = []
  sensors = []

  cap_range = -> (rng) { [
    rng[0] < 0 ? 0 : rng[0],
    rng[1] > cap ? cap : rng[1],
  ] }

  compact_ranges = -> (rngs) {
    rngs.compact.sort_by{|r| r[0]}.reduce([]){|memo,r|
      next memo.push(r) unless memo.last
      if memo.last[1] + 1 >= r[0]
        memo.last[1] = memo.last[1] > r[1] ? memo.last[1] : r[1]
      else
        memo.push r
      end
      memo
    }
  }

  File.open(ARGV[0]).each do |line|
    next if line.strip.empty?

    sensor, beacon = line.split ':'
    s_x, s_y = sensor[/x=-?\d+/][2..-1].to_i, sensor[/y=-?\d+/][2..-1].to_i
    b_x, b_y = beacon[/x=-?\d+/][2..-1].to_i, beacon[/y=-?\d+/][2..-1].to_i

    range = (s_x - b_x).abs + (s_y - b_y).abs

    sensor = Sensor.new(s_x, s_y, range)
    sensors.push sensor
    ranges_row_y.push sensor.xs_range_for_y(row_y)
  end

  puts compact_ranges.call(ranges_row_y).flat_map{|r| ( (r[0]) ... (r[1]) ).to_a }.count

  (0...cap).each do |current_y|
    ranges = sensors
      .map{|s| s.xs_range_for_y(current_y)&.pipe{|r| cap_range.call r} }
      .pipe{|rngs| compact_ranges.call rngs }

    next if ranges.count == 1 && (ranges[0][0] - ranges[0][1]).abs == cap
    puts (ranges[0][1] + 1) * 4_000_000 + current_y
    break
  end
end

run
