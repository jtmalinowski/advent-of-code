require 'json'
require 'Set'

Bprint = Struct.new :id, :ore_rbt_c_ore, :cly_rbt_c_ore, :obs_robot_c_ore, :obs_robot_c_cly, :geo_robot_c_ore, :geo_robot_c_obs

State = Struct.new(:time, :ore, :cly, :obs, :geo, :ore_rbts, :cly_rbts, :obs_rbts, :geo_rbts) do
  def succ_time
    res = self.dup
    res.time += 1
    res.ore += res.ore_rbts
    res.cly += res.cly_rbts
    res.obs += res.obs_rbts
    res.geo += res.geo_rbts
    res
  end

  def buy_ore_rbt(bprint)
    res = self.dup
    return nil if bprint.ore_rbt_c_ore > res.ore
    res = res.succ_time
    res.ore -= bprint.ore_rbt_c_ore
    res.ore_rbts += 1
    res
  end

  def buy_cly_rbt(bprint)
    res = self.dup
    return nil if bprint.cly_rbt_c_ore > res.ore
    res = res.succ_time
    res.ore -= bprint.cly_rbt_c_ore
    res.cly_rbts += 1
    res
  end

  def buy_obs_rbt(bprint)
    res = self.dup
    return nil if bprint.obs_robot_c_ore > res.ore || bprint.obs_robot_c_cly > res.cly
    res = res.succ_time
    res.ore -= bprint.obs_robot_c_ore
    res.cly -= bprint.obs_robot_c_cly
    res.obs_rbts += 1
    res
  end

  def buy_geo_rbt(bprint)
    res = self.dup
    return nil if bprint.geo_robot_c_ore > res.ore || bprint.geo_robot_c_obs > res.obs
    res = res.succ_time
    res.ore -= bprint.geo_robot_c_ore
    res.obs -= bprint.geo_robot_c_obs
    res.geo_rbts += 1
    res
  end

  def to_hash
    (time +
      ore * 25 +
      cly * 25 * 25 +
      obs * 25 * 25 * 25 +
      geo * 25 * 25 * 25 * 25 +
      ore_rbts * 25 * 25 * 25 * 25 * 25 +
      cly_rbts * 25 * 25 * 25 * 25 * 25 * 25 +
      obs_rbts * 25 * 25 * 25 * 25 * 25 * 25 * 25 +
      geo_rbts * 25 * 25 * 25 * 25 * 25 * 25 * 25 * 25)
  end
end

class StateList
  def initialize
    @list = []
    @black = Set.new
  end

  def add(state)
    return if state == nil

    # normalize
    state.ore = 10 if state.ore > 10
    state.cly = 25 if state.cly > 25
    state.obs = 25 if state.obs > 25

    return if @black.member? state.to_hash
    @black.add state.to_hash
    @list.push state
  end

  def pop
    @list.shift
  end
end

RGX = /Blueprint (\d+)\: Each ore robot costs (\d+) ore\. Each clay robot costs (\d+) ore\. Each obsidian robot costs (\d+) ore and (\d+) clay\. Each geode robot costs (\d+) ore and (\d+) obsidian\./

def run
  bprints = []

  File.open(ARGV[0]).each do |line|
    next if line.strip.empty?
    match = line.strip.match RGX
    raise "wrong on #{line.strip}" unless match
    raise "wrong" unless match.captures.count == 7

    bprint = Bprint.new *(match.captures.map(&:to_i))
    bprints.push bprint
  end

  get_geo = -> (bprint, max_time) {
    start = State.new 0, 0, 0, 0, 0, 1, 0, 0, 0
    black = Set.new
    states = StateList.new
    states.add start
    max_geo = 0
    max_state = 0
    max_ore_cost = [bprint.ore_rbt_c_ore, bprint.cly_rbt_c_ore, bprint.obs_robot_c_ore, bprint.geo_robot_c_ore].max
    min_ore_cost = [bprint.ore_rbt_c_ore, bprint.cly_rbt_c_ore, bprint.obs_robot_c_ore, bprint.geo_robot_c_ore].min
    loop do
      curr = states.pop
      break unless curr
      break if curr.time > max_time
      if curr.geo > max_geo
        max_geo = curr.geo
        max_state = curr
      end

      next states.add(curr.succ_time) if curr.ore < min_ore_cost

      after_geo = curr.buy_geo_rbt(bprint)
      states.add after_geo
      next if after_geo

      after_obs = curr.buy_obs_rbt(bprint)
      states.add after_obs

      if curr.cly_rbts < bprint.obs_robot_c_cly
        states.add curr.buy_cly_rbt(bprint)
      end

      if curr.ore_rbts < max_ore_cost
        states.add curr.buy_ore_rbt(bprint)
      end

      states.add curr.succ_time
    end
    max_geo
  }

  puts bprints.map{|bprint| get_geo.call(bprint, 24) * bprint.id}.sum
  puts bprints.take(3).map{|bprint| get_geo.call(bprint, 32) }.reduce(:*)

end

run
