RangeDef = Struct.new(:dest, :source, :length) {
  def dest_end
    dest + length - 1
  end

  def source_end
    source + length - 1
  end

  def diff
    dest - source
  end
}

class RangeMap
  def initialize
    @ranges = []
  end

  def add_range(dest, source, length)
    @ranges.push RangeDef.new dest, source, length
  end

  def transform_values(values)
    values.map do |value|
      range = @ranges.find{|r| r.source <= value && (r.source + r.length) > value}
      next value unless range
      next value - range.source + range.dest
    end
  end

  def transform_values2(values2)
    values2.reduce([]){|acc,v| acc + transform_value2(v)}
  end

  def transform_value2(value2)
    lo, hi = value2

    # full cov
    range = @ranges.find{|r| r.source <= lo && (r.source + r.length) > hi}
    return [[lo - range.source + range.dest, hi - range.source + range.dest]] if range

    # middle split
    range = @ranges.find{|r| r.source > lo && (r.source + r.length - 1) < hi}
    if range
      left_side = transform_value2([lo, range.source - 1])
      transformed = [[range.dest, range.dest + range.length - 1]]
      right_side = transform_value2([range.source + range.length, hi])
      return left_side + transformed + right_side
    end

    # left side
    range = @ranges.find{|r| r.source <= lo && r.source_end >= lo }
    if range
      transformed = [[lo + range.diff, range.dest_end]]
      right_side = transform_value2([range.source_end + 1, hi])
      return transformed + right_side
    end

    # right side
    range = @ranges.find{|r| r.source_end >= hi && r.source <= hi}
    if range
      left_side = transform_value2([lo, range.source - 1])
      transformed = [[range.dest, hi + range.diff]]
      return left_side + transformed
    end

    return [[lo, hi]]
  end
end

def run()
  input_path = ARGV[0] || 'example'

  values = []
  values2 = []
  range_map = nil

  lines = File.open(input_path).to_a
  lines.each_with_index do |line, idx|
    line = line.strip

    if (line.start_with? "seeds:")
      values = line[('seeds:'.length)..-1].split(' ').map(&:strip).map(&:to_i)
      values2 = values.each_slice(2).to_a.map{|pair| [pair[0], pair[0] + pair[1] - 1] }
      next
    end

    if line.start_with? /[a-z]+\-to/
      range_map = RangeMap.new
      next
    end

    if line.match?(/([0-9]+ )+/)
      dest, source, len = line.strip.split(' ').map(&:strip).map(&:to_i)
      range_map.add_range dest, source, len
    end

    if line.empty? || idx == (lines.length - 1)
      next unless range_map
      values = range_map.transform_values values
      values2 = range_map.transform_values2 values2
      next
    end
  end

  puts "min: #{values.min}"
  puts "min2: #{values2.flatten.min}"
end

run
