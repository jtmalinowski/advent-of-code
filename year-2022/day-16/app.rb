require 'json'
require 'Set'
require 'parallel'

Valve = Struct.new(:id, :rate, :tunnel_ids)

def run

  by_id = {}
  list = []
  compacted = {}

  backtrack = -> (path, which_open, flow_done, time_left) {
    return flow_done if time_left <= 1
    current = by_id[path.last]

    if current.rate > 0 # special case AA
      which_open = which_open.dup
      which_open[current.id] = true
      flow_done += current.rate * (time_left - 1)
      time_left -= 1
    end

    compacted[current.id].each_pair.map do |next_id, cost|
      next flow_done if which_open[next_id]
      val = backtrack.call(path + [next_id], which_open, flow_done, time_left - cost)
      val
    end.max
  }

  counter2 = 0
  backtrack2 = -> (path1, path2, which_open, flow_done, time1, time2) {
    return flow_done if time1 <= 1 && time2 <= 1

    current1 = by_id[path1.last]
    current2 = by_id[path2.last]

    if current1.rate > 0 && !which_open[current1.id] # special case AA
      which_open = which_open.dup
      which_open[current1.id] = true
      flow_done += current1.rate * (time1 - 1)
      time1 -= 1
    end

    if current2.rate > 0 && !which_open[current2.id] # special case AA
      which_open = which_open.dup
      which_open[current2.id] = true
      flow_done += current2.rate * (time2 - 1)
      time2 -= 1
    end

    if time1 >= time2
      compacted[current1.id].each_pair.map do |next_id, cost|
        next flow_done if which_open[next_id]
        backtrack2.call(path1 + [next_id], path2, which_open, flow_done, time1 - cost, time2)
      end.max
    else
      compacted[current2.id].each_pair.map do |next_id, cost|
        next flow_done if which_open[next_id]
        backtrack2.call(path1, path2 + [next_id], which_open, flow_done, time1, time2 - cost)
      end.max
    end
  }

  compact_tunnels = -> (valve) {
    paths = [[valve]]
    black = Set.new

    loop do
      path = paths.shift
      break if path == nil

      current = path.last
      next if black.member? current.id

      if current.rate > 0 && path.count > 1
        compacted[path.first.id] ||= {}
        compacted[path.first.id][current.id] = path.count - 1
      end

      black.add current.id
      current.tunnel_ids.each do |next_id|
        next if black.member? next_id
        paths.push path + [by_id[next_id]]
      end
    end
  }

  File.open(ARGV[0]).each do |line|
    next if line.strip.empty?

    flow, tunnels = line.split ';'
    valve_id = flow[/Valve [A-Z]{1,3}/][6..-1]
    rate = flow[/rate\=-?\d+/][5..-1].to_i
    tunnel_ids = tunnels.match(/valves? (.*)$/).captures[0].split(',').map(&:strip)

    valve = Valve.new valve_id, rate, tunnel_ids
    by_id[valve_id] = valve
    list.push valve
  end

  list.each{|valve| compact_tunnels.call(valve)}
  # puts compacted.to_json

  puts backtrack.call(['AA'], {}, 0, 30)
  puts backtrack2.call(['AA'], ['AA'], {}, 0, 26, 26)
end

run
