Monke = Struct.new(:items, :op, :test_mod, :test_true, :test_false, :inspections)

def run
  input_path = ARGV[0]

  parsing_monkey = nil
  monkeys = []

  File.open(input_path).each do |line|
    if (match = line.strip.match /Monkey (\d+)\:/)
      raise "wrong" unless match.captures&.count == 1
      parsing_monkey = Monke.new(nil, nil, nil, nil, nil, 0)
      monkeys.push parsing_monkey
      next
    end

    if (match = line.strip.match(/Starting items\:((?:\,? [0-9]+)+)$/))
      raise "wrong" unless match.captures&.count > 0
      parsing_monkey.items = match.captures[0].split(',').map(&:strip).map(&:to_i)
    end

    if (match = line.strip.match(/Operation\:(.*)$/))
      raise "wrong" unless match.captures&.count > 0
      parsing_monkey.op = match.captures[0].strip[6..-1]
    end
    
    if (match = line.strip.match(/Test\: divisible by (\d+)$/))
      raise "wrong" unless match.captures&.count == 1
      parsing_monkey.test_mod = match.captures[0].strip.to_i
    end

    if (match = line.strip.match(/If true\: throw to monkey (\d+)$/))
      raise "wrong" unless match.captures&.count == 1
      parsing_monkey.test_true = match.captures[0].strip.to_i
    end

    if (match = line.strip.match(/If false\: throw to monkey (\d+)$/))
      raise "wrong" unless match.captures&.count == 1
      parsing_monkey.test_false = match.captures[0].strip.to_i
    end
  end

  monkeys2 = monkeys.map(&:dup).each{|m| m.items = m.items.dup}
  divisors_product = monkeys.map(&:test_mod).inject(&:*) * 3

  simulate = -> (iters, div_by3) {
    monkeys_dup = monkeys.map(&:dup).each{|m| m.items = m.items.dup}

    iters.times do
      monkeys_dup.each_with_index do |monke, idx|
        monke.inspections += monke.items.count
        monke.items.each do |item|
          old = item
          new_item = eval(monke.op)
          new_item = if div_by3 then new_item / 3 else new_item % divisors_product end
          monkeys_dup[(new_item % monke.test_mod) == 0 ? monke.test_true : monke.test_false].items.push new_item
        end
        monke.items = []
      end
    end

    monkeys_dup.map(&:inspections).sort.reverse.take(2).inject(&:*)
  }

  puts simulate.call(20, true)
  puts simulate.call(10_000, false)
end

run
