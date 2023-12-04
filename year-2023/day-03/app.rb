def is_digit?(s)
  code = s.ord
  # 48 is ASCII code of 0
  # 57 is ASCII code of 9
  48 <= code && code <= 57
end

def inside_grid?(y, x)
  y >= 0 && y < @grid.length && x >= 0 && x < @grid[0].length
end

@neighs = [[-1, -1], [-1, 0], [-1,  1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
def has_symbol?(base_y, base_x)
  @neighs.any?{|pair|
    y = base_y + pair[0]
    x = base_x + pair[1]
    next false unless inside_grid?(y, x)
    !is_digit?(@grid[y][x]) && @grid[y][x] != '.'
  }
end

Num = Struct.new(:y, :x, :length, :val)
Gear = Struct.new(:y, :x)

def run()
  sum = 0
  sum2 = 0

  is_test = ENV.fetch("AOC_TEST", "false").downcase == "true"
  input_path = is_test ? "input-test" : "input"

  nums = []
  gears = []
  grid = []

  File.open(input_path).each_with_index do |line, y|
    line = line.strip
    next if line.empty?

    grid.push line
    line.scan(/(\d+)/) do |num_match|
      num = num_match.first.to_i
      x = Regexp.last_match.begin(0)
      len = Regexp.last_match.end(0) - x
      nums.push Num.new(y, x, len, num)
    end

    line.chars.each_with_index do |ch, x|
      next unless ch == '*'
      gears.push Gear.new(y, x)
    end
  end

  nums.each do |num|
    min_x = [num.x - 1, 0].max
    max_x = [num.x + num.length, grid[0].length - 1].min

    has_symbol = false
    has_symbol ||= grid[num.y][min_x..max_x].match?(/[^0-9\.]/)
    has_symbol ||= (num.y == 0) ? false : grid[num.y - 1][min_x..max_x].match?(/[^0-9\.]/)
    has_symbol ||= (num.y < grid.length - 1) ? grid[num.y + 1][min_x..max_x].match?(/[^0-9\.]/) : false

    sum += num.val if has_symbol
  end

  gears.each do |gear|
    matching = nums.filter do |num|
      next false if num.y < gear.y - 1
      next false if num.y > gear.y + 1
      next false if num.x > gear.x + 1
      next false if num.x + num.length < gear.x
      true
    end

    sum2 += matching.map(&:val).reduce(:*) if matching.length == 2
  end

  puts sum
  puts sum2
end

run
