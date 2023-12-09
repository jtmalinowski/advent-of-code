require 'set'

input_path = ARGV[0] || 'example'

directions = {}
path = []

lines = File.open(input_path).to_a
lines.each_with_index do |line, idx|
  line = line.strip
  next if line.empty?

  if /([RL]+)$/ =~ line
    path = $1.chars
  end

  if /([A-Z\d]+) = \(([A-Z\d]+), ([A-Z\d]+)\)/ =~ line
    directions[$1] = [$2, $3]
  end
end

def dist_to_z(path, directions, curr, suffix)
  step_no = 0
  loop do
    side = path[step_no % path.length] == 'L' ? 0 : 1
    curr = directions[curr][side]
    key = "#{curr}-#{side}"
    step_no += 1
    return step_no if curr.end_with?(suffix)
  end
end

puts dist_to_z(path, directions, 'AAA', 'ZZZ')

# no need to review all possible Z nodes, first one is always correct
currs = directions.keys.filter{|k| k.end_with? "A"}
puts currs.map{|c| dist_to_z(path, directions, c, 'Z')}.reduce(:lcm)
