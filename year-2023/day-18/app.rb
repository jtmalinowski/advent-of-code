require 'Set'

input_path = ARGV[0] || 'input-test'

module Enumerable
  def vector_add(*others)
    zip(*others).map{|z| z.reduce(:+)}
  end
end

cmds = File.open(input_path)
cmds = cmds.map do |cmd|
  if match = cmd.match(/([LRUD]) (\d+) \(#([a-z0-9]+)\)/)
    next [match.captures[0], match.captures[1].to_i, match.captures[2]]
  end
end

def trace(cmds)
  curr = [0,0]
  vertx = []
  edge = 0

  cmds.each do |dir, len|
    step = case dir
    when 'R' then [0, len]
    when 'D' then [len, 0]
    when 'L' then [0,-len]
    when 'U' then [-len,0]
    end
    
    curr = curr.vector_add step
    vertx.push curr
    edge += len
  end

  return vertx, edge
end

def triangle_formula(vertx, edge)
  vertx.each_cons(2).sum{|a,b| b[0] * a[1] - b[1] * a[0]}.abs / 2 + edge / 2 + 1
end

puts triangle_formula(*trace(cmds))

trace2 = cmds.map{|_,_,code| val = code.hex; ["RDLU"[val&0xf], val >> 4] }
# puts trace2.inspect
puts triangle_formula(*trace(trace2))
