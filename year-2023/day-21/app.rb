module Enumerable
  def vector_add(*others)
    zip(*others).map{|z| z.reduce(:+)}
  end
end

rows = File.open(ARGV[0] || 'input-test').map(&:strip).map(&:chars)

def find_s(rows) = rows.each_with_index{|row,y| row.each_with_index{|ch,x| return [y,x] if ch == 'S' }}
pos_S = find_s rows
rows[pos_S[0]][pos_S[1]] = '.'

STEPS = [[1,0],[-1,0],[0,1],[0,-1]]

prev_poses = Set.new
poses = Set.new
poses.add pos_S

cache = [1]

cycle_len = rows.length
cycle_shift = 26501365 % rows.length

(1..).each do |day|
  new_poses = Set.new
  poses.each do |pos|
    STEPS.map{|s| s.vector_add pos}.each do |c|
      new_poses.add c if rows[c[1] % rows.length][c[0] % rows[0].length] == '.' && !prev_poses.include?(c)
    end
  end
  prev_poses = poses
  poses = new_poses
  count = poses.length + (day > 1 ? cache[day - 2] : 0)
  cache[day] = count

  break if day > 3 * cycle_len
end

puts cache[64]

n = 26501365 / cycle_len
puts cache[cycle_shift] + n * (cache[cycle_len + cycle_shift] - cache[cycle_shift]) + n * (n-1) / 2 * ((cache[2 * cycle_len + cycle_shift] - cache[cycle_len + cycle_shift]) - (cache[cycle_len + cycle_shift] - cache[cycle_shift]))
