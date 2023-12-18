require './pq'
require 'Set'

module Enumerable
  def vector_add(*others)
    zip(*others).map{|z| z.reduce(:+)}
  end
end

Pth = Struct.new(:steps, :coords, :cost) {
  def <=>(other)
    cost <=> other.cost
  end
}

input_path = ARGV[0] || 'input-test'

grid = File.open(input_path).map(&:strip).map(&:chars).map{|line| line.map(&:to_i)}

STEPS = {
  up: [-1, 0],
  down: [1, 0],
  left: [0, -1],
  right: [0, 1],
}

def trace(grid, min_straight_steps, max_straight_steps)
  cost = 0
  vis = Set.new

  q = PQ.new true
  q.insert Pth.new([:down, :right], [0, 1], grid[0][1])
  q.insert Pth.new([:right, :down], [1, 0], grid[1][0])

  loop do
    break if q.empty?
    curr = q.pop

    coords = curr.coords
    last_step = curr.steps[-1]
    last_straight = curr.steps.reverse.take_while{|s| s == last_step}
    key = [coords, last_straight]
    next if vis.include? key
    vis.add key

    break cost = curr.cost if coords == [grid.length - 1, grid[0].length - 1] && last_straight.length >= min_straight_steps

    dirs = []
    dirs.push(:up, :down) if [:right, :left].include?(last_step) && last_straight.length >= min_straight_steps
    dirs.push(:left, :right) if [:up, :down].include?(last_step) && last_straight.length >= min_straight_steps
    dirs.push(last_step) if last_straight.length < max_straight_steps

    dirs.each do |dir|
      y, x = coords.vector_add(STEPS[dir])
      next if y < 0 || y >= grid.length
      next if x < 0 || x >= grid[0].length

      q.insert Pth.new(curr.steps + [dir], [y,x], curr.cost+grid[y][x])
    end
  end

  puts cost
end

trace(grid, 1, 3)
trace(grid, 4, 10)
