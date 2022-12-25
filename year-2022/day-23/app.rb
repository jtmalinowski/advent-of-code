require 'json'
require 'Set'

Pt = Struct.new :x, :y

def run

  map = File.open(ARGV[0]).map do |line|
    next if line.strip.empty?
    line.tr("\n", '').chars
  end.compact

  cells = []
  cells_by_coords = {}
  map.each_with_index do |line,y|
    line.each_with_index do |ch,x|
      next if ch == '.'
      pt = Pt.new(x, y)
      cells.push pt
      cells_by_coords[{x:x,y:y}] = pt
    end
  end

  any_north = -> (c) { cells_by_coords[{x:c.x,y:c.y-1}] || cells_by_coords[{x:c.x-1,y:c.y-1}] || cells_by_coords[{x:c.x+1,y:c.y-1}] }
  any_south = -> (c) { cells_by_coords[{x:c.x,y:c.y+1}] || cells_by_coords[{x:c.x-1,y:c.y+1}] || cells_by_coords[{x:c.x+1,y:c.y+1}] }
  any_west = -> (c) { cells_by_coords[{x:c.x-1,y:c.y}] || cells_by_coords[{x:c.x-1,y:c.y+1}] || cells_by_coords[{x:c.x-1,y:c.y-1}] }
  any_east = -> (c) { cells_by_coords[{x:c.x+1,y:c.y}] || cells_by_coords[{x:c.x+1,y:c.y+1}] || cells_by_coords[{x:c.x+1,y:c.y-1}] }

  move_north = -> (c) { {x:c.x,y:c.y-1} }
  move_south = -> (c) { {x:c.x,y:c.y+1} }
  move_west = -> (c) { {x:c.x-1,y:c.y} }
  move_east = -> (c) { {x:c.x+1,y:c.y} }

  directions = [
    {is_taken: any_north, get_dest: move_north },
    {is_taken: any_south, get_dest: move_south },
    {is_taken: any_west, get_dest: move_west },
    {is_taken: any_east, get_dest: move_east },
  ]

  iter = 0
  loop do
    dests = {}
    cells.each do |cell|
      next unless any_north.call(cell) || any_south.call(cell) || any_west.call(cell) || any_east.call(cell)

      direction = directions.find{|d| !d[:is_taken].call(cell)}
      if direction
        dest = direction[:get_dest].call(cell)
        dests[dest] ||= []
        dests[dest].push cell
      end
    end

    moved = Set.new
    new_cells_by_coords = {}
    dests.keys.each do |dest|
      next if dests[dest].count > 1
      new_cells_by_coords[dest] = dests[dest][0]
      moved.add dests[dest][0]
    end

    if moved.count == 0
      puts iter + 1
      break
    end

    cells.filter{|c| !moved.member?(c)}.each{|c| new_cells_by_coords[{x:c.x,y:c.y}]=c}
    new_cells_by_coords.each{|crds,c| c.x=crds[:x]; c.y=crds[:y] }
    cells_by_coords = new_cells_by_coords
    directions = directions.rotate(1)

    if iter == 9
      min_x = cells.map(&:x).min
      max_x = cells.map(&:x).max
      min_y = cells.map(&:y).min
      max_y = cells.map(&:y).max
      puts (max_x - min_x + 1) * (max_y - min_y + 1) - cells.count
    end  
    iter += 1
  end
  
end

run
