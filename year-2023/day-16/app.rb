require 'set'

input_path = ARGV[0] || 'input-test'

module Enumerable
  def vector_add(*others)
    zip(*others).map{|z| z.reduce(:+)}
  end
end

DIRS = {
  :left => [0,-1],
  :right => [0,1],
  :up => [-1,0],
  :down => [1,0],
}

REFLECTIONS = {
  [:down, '/'] => [:left],
  [:down, '\\'] => [:right],
  [:down, '-'] => [:left, :right],
  [:down, '|'] => [:down],
  [:up, '/'] => [:right],
  [:up, '\\'] => [:left],
  [:up, '-'] => [:left, :right],
  [:up, '|'] => [:up],
  [:right, '/'] => [:up],
  [:right, '\\'] => [:down],
  [:right, '-'] => [:right],
  [:right, '|'] => [:up, :down],
  [:left, '/'] => [:down],
  [:left, '\\'] => [:up],
  [:left, '-'] => [:left],
  [:left, '|'] => [:up, :down],
}

@grid = File.open(input_path).map(&:strip).map(&:chars)

def count(start_point, start_direction)
  tiles = Set.new
  vis = Set.new
  beams = [[start_point, start_direction]]
  loop do
    break if beams.empty?
    new_beams = []
    beams.each do |beam|
      point, direction = beam
      y, x = point
      next if y < 0 || y >= @grid.length
      next if x < 0 || x >= @grid[0].length

      next if vis.include? [y,x,direction]
      vis.add [y,x,direction]
      
      type = @grid[y][x]
      tiles.add [y,x]

      refls = REFLECTIONS[[direction, type]]
      next new_beams.push(*refls.map{|r| [point.vector_add(DIRS[r]) ,r]}) if refls

      new_beams.push([point.vector_add(DIRS[direction]), direction])
    end
    beams = new_beams
  end
  tiles.length
end

puts count([0,0], :right)

starts = []
(0...@grid.length).each{|y| starts.push [[y,0],:right] }
(0...@grid.length).each{|y| starts.push [[y,@grid[0].length-1],:left] }
(0...@grid[0].length).each{|x| starts.push [[0,x],:down] }
(0...@grid[0].length).each{|x| starts.push [[@grid[0].length-1,x],:up] }
puts starts.map{|p| count p[0], p[1]}.max
