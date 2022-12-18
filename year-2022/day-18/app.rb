require 'json'
require 'Set'

Array.class_eval do
  def vector_sum(o); self.each_with_index.map{|val, idx| val + o[idx] }; end
end

def run
  cubes = []
  matrix = []

  File.open(ARGV[0]).each do |line|
    next if line.strip.empty?
    crds = line.strip.split(',').map(&:to_i).map(&:succ)
    raise "wrong coords" if crds.count != 3

    cubes.push crds
    x, y, z = crds
    matrix[x] ||= []
    matrix[x][y] ||= []
    matrix[x][y][z] ||= 1
  end

  min_x = cubes.map{|c| c[0]}.min - 1
  max_x = cubes.map{|c| c[0]}.max + 1
  min_y = cubes.map{|c| c[1]}.min - 1
  max_y = cubes.map{|c| c[1]}.max + 1
  min_z = cubes.map{|c| c[2]}.min - 1
  max_z = cubes.map{|c| c[2]}.max + 1

  within_bounds = -> (c) { c[0] >= min_x && c[0] <= max_x && c[1] >= min_y && c[1] <= max_y && c[2] >= min_z && c[2] <= max_z }
  is_at = -> (crds) { within_bounds.call(crds) && matrix.dig(crds[0], crds[1], crds[2]) }

  directions = [
    [1, 0, 0],
    [-1, 0, 0],
    [0, 1, 0],
    [0, -1, 0],
    [0, 0, 1],
    [0, 0, -1],
  ]
  
  sum = 0
  sum2 = 0
  part2_done = false
  start = loop do
    maybe = [min_x,min_y,min_z]
    break maybe unless is_at.call maybe
    maybe[0] += 1
  end
  q = [start]
  black = Set.new
  loop do
    if q.empty? && !part2_done
      q = cubes.dup
      part2_done = true
      sum = sum2
    end

    current = q.shift
    break unless current
    next if black.member? current

    black.add current

    candidates = directions.map{|d| d.vector_sum current}.filter{|d| within_bounds.call d}
    candidates.each do |candidate|
      if !is_at.call(current) && is_at.call(candidate)
        sum2 += 1
        next
      end

      next if black.member? candidate
      q.push candidate
    end
  end
  puts sum2
  puts sum
end

run
