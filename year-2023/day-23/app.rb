require 'set'

module Enumerable
  def vector_add(*others)
    zip(*others).map{|z| z.reduce(:+)}
  end
end

Pth = Struct.new :last, :steps

grid = File.open(ARGV[0] || 'input-test').map(&:strip).map(&:chars)
start = [0, grid[0].index('.')]
finish = [grid.length - 1, grid.last.index('.')]

DIRS = [[1,0],[-1,0],[0,1],[0,-1]]
def get_nxts(grid, pt, ignore_slope = false)
  ch = grid.dig(*pt)
  dirs = ignore_slope ? DIRS : (case ch
  when '.' then DIRS
  when '>' then [[0,1]]
  when '<' then [[0,-1]]
  when '^' then [[-1,0]]
  when 'v' then [[1,0]]
  else raise "unexpected char #{ch} at #{pt.inspect}"
  end)

  dirs.map{|dir| dir.vector_add pt }
end

def is_legal?(grid, pt)
  return false if grid.dig(*pt) == '#'
  return false if pt[0] < 0 || pt[0] >= grid.length
  return false if pt[1] < 0 || pt[1] >= grid[0].length
  true
end

def find(grid, start, finish, ignore_slope = false, shortest = false)
  q = [Pth.new(start, Set.new([start]))]
  longest = -1
  lengths = {}

  loop do
    break if q.empty?
    path = q.shift
    curr = path.last
    ch = grid.dig(*curr)
    
    # puts "#{q.length} #{path.steps.length}"
    nxts = get_nxts grid, curr, ignore_slope

    # puts nxts.inspect
    nxts.each do |nxt|
      next if path.steps.include? nxt
      next unless is_legal?(grid, nxt)
      
      next if lengths[nxt] && lengths[nxt] >= path.steps.length
      lengths[nxt] = path.steps.length

      if nxt == finish
        return path.steps.length if shortest
        longest = [longest, path.steps.length].max
        next
      end
 
      q.push Pth.new(nxt, path.steps + [nxt])
    end
  end
  longest
end

puts find grid, start, finish, false, false
# puts find grid, start, finish, false, true
# puts find grid, start, finish, true, false

intersects = [start, finish]
grid.each_with_index do |line,y|
  line.each_with_index do |ch,x|
    next if ch == '#'
    intersects.push([y,x]) if DIRS.map{|dir| dir.vector_add [y,x] }.filter{|pt| ['.', '<', '>', 'v', '^'].include? grid.dig(*pt) }.length > 2
  end
end
puts intersects.length

inter_dists = {}
dists = {}
intersects.each do |i1|
  q = get_nxts(grid, i1).filter{|nxt| is_legal? grid, nxt}.map{|nxt| Pth.new nxt, [nxt] }
  vis = Set.new [i1]
  
  loop do
    break if q.empty?
    curr = q.shift

    next if vis.include? curr.last
    vis.add curr.last

    if intersects.include? curr.last
      # puts "#{i1} to #{curr.last} dist: #{curr.steps.length}"
      raise "wrong?" if (dists.dig(*curr.last) || curr.steps.length) != curr.steps.length

      (dists[i1] ||= {})[curr.last] = curr.steps.length
      (dists[curr.last] ||= {})[i1] = curr.steps.length
      next
    end

    get_nxts(grid, curr.last, true).each do |nxt|
      next if nxt[0] < 0 || nxt[0] >= grid.length
      next if nxt[1] < 0 || nxt[1] >= grid[0].length
      next if grid.dig(*nxt) == '#'
      next if vis.include? nxt

      q.push Pth.new(nxt, curr.steps + [nxt])
    end
  end
end

# dists.keys.each do |i1|
#   dists[i1].keys.each do |i2|
#     puts "pt_#{i1.join('_')} -> pt_#{i2.join('_')}"
#   end
# end

q = [Pth.new(start, Set.new([start]))]
longest = 0
cache = {}
loop do
  break if q.empty?
  curr = q.pop

  puts curr.steps.inspect

  if curr.last == finish
    len = curr.steps.each_cons(2).map{|i1,i2| dists[i1][i2]}.reduce(:+)
    longest = [longest, len].max
    next
  end

  dists[curr.last].keys.each do |nxt|
    next if curr.steps.include?(nxt)
    q.push Pth.new(nxt, curr.steps + [nxt])
  end
end
puts longest
