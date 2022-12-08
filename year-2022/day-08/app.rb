require 'Set'

def run
  input_path = ARGV[0]

  map = []
  visibles = Set.new
  scores = []

  File.open(input_path).each do |line|
    map.push line.strip.chars.map(&:to_i)
  end

  get_visible = -> (list) {
    max = -1
    past = []

    list.each_with_index do |coords, idx|
      y, x = coords[:y], coords[:x]
      value = map[y][x]

      scores[y] = [] if scores[y] == nil
      scores[y][x] = 1 if scores[y][x] == nil
      scores[y][x] *= past.reverse.reduce(0){|mem,v|
        break mem + 1 if v >= value
        mem + 1
      }

      if value > max
        visibles.add coords
        max = value
      end

      past.push value
    end
  }

  coords_lists = []
  (0...map.count).each{|y| coords_lists.push((0...map[y].count).map{|x| {x:x,y:y}}) }
  (0...map.count).each{|y| coords_lists.push((0...map[y].count).map{|x| {x:x,y:y}}.reverse) }
  (0...map[0].count).each{|x| coords_lists.push((0...map.count).map{|y| {x:x,y:y}}) }
  (0...map[0].count).each{|x| coords_lists.push((0...map.count).map{|y| {x:x,y:y}}.reverse) }

  coords_lists.each{|list| get_visible.call(list)}
  puts visibles.count

  puts scores.map{|row| row.max}.max
end

run
