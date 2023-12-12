input_path = ARGV[0] || 'example'

@lines = File.open(input_path).map(&:strip).map(&:chars).to_a

@empty_rows = []
@lines.each_with_index do |line,y|
  @empty_rows.push(y) if line.all?{|ch| ch == '.'}
end

@empty_columns = []
@lines.transpose.each_with_index do |line,x|
  @empty_columns.push(x) if line.all?{|ch| ch == '.'}
end

def count(factor)
  galaxies = []
  @lines.each_with_index do |line,y|
    line.each_with_index do |ch,x|
      y_shift = @empty_rows.filter{|r| r < y}.length * factor
      x_shift = @empty_columns.filter{|r| r < x}.length * factor
      galaxies.push([y+y_shift,x+x_shift,galaxies.length+1]) if ch == '#'
    end
  end

  sum = 0
  galaxies.product(galaxies).each do |g1, g2|
    next if (g1 <=> g2) >= 0
    diff = (g2[0] - g1[0]).abs + (g2[1] - g1[1]).abs
    sum += diff
  end
  puts sum
end

count(1)
count(1_000_000 - 1)
